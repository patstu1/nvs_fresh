// lib/core/models/quantum_user_profile.dart
// Data models backing the quantum authentication and privacy services.

import 'package:nvs/models/user_status.dart';

/// Primary user profile maintained by the quantum auth sync service.
class QuantumUserProfile {
  QuantumUserProfile({
    required this.walletAddress,
    required this.profileNftAddress,
    required this.ipfsMetadataUri,
    required this.metaplexCollectionId,
    required this.displayName,
    this.age,
    required this.primaryPhotoIpfsUri,
    required List<String> albumPhotoIpfsUris,
    this.location,
    this.privacy = const PrivacyConfiguration(),
    List<String>? roleTags,
    List<String>? moodTags,
    List<String>? interestTags,
    this.verification = VerificationStatus.unverified,
    this.neuralProfile,
    this.behavioralSignature,
    this.activityPattern,
    this.astroSignature,
    this.resonanceFreq,
    this.biometricSignature,
    this.preferences,
    this.status = UserStatusType.offline,
    required this.createdAt,
    required this.updatedAt,
    this.subscription = SubscriptionTier.free,
  })  : albumPhotoIpfsUris = List.unmodifiable(albumPhotoIpfsUris),
        roleTags = List.unmodifiable(roleTags ?? const <String>[]),
        moodTags = List.unmodifiable(moodTags ?? const <String>[]),
        _interestTags = List.unmodifiable(interestTags ?? const <String>[]);

  final String walletAddress;
  final String profileNftAddress;
  final String ipfsMetadataUri;
  final String metaplexCollectionId;
  final String displayName;
  final int? age;
  final String primaryPhotoIpfsUri;
  final List<String> albumPhotoIpfsUris;
  final GeoQuantumCoordinates? location;
  final PrivacyConfiguration privacy;
  final List<String> roleTags;
  final List<String> moodTags;
  final List<String> _interestTags;
  final VerificationStatus verification;
  final NeuralCompatibilityProfile? neuralProfile;
  final BehavioralSignature? behavioralSignature;
  final ActivityPattern? activityPattern;
  final AstrologicalSignature? astroSignature;
  final QuantumResonanceFrequency? resonanceFreq;
  final BiometricProfile? biometricSignature;
  final QuantumPreferenceProfile? preferences;
  final UserStatusType status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SubscriptionTier subscription;

  /// Backwards compatible accessor used by legacy services.
  List<String> get interests => _interestTags;

  QuantumUserProfile copyWith({
    String? walletAddress,
    String? profileNftAddress,
    String? ipfsMetadataUri,
    String? metaplexCollectionId,
    String? displayName,
    int? age,
    String? primaryPhotoIpfsUri,
    List<String>? albumPhotoIpfsUris,
    GeoQuantumCoordinates? location,
    PrivacyConfiguration? privacy,
    List<String>? roleTags,
    List<String>? moodTags,
    List<String>? interestTags,
    VerificationStatus? verification,
    NeuralCompatibilityProfile? neuralProfile,
    BehavioralSignature? behavioralSignature,
    ActivityPattern? activityPattern,
    AstrologicalSignature? astroSignature,
    QuantumResonanceFrequency? resonanceFreq,
    BiometricProfile? biometricSignature,
    QuantumPreferenceProfile? preferences,
    UserStatusType? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    SubscriptionTier? subscription,
  }) {
    return QuantumUserProfile(
      walletAddress: walletAddress ?? this.walletAddress,
      profileNftAddress: profileNftAddress ?? this.profileNftAddress,
      ipfsMetadataUri: ipfsMetadataUri ?? this.ipfsMetadataUri,
      metaplexCollectionId: metaplexCollectionId ?? this.metaplexCollectionId,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      primaryPhotoIpfsUri: primaryPhotoIpfsUri ?? this.primaryPhotoIpfsUri,
      albumPhotoIpfsUris: albumPhotoIpfsUris ?? this.albumPhotoIpfsUris,
      location: location ?? this.location,
      privacy: privacy ?? this.privacy,
      roleTags: roleTags ?? this.roleTags,
      moodTags: moodTags ?? this.moodTags,
      interestTags: interestTags ?? _interestTags,
      verification: verification ?? this.verification,
      neuralProfile: neuralProfile ?? this.neuralProfile,
      behavioralSignature: behavioralSignature ?? this.behavioralSignature,
      activityPattern: activityPattern ?? this.activityPattern,
      astroSignature: astroSignature ?? this.astroSignature,
      resonanceFreq: resonanceFreq ?? this.resonanceFreq,
      biometricSignature: biometricSignature ?? this.biometricSignature,
      preferences: preferences ?? this.preferences,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subscription: subscription ?? this.subscription,
    );
  }
}

/// Geo-aware coordinates enhanced with quantum clustering metadata.
class GeoQuantumCoordinates {
  const GeoQuantumCoordinates({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.quantumClusterId,
    required this.clusterDensity,
    required this.lastLocationUpdate,
  });

  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final String quantumClusterId;
  final double clusterDensity;
  final DateTime lastLocationUpdate;
}

/// Visibility controls for profile data.
class VisibilitySettings {
  const VisibilitySettings({
    this.showAge = true,
    this.showDistance = true,
    this.showLastActive = true,
    this.showOnlineStatus = true,
    this.showCompatibilityScore = true,
    this.showBiometricSync = false,
  });

  final bool showAge;
  final bool showDistance;
  final bool showLastActive;
  final bool showOnlineStatus;
  final bool showCompatibilityScore;
  final bool showBiometricSync;
}

/// Privacy configuration used by quantum privacy & ZK services.
class PrivacyConfiguration {
  const PrivacyConfiguration({
    this.isIncognitoMode = false,
    this.shareLocation = true,
    this.shareBiometrics = false,
    this.shareActivityPatterns = false,
    this.allowQuantumAnalysis = true,
    this.enableZeroKnowledgeMode = false,
    this.hiddenDataFields = const <String>[],
    this.visibility = const VisibilitySettings(),
  });

  final bool isIncognitoMode;
  final bool shareLocation;
  final bool shareBiometrics;
  final bool shareActivityPatterns;
  final bool allowQuantumAnalysis;
  final bool enableZeroKnowledgeMode;
  final List<String> hiddenDataFields;
  final VisibilitySettings visibility;
}

enum VerificationStatus {
  unverified,
  emailVerified,
  governmentVerified,
  eliteVerified,
}

enum SubscriptionTier { free, plus, premium, elite }

/// Deep neural compatibility profile generated by the AI pipeline.
class NeuralCompatibilityProfile {
  const NeuralCompatibilityProfile({
    required this.personalityVector,
    required this.emotionalIntelligenceIndex,
    required this.emotionalProfile,
    required this.socialProfile,
    required this.neuralFeatureVector,
    required this.quantumEntanglementScore,
    required this.preferredPersonalityTypes,
    required this.preferences,
    required this.modelVersion,
    required this.lastAnalysis,
  });

  final PersonalityVector personalityVector;
  final double emotionalIntelligenceIndex;
  final EmotionalProfile emotionalProfile;
  final SocialInteractionProfile socialProfile;
  final Map<String, double> neuralFeatureVector;
  final double quantumEntanglementScore;
  final List<String> preferredPersonalityTypes;
  final CompatibilityPreferences preferences;
  final String modelVersion;
  final DateTime lastAnalysis;
}

class PersonalityVector {
  const PersonalityVector({
    required this.extroversion,
    required this.agreeableness,
    required this.conscientiousness,
    required this.neuroticism,
    required this.openness,
    required this.dominance,
    required this.submission,
    required this.intimacyPreference,
    required this.adventurousness,
    required this.emotionalExpressiveness,
    required this.intellectualCuriosity,
    required this.confidenceScores,
  });

  final double extroversion;
  final double agreeableness;
  final double conscientiousness;
  final double neuroticism;
  final double openness;
  final double dominance;
  final double submission;
  final double intimacyPreference;
  final double adventurousness;
  final double emotionalExpressiveness;
  final double intellectualCuriosity;
  final Map<String, double> confidenceScores;
}

class EmotionalProfile {
  const EmotionalProfile({
    required this.emotionalStability,
    required this.empathyLevel,
    required this.stressResilience,
    required this.moodVariability,
    required this.primaryEmotionalTriggers,
    required this.emotionalRegulationStrategies,
  });

  final double emotionalStability;
  final double empathyLevel;
  final double stressResilience;
  final double moodVariability;
  final List<String> primaryEmotionalTriggers;
  final Map<String, double> emotionalRegulationStrategies;
}

class SocialInteractionProfile {
  const SocialInteractionProfile({
    required this.communicationStyle,
    required this.conflictResolutionStyle,
    required this.intimacyBuildingPattern,
    required this.boundaryFlexibility,
    required this.preferredCommunicationChannels,
    required this.socialEnergyPatterns,
  });

  final double communicationStyle;
  final double conflictResolutionStyle;
  final double intimacyBuildingPattern;
  final double boundaryFlexibility;
  final List<String> preferredCommunicationChannels;
  final Map<String, double> socialEnergyPatterns;
}

class CompatibilityPreferences {
  const CompatibilityPreferences({
    required this.minCompatibilityScore,
    required this.dealBreakerTraits,
    required this.attractionFactors,
    required this.ageRange,
    required this.maxDistance,
    required this.requireBiometricSync,
    required this.requireAstroCompatibility,
  });

  final double minCompatibilityScore;
  final List<String> dealBreakerTraits;
  final List<String> attractionFactors;
  final AgeRange ageRange;
  final double maxDistance;
  final bool requireBiometricSync;
  final bool requireAstroCompatibility;
}

class AgeRange {
  const AgeRange({
    required this.min,
    required this.max,
  });

  final int min;
  final int max;
}

class BehavioralProfile {
  const BehavioralProfile({
    required this.communicationStyle,
    required this.socialEnergy,
    required this.riskTolerance,
    required this.emotionalStability,
    required this.opennessToExperience,
    required this.interactionFrequency,
    required this.responseTimePattern,
    this.preferredActivityTypes = const <String>[],
  });

  final double communicationStyle;
  final double socialEnergy;
  final double riskTolerance;
  final double emotionalStability;
  final double opennessToExperience;
  final double interactionFrequency;
  final Map<String, double> responseTimePattern;
  final List<String> preferredActivityTypes;
}

class BehavioralSignature {
  const BehavioralSignature({
    required this.avgSessionLength,
    required this.dailyOpenFrequency,
    required this.sectionTimeDistribution,
    required this.messageToViewRatio,
    required this.swipeToMatchRatio,
    required this.conversationInitiationRate,
    required this.profileCompletionRate,
    required this.photoUploadFrequency,
    required this.bioUpdateFrequency,
    required this.avgSocialRadius,
    required this.preferredInteractionTypes,
    required this.timeOfDayActivityPattern,
    required this.predictabilityIndex,
    required this.spontaneityScore,
    required this.consistencyRating,
  });

  final Duration avgSessionLength;
  final int dailyOpenFrequency;
  final Map<String, double> sectionTimeDistribution;
  final double messageToViewRatio;
  final double swipeToMatchRatio;
  final double conversationInitiationRate;
  final double profileCompletionRate;
  final double photoUploadFrequency;
  final double bioUpdateFrequency;
  final double avgSocialRadius;
  final List<String> preferredInteractionTypes;
  final Map<String, int> timeOfDayActivityPattern;
  final double predictabilityIndex;
  final double spontaneityScore;
  final double consistencyRating;
}

class ActivityPattern {
  const ActivityPattern({
    required this.weeklyActivity,
    required this.hourlyActivity,
    required this.peakActivityWindows,
    required this.consistencyScore,
    required this.sectionUsageTime,
  });

  final Map<String, double> weeklyActivity;
  final Map<int, double> hourlyActivity;
  final List<String> peakActivityWindows;
  final double consistencyScore;
  final Map<String, Duration> sectionUsageTime;
}

class AstrologicalSignature {
  const AstrologicalSignature({
    required this.sunSign,
    required this.planetaryPositions,
    required this.aspectAngles,
    required this.venusInfluence,
    required this.marsInfluence,
    required this.mercuryInfluence,
    required this.quantumAstroHash,
    required this.resonanceAmplitude,
  });

  final String sunSign;
  final Map<String, String> planetaryPositions;
  final Map<String, double> aspectAngles;
  final double venusInfluence;
  final double marsInfluence;
  final double mercuryInfluence;
  final String quantumAstroHash;
  final double resonanceAmplitude;
}

class QuantumResonanceFrequency {
  QuantumResonanceFrequency({
    required this.primaryFrequency,
    required List<double> harmonicFrequencies,
    required this.quantumCoherence,
    required this.entanglementPotential,
    required Map<String, double> dimensionalResonance,
    required this.lastQuantumAnalysis,
  })  : harmonicFrequencies = List.unmodifiable(harmonicFrequencies),
        dimensionalResonance = Map.unmodifiable(dimensionalResonance);

  final double primaryFrequency;
  final List<double> harmonicFrequencies;
  final double quantumCoherence;
  final double entanglementPotential;
  final Map<String, double> dimensionalResonance;
  final DateTime lastQuantumAnalysis;
}

class CircadianProfile {
  const CircadianProfile({
    required this.chronotype,
    required this.optimalSleepWindow,
    required this.optimalActivityWindow,
    required this.hourlyEnergyLevels,
    required this.melatoninPattern,
    required this.cortisolPattern,
  });

  final double chronotype;
  final Duration optimalSleepWindow;
  final Duration optimalActivityWindow;
  final Map<int, double> hourlyEnergyLevels;
  final double melatoninPattern;
  final double cortisolPattern;
}

enum WearableDeviceType {
  unknown,
  appleWatch,
  ouraRing,
  whoop,
  fitbit,
}

class BiometricProfile {
  const BiometricProfile({
    required this.avgHeartRateVariability,
    required this.restingHeartRate,
    required this.maxHeartRate,
    this.stressBaseline,
    this.arousalThreshold,
    this.electrodermalActivity,
    this.avgBodyTemperature,
    this.temperatureDelta,
    this.circadianRhythm,
    this.sleepQualityIndex,
    this.avgSleepDuration,
    this.recoveryIndex,
    this.activityLevel,
    this.vo2Max,
    this.fitnessMetrics = const <String, double>{},
    required this.lastSync,
    this.sourceDevice = WearableDeviceType.unknown,
    this.isRealTimeStreaming = false,
  });

  final double avgHeartRateVariability;
  final double restingHeartRate;
  final double maxHeartRate;
  final double? stressBaseline;
  final double? arousalThreshold;
  final double? electrodermalActivity;
  final double? avgBodyTemperature;
  final double? temperatureDelta;
  final CircadianProfile? circadianRhythm;
  final double? sleepQualityIndex;
  final Duration? avgSleepDuration;
  final double? recoveryIndex;
  final double? activityLevel;
  final double? vo2Max;
  final Map<String, double> fitnessMetrics;
  final DateTime lastSync;
  final WearableDeviceType sourceDevice;
  final bool isRealTimeStreaming;

  double get baselineHRV => avgHeartRateVariability;
}

/// Simplified preference vector surfaced to the privacy service.
class QuantumPreferenceProfile {
  const QuantumPreferenceProfile({
    this.socialEnergyLevel,
    this.activityLevel,
    this.intimacyPreference,
    this.communicationStyle,
  });

  final double? socialEnergyLevel;
  final double? activityLevel;
  final double? intimacyPreference;
  final double? communicationStyle;
}
