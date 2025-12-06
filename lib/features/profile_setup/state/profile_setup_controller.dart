// lib/features/profile_setup/state/profile_setup_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/user_profile.dart';

final StateNotifierProvider<ProfileSetupController, UserProfile> profileSetupProvider =
    StateNotifierProvider<ProfileSetupController, UserProfile>(
        (StateNotifierProviderRef<ProfileSetupController, UserProfile> ref) {
  return ProfileSetupController();
});

class ProfileSetupController extends StateNotifier<UserProfile> {
  ProfileSetupController()
      : super(
          const UserProfile(
            userId: '',
            displayName: '',
          ),
        );

  void updateField<T>(T value, void Function(UserProfile, T) updateFn) {
    updateFn(state, value);
  }

  void update({
    String? displayName,
    int? age,
    String? pronouns,
    String? gender,
    String? position,
    String? aboutMe,
    String? bodyType,
    double? heightCm,
    double? weightKg,
    List<String>? roleTags,
    List<String>? moodTags,
    List<String>? traits,
    String? profilePhotoUrl,
    List<String>? privateAlbumUrls,
    bool? showAge,
    bool? isIncognito,
    bool? showDistance,
    bool? hasVerifiedStatus,
    String? instagram,
    String? twitter,
    String? spotify,
    bool? enableNSFW,
    bool? offerSessions,
    bool? allowTripPlanner,
  }) {
    state = state.copyWith(
      displayName: displayName,
      age: age,
      pronouns: pronouns,
      gender: gender,
      position: position,
      aboutMe: aboutMe,
      bodyType: bodyType,
      heightCm: heightCm,
      weightKg: weightKg,
      roleTags: roleTags,
      moodTags: moodTags,
      traits: traits,
      profilePhotoUrl: profilePhotoUrl,
      privateAlbumUrls: privateAlbumUrls,
      showAge: showAge,
      isIncognito: isIncognito,
      showDistance: showDistance,
      hasVerifiedStatus: hasVerifiedStatus,
      instagram: instagram,
      twitter: twitter,
      spotify: spotify,
      enableNSFW: enableNSFW,
      offerSessions: offerSessions,
      allowTripPlanner: allowTripPlanner,
    );
  }

  void reset() {
    state = const UserProfile(
      userId: '',
      displayName: '',
    );
  }
}
