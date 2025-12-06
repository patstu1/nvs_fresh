package com.nvs.app

import android.Manifest
import android.bluetooth.*
import android.bluetooth.le.*
import android.content.Context
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.records.*
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.time.Instant
import java.time.ZonedDateTime
import java.util.*
import kotlin.math.max
import kotlin.math.min

/**
 * Native Android bridge for biometric data collection from wearables and Health Connect
 */
class BiometricBridge : FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private lateinit var context: Context
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    // Health Connect client
    private var healthConnectClient: HealthConnectClient? = null

    // Biometric monitoring
    private var isMonitoring = false
    private var lastHeartRateValue = 0.0
    private var lastHrvValue = 0.0
    private var lastBodyTemperature = 98.6
    private var lastStressLevel = 0.0

    // Bluetooth for Oura Ring
    private var bluetoothManager: BluetoothManager? = null
    private var bluetoothAdapter: BluetoothAdapter? = null
    private var bluetoothLeScanner: BluetoothLeScanner? = null
    private var ouraDevice: BluetoothDevice? = null
    private var ouraGatt: BluetoothGatt? = null

    // Coroutine scope for async operations
    private val coroutineScope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private var monitoringJob: Job? = null

    // Data collection timer
    private val handler = Handler(Looper.getMainLooper())
    private var dataCollectionRunnable: Runnable? = null

    companion object {
        private const val METHOD_CHANNEL_NAME = "nvs/biometric"
        private const val EVENT_CHANNEL_NAME = "nvs/biometric_stream"
        private const val DATA_COLLECTION_INTERVAL = 5000L // 5 seconds

        // Bluetooth UUIDs for Oura Ring (would need actual UUIDs from Oura)
        private val OURA_SERVICE_UUID = UUID.fromString("6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
        private val OURA_CHARACTERISTIC_UUID = UUID.fromString("6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel.setStreamHandler(this)

        initializeHealthConnect()
        initializeBluetooth()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        stopBiometricMonitoring()
        coroutineScope.cancel()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "requestPermissions" -> requestHealthPermissions(result)
            "startBiometricMonitoring" -> startBiometricMonitoring(result)
            "stopBiometricMonitoring" -> stopBiometricMonitoring(result)
            "getCurrentBiometrics" -> getCurrentBiometrics(result)
            "initializeOuraRing" -> initializeOuraRingConnection(result)
            "calibrateBioThresholds" -> {
                val args = call.arguments as? Map<String, Any>
                calibrateBioThresholds(args ?: emptyMap(), result)
            }
            else -> result.notImplemented()
        }
    }

    // MARK: - Health Connect Integration

    private fun initializeHealthConnect() {
        if (HealthConnectClient.isAvailable(context)) {
            healthConnectClient = HealthConnectClient.getOrCreate(context)
        }
    }

    private fun requestHealthPermissions(result: MethodChannel.Result) {
        val permissions = setOf(
            HeartRateRecord::class,
            HeartRateVariabilityRmssdRecord::class,
            BodyTemperatureRecord::class,
            StressRecord::class,
            SleepStageRecord::class,
            RespiratoryRateRecord::class,
            RestingHeartRateRecord::class
        )

        coroutineScope.launch {
            try {
                healthConnectClient?.permissionController?.requestPermissions(
                    context as androidx.activity.ComponentActivity,
                    permissions
                )?.let { grantedPermissions ->
                    val response = mapOf(
                        "status" to "authorized",
                        "message" to "Health Connect permissions granted",
                        "granted_permissions" to grantedPermissions.size
                    )
                    result.success(response)
                } ?: run {
                    result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
                }
            } catch (e: Exception) {
                result.error("PERMISSION_ERROR", e.message, null)
            }
        }
    }

    // MARK: - Real-time Biometric Monitoring

    private fun startBiometricMonitoring(result: MethodChannel.Result) {
        if (isMonitoring) {
            result.success(mapOf(
                "status" to "already_monitoring",
                "message" to "Biometric monitoring already active"
            ))
            return
        }

        isMonitoring = true

        // Start continuous monitoring job
        monitoringJob = coroutineScope.launch {
            while (isMonitoring) {
                try {
                    collectLatestBiometrics()
                    delay(DATA_COLLECTION_INTERVAL)
                } catch (e: Exception) {
                    // Handle monitoring errors gracefully
                    streamBiometricUpdate(mapOf(
                        "type" to "error",
                        "message" to e.message,
                        "timestamp" to System.currentTimeMillis()
                    ))
                }
            }
        }

        // Start periodic data streaming
        startDataCollectionTimer()

        result.success(mapOf(
            "status" to "monitoring_started",
            "message" to "Real-time biometric monitoring initiated"
        ))
    }

    private fun stopBiometricMonitoring(result: MethodChannel.Result? = null) {
        isMonitoring = false
        monitoringJob?.cancel()
        monitoringJob = null

        dataCollectionRunnable?.let { handler.removeCallbacks(it) }
        dataCollectionRunnable = null

        result?.success(mapOf(
            "status" to "monitoring_stopped",
            "message" to "Biometric monitoring terminated"
        ))
    }

    private fun startDataCollectionTimer() {
        dataCollectionRunnable = object : Runnable {
            override fun run() {
                if (isMonitoring) {
                    coroutineScope.launch {
                        collectAndStreamBiometrics()
                    }
                    handler.postDelayed(this, DATA_COLLECTION_INTERVAL)
                }
            }
        }
        dataCollectionRunnable?.let { handler.post(it) }
    }

    private suspend fun collectLatestBiometrics() {
        healthConnectClient?.let { client ->
            val now = Instant.now()
            val twentyFourHoursAgo = now.minusSeconds(86400)

            try {
                // Collect heart rate data
                val heartRateRequest = ReadRecordsRequest(
                    recordType = HeartRateRecord::class,
                    timeRangeFilter = TimeRangeFilter.between(twentyFourHoursAgo, now)
                )
                val heartRateRecords = client.readRecords(heartRateRequest)
                if (heartRateRecords.records.isNotEmpty()) {
                    val latestHeartRate = heartRateRecords.records.last()
                    lastHeartRateValue = latestHeartRate.beatsPerMinute.toDouble()

                    streamBiometricUpdate(mapOf(
                        "type" to "heart_rate",
                        "value" to lastHeartRateValue,
                        "timestamp" to latestHeartRate.time.toEpochMilli(),
                        "source" to "Health Connect"
                    ))
                }

                // Collect HRV data
                val hrvRequest = ReadRecordsRequest(
                    recordType = HeartRateVariabilityRmssdRecord::class,
                    timeRangeFilter = TimeRangeFilter.between(twentyFourHoursAgo, now)
                )
                val hrvRecords = client.readRecords(hrvRequest)
                if (hrvRecords.records.isNotEmpty()) {
                    val latestHrv = hrvRecords.records.last()
                    lastHrvValue = latestHrv.heartRateVariabilityMillis

                    streamBiometricUpdate(mapOf(
                        "type" to "hrv",
                        "value" to lastHrvValue,
                        "timestamp" to latestHrv.time.toEpochMilli(),
                        "source" to "Health Connect"
                    ))
                }

                // Collect body temperature data
                val temperatureRequest = ReadRecordsRequest(
                    recordType = BodyTemperatureRecord::class,
                    timeRangeFilter = TimeRangeFilter.between(twentyFourHoursAgo, now)
                )
                val temperatureRecords = client.readRecords(temperatureRequest)
                if (temperatureRecords.records.isNotEmpty()) {
                    val latestTemp = temperatureRecords.records.last()
                    lastBodyTemperature = latestTemp.temperature.inFahrenheit
                }

                // Collect stress data
                val stressRequest = ReadRecordsRequest(
                    recordType = StressRecord::class,
                    timeRangeFilter = TimeRangeFilter.between(twentyFourHoursAgo, now)
                )
                val stressRecords = client.readRecords(stressRequest)
                if (stressRecords.records.isNotEmpty()) {
                    val latestStress = stressRecords.records.last()
                    lastStressLevel = when (latestStress.stress) {
                        StressRecord.STRESS_LEVEL_LOW -> 0.2
                        StressRecord.STRESS_LEVEL_MEDIUM -> 0.5
                        StressRecord.STRESS_LEVEL_HIGH -> 0.8
                        else -> 0.0
                    }
                }

            } catch (e: Exception) {
                // Handle data collection errors
                streamBiometricUpdate(mapOf(
                    "type" to "collection_error",
                    "message" to e.message,
                    "timestamp" to System.currentTimeMillis()
                ))
            }
        }
    }

    private suspend fun collectAndStreamBiometrics() {
        val biometricData = mapOf(
            "timestamp" to System.currentTimeMillis(),
            "heart_rate" to lastHeartRateValue,
            "hrv" to lastHrvValue,
            "body_temperature" to lastBodyTemperature,
            "stress_level" to lastStressLevel,
            "bio_signature" to generateBioSignature(),
            "mood_inference" to inferMoodFromBiometrics(),
            "arousal_level" to calculateArousalLevel(),
            "social_receptiveness" to calculateSocialReceptiveness()
        )

        streamBiometricUpdate(biometricData)
    }

    private fun getCurrentBiometrics(result: MethodChannel.Result) {
        val currentBiometrics = mapOf(
            "heart_rate" to lastHeartRateValue,
            "hrv" to lastHrvValue,
            "body_temperature" to lastBodyTemperature,
            "stress_level" to lastStressLevel,
            "timestamp" to System.currentTimeMillis(),
            "bio_signature" to generateBioSignature(),
            "mood_inference" to inferMoodFromBiometrics(),
            "arousal_level" to calculateArousalLevel(),
            "social_receptiveness" to calculateSocialReceptiveness(),
            "device_sources" to getConnectedDeviceSources()
        )

        result.success(currentBiometrics)
    }

    // MARK: - Bio-Neural Analysis

    private fun generateBioSignature(): Map<String, Double> {
        return mapOf(
            "parasympathetic_dominance" to calculateParasympatheticDominance(),
            "sympathetic_activation" to calculateSympatheticActivation(),
            "cognitive_load" to calculateCognitiveLoad(),
            "emotional_stability" to calculateEmotionalStability(),
            "energy_level" to calculateEnergyLevel()
        )
    }

    private fun inferMoodFromBiometrics(): Map<String, Any> {
        val moodVector = mapOf(
            "valence" to calculateValence(),
            "arousal" to calculateArousalLevel(),
            "dominance" to calculateDominance(),
            "confidence" to calculateMoodConfidence()
        )

        val inferredMood = classifyMood(moodVector)

        return mapOf(
            "mood" to inferredMood,
            "vector" to moodVector,
            "reliability" to calculateMoodConfidence()
        )
    }

    private fun calculateArousalLevel(): Double {
        val hrArousal = min(max((lastHeartRateValue - 60) / 100, 0.0), 1.0)
        val hrvArousal = min(max((50 - lastHrvValue) / 50, 0.0), 1.0)
        val stressArousal = lastStressLevel
        val tempArousal = min(max((lastBodyTemperature - 98.6) / 2, 0.0), 1.0)

        return (hrArousal * 0.4 + hrvArousal * 0.3 + stressArousal * 0.2 + tempArousal * 0.1)
    }

    private fun calculateSocialReceptiveness(): Double {
        val baseReceptiveness = 0.5
        val hrvBonus = if (lastHrvValue > 30) 0.2 else -0.1
        val hrPenalty = if (lastHeartRateValue > 100) -0.2 else 0.1
        val stressPenalty = lastStressLevel * -0.3

        return min(max(baseReceptiveness + hrvBonus + hrPenalty + stressPenalty, 0.0), 1.0)
    }

    // MARK: - Helper Calculations

    private fun calculateParasympatheticDominance(): Double {
        return min(lastHrvValue / 50.0, 1.0)
    }

    private fun calculateSympatheticActivation(): Double {
        return min(max((lastHeartRateValue - 60) / 60.0, 0.0), 1.0)
    }

    private fun calculateCognitiveLoad(): Double {
        return min(max((40 - lastHrvValue) / 40.0, 0.0), 1.0) + lastStressLevel * 0.3
    }

    private fun calculateEmotionalStability(): Double {
        return min(lastHrvValue / 60.0, 1.0) * (1.0 - lastStressLevel)
    }

    private fun calculateEnergyLevel(): Double {
        val hrEnergy = min(max((lastHeartRateValue - 50) / 70.0, 0.0), 1.0)
        val tempEnergy = min(max((lastBodyTemperature - 98.0) / 2.0, 0.0), 1.0)
        val stressReduction = 1.0 - (lastStressLevel * 0.5)
        return (hrEnergy + tempEnergy) / 2.0 * stressReduction
    }

    private fun calculateValence(): Double {
        val hrvValence = min(lastHrvValue / 50.0, 1.0)
        val hrValence = max(1.0 - (lastHeartRateValue - 60) / 60.0, 0.0)
        val stressValence = 1.0 - lastStressLevel
        return (hrvValence + hrValence + stressValence) / 3.0
    }

    private fun calculateDominance(): Double {
        return min(max((lastHeartRateValue - 70) / 50.0, 0.0), 1.0) * (1.0 - lastStressLevel * 0.5)
    }

    private fun calculateMoodConfidence(): Double {
        val dataQuality = if (lastHeartRateValue > 0 && lastHrvValue > 0) 1.0 else 0.5
        val temporalConsistency = 0.8 // Simplified
        return dataQuality * temporalConsistency
    }

    private fun classifyMood(vector: Map<String, Double>): String {
        val valence = vector["valence"] ?: 0.5
        val arousal = vector["arousal"] ?: 0.5

        return when {
            valence >= 0.6 && arousal >= 0.6 -> "excited"
            valence >= 0.6 && arousal < 0.4 -> "content"
            valence < 0.4 && arousal >= 0.6 -> "anxious"
            valence < 0.4 && arousal < 0.4 -> "melancholy"
            else -> "neutral"
        }
    }

    private fun getConnectedDeviceSources(): List<String> {
        val sources = mutableListOf("Android Health Connect")
        if (lastHeartRateValue > 0) sources.add("Wearable Device")
        if (ouraGatt?.getConnectionState(ouraDevice) == BluetoothProfile.STATE_CONNECTED) {
            sources.add("Oura Ring")
        }
        return sources
    }

    // MARK: - Oura Ring Bluetooth Integration

    private fun initializeBluetooth() {
        bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothAdapter = bluetoothManager?.adapter
        bluetoothLeScanner = bluetoothAdapter?.bluetoothLeScanner
    }

    private fun initializeOuraRingConnection(result: MethodChannel.Result) {
        if (bluetoothAdapter?.isEnabled != true) {
            result.error("BLUETOOTH_DISABLED", "Bluetooth is not enabled", null)
            return
        }

        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.BLUETOOTH_SCAN)
            != PackageManager.PERMISSION_GRANTED) {
            result.error("PERMISSION_MISSING", "Bluetooth permissions required", null)
            return
        }

        val scanCallback = object : ScanCallback() {
            override fun onScanResult(callbackType: Int, scanResult: ScanResult) {
                val device = scanResult.device
                if (device.name?.contains("Oura", ignoreCase = true) == true) {
                    ouraDevice = device
                    bluetoothLeScanner?.stopScan(this)
                    connectToOuraRing(device)
                }
            }

            override fun onScanFailed(errorCode: Int) {
                result.error("SCAN_FAILED", "Bluetooth scan failed: $errorCode", null)
            }
        }

        bluetoothLeScanner?.startScan(scanCallback)
        result.success(mapOf("status" to "scanning", "message" to "Scanning for Oura Ring"))
    }

    private fun connectToOuraRing(device: BluetoothDevice) {
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.BLUETOOTH_CONNECT)
            != PackageManager.PERMISSION_GRANTED) {
            return
        }

        val gattCallback = object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
                if (newState == BluetoothProfile.STATE_CONNECTED) {
                    ouraGatt = gatt
                    gatt.discoverServices()
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
                val service = gatt.getService(OURA_SERVICE_UUID)
                val characteristic = service?.getCharacteristic(OURA_CHARACTERISTIC_UUID)
                characteristic?.let {
                    gatt.setCharacteristicNotification(it, true)
                }
            }

            override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
                processOuraRingData(characteristic.value)
            }
        }

        device.connectGatt(context, false, gattCallback)
    }

    private fun processOuraRingData(data: ByteArray) {
        // Process Oura Ring data (simplified)
        val temperature = extractTemperatureFromOuraData(data)

        val ouraData = mapOf(
            "type" to "oura_ring",
            "temperature" to temperature,
            "timestamp" to System.currentTimeMillis()
        )

        streamBiometricUpdate(ouraData)
    }

    private fun extractTemperatureFromOuraData(data: ByteArray): Double {
        // Placeholder - actual implementation would parse Oura's data format
        return 98.6 + (Math.random() * 2 - 1)
    }

    // MARK: - Bio-threshold Calibration

    private fun calibrateBioThresholds(args: Map<String, Any>, result: MethodChannel.Result) {
        val userAge = (args["age"] as? Number)?.toInt() ?: 30
        val userGender = args["gender"] as? String ?: "unknown"
        val fitnessLevel = args["fitness_level"] as? String ?: "moderate"

        val calibratedThresholds = mapOf(
            "max_heart_rate" to calculateMaxHeartRate(userAge),
            "resting_heart_rate" to calculateRestingHeartRate(fitnessLevel),
            "hrv_baseline" to calculateHRVBaseline(userAge, userGender),
            "arousal_threshold" to 0.7,
            "receptiveness_threshold" to 0.6
        )

        result.success(mapOf(
            "status" to "calibrated",
            "thresholds" to calibratedThresholds
        ))
    }

    private fun calculateMaxHeartRate(age: Int): Int = 220 - age

    private fun calculateRestingHeartRate(fitness: String): Int {
        return when (fitness) {
            "high" -> 50
            "moderate" -> 65
            "low" -> 80
            else -> 70
        }
    }

    private fun calculateHRVBaseline(age: Int, gender: String): Double {
        val baseHRV = if (gender == "male") 35.0 else 40.0
        val ageAdjustment = (40 - age) * 0.5
        return max(baseHRV + ageAdjustment, 20.0)
    }

    private fun streamBiometricUpdate(data: Map<String, Any>) {
        handler.post {
            eventSink?.success(data)
        }
    }

    // MARK: - Event Stream Handler

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}

