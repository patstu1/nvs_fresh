// android/app/src/main/kotlin/com/nvs/app/FaceTecMethodChannel.kt

package com.nvs.app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import com.facetec.sdk.*

class FaceTecMethodChannel(private val context: Context) : MethodChannel.MethodCallHandler {
    
    companion object {
        private const val CHANNEL_NAME = "nvs/facetec"
    }
    
    private var methodChannel: MethodChannel? = null
    
    fun configureMethodChannel(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel?.setMethodCallHandler(this)
    }
    
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                initializeFaceTec(call, result)
            }
            "enrollment" -> {
                performEnrollment(call, result)
            }
            "authenticate" -> {
                performAuthentication(call, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
    
    private fun initializeFaceTec(call: MethodCall, result: MethodChannel.Result) {
        try {
            val productionKey = call.argument<String>("productionKey")
            val deviceKeyIdentifier = call.argument<String>("deviceKeyIdentifier")
            
            if (productionKey.isNullOrEmpty()) {
                result.error("INVALID_KEY", "Production key is required", null)
                return
            }
            
            // Initialize FaceTec SDK
            FaceTecSDK.initializeInProductionMode(
                context,
                productionKey,
                deviceKeyIdentifier ?: "nvs_device_key"
            ) { isInitialized ->
                if (isInitialized) {
                    // Configure customization
                    configureFaceTecCustomization()
                    result.success(mapOf("initialized" to true))
                } else {
                    result.error("INIT_FAILED", "FaceTec initialization failed", null)
                }
            }
        } catch (e: Exception) {
            result.error("INIT_ERROR", "FaceTec initialization error: ${e.message}", null)
        }
    }
    
    private fun performEnrollment(call: MethodCall, result: MethodChannel.Result) {
        try {
            val userIdentifier = call.argument<String>("userIdentifier") ?: "user_default"
            
            // Create enrollment processor
            val enrollmentProcessor = object : FaceTecFaceScanProcessor {
                override fun processSessionWhileFaceTecSDKWaits(
                    sessionResult: FaceTecSessionResult,
                    faceScanResultCallback: FaceTecFaceScanResultCallback
                ) {
                    if (sessionResult.status == FaceTecSessionStatus.SESSION_COMPLETED_SUCCESSFULLY) {
                        // Process the successful scan
                        val faceScanData = sessionResult.faceScan
                        val auditTrailImage = sessionResult.auditTrail?.get(0)
                        
                        // In a real implementation, you would send this to your server
                        // For now, we'll simulate success
                        faceScanResultCallback.onFaceScanResultSucceeded(
                            FaceTecFaceScanResult.createSuccessResult()
                        )
                        
                        result.success(mapOf(
                            "success" to true,
                            "faceScan" to (faceScanData ?: ""),
                            "auditTrailImage" to (auditTrailImage ?: "")
                        ))
                    } else {
                        faceScanResultCallback.onFaceScanResultFailed()
                        result.success(mapOf(
                            "success" to false,
                            "message" to "Enrollment failed: ${sessionResult.status}"
                        ))
                    }
                }
            }
            
            // Start the enrollment session
            FaceTecSDK.launchSession(
                context as android.app.Activity,
                enrollmentProcessor,
                sessionResult -> {
                    // This callback is handled in the processor above
                }
            )
            
        } catch (e: Exception) {
            result.error("ENROLLMENT_ERROR", "Enrollment error: ${e.message}", null)
        }
    }
    
    private fun performAuthentication(call: MethodCall, result: MethodChannel.Result) {
        try {
            val userIdentifier = call.argument<String>("userIdentifier") ?: "user_default"
            
            // Create authentication processor
            val authProcessor = object : FaceTecFaceScanProcessor {
                override fun processSessionWhileFaceTecSDKWaits(
                    sessionResult: FaceTecSessionResult,
                    faceScanResultCallback: FaceTecFaceScanResultCallback
                ) {
                    if (sessionResult.status == FaceTecSessionStatus.SESSION_COMPLETED_SUCCESSFULLY) {
                        // Process the successful scan
                        val faceScanData = sessionResult.faceScan
                        val auditTrailImage = sessionResult.auditTrail?.get(0)
                        
                        // In a real implementation, you would send this to your server for verification
                        // For now, we'll simulate success
                        faceScanResultCallback.onFaceScanResultSucceeded(
                            FaceTecFaceScanResult.createSuccessResult()
                        )
                        
                        result.success(mapOf(
                            "success" to true,
                            "faceScan" to (faceScanData ?: ""),
                            "auditTrailImage" to (auditTrailImage ?: "")
                        ))
                    } else {
                        faceScanResultCallback.onFaceScanResultFailed()
                        result.success(mapOf(
                            "success" to false,
                            "message" to "Authentication failed: ${sessionResult.status}"
                        ))
                    }
                }
            }
            
            // Start the authentication session
            FaceTecSDK.launchSession(
                context as android.app.Activity,
                authProcessor,
                sessionResult -> {
                    // This callback is handled in the processor above
                }
            )
            
        } catch (e: Exception) {
            result.error("AUTH_ERROR", "Authentication error: ${e.message}", null)
        }
    }
    
    private fun configureFaceTecCustomization() {
        // Configure FaceTec UI to match NVS cyberpunk aesthetic
        val currentCustomization = FaceTecCustomization()
        
        // Frame customization
        currentCustomization.frameCustomization.borderColor = android.graphics.Color.parseColor("#00FFFF") // Cyan
        currentCustomization.frameCustomization.borderWidth = 4
        
        // Oval customization  
        currentCustomization.ovalCustomization.strokeColor = android.graphics.Color.parseColor("#00FFFF")
        currentCustomization.ovalCustomization.progressColor1 = android.graphics.Color.parseColor("#00FFFF")
        currentCustomization.ovalCustomization.progressColor2 = android.graphics.Color.parseColor("#0080FF")
        
        // Feedback customization
        currentCustomization.feedbackCustomization.backgroundColor = android.graphics.Color.parseColor("#000000")
        currentCustomization.feedbackCustomization.textColor = android.graphics.Color.parseColor("#FFFFFF")
        
        // Guidance customization
        currentCustomization.guidanceCustomization.backgroundColors = intArrayOf(
            android.graphics.Color.parseColor("#000000"),
            android.graphics.Color.parseColor("#001122")
        )
        currentCustomization.guidanceCustomization.foregroundColor = android.graphics.Color.parseColor("#FFFFFF")
        currentCustomization.guidanceCustomization.buttonBackgroundNormalColor = android.graphics.Color.parseColor("#00FFFF")
        currentCustomization.guidanceCustomization.buttonTextNormalColor = android.graphics.Color.parseColor("#000000")
        
        // Apply the customization
        FaceTecSDK.setCustomization(currentCustomization)
    }
}

