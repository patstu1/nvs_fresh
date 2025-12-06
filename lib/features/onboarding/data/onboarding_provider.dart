import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'onboarding_repository.dart';

final Provider<OnboardingRepository> onboardingRepositoryProvider =
    Provider<OnboardingRepository>((ProviderRef<OnboardingRepository> ref) {
  return OnboardingRepository();
});

final FutureProvider<UserProfile?> onboardingProfileProvider =
    FutureProvider<UserProfile?>((FutureProviderRef<UserProfile?> ref) async {
  final OnboardingRepository repo = ref.watch(onboardingRepositoryProvider);
  return repo.getCurrentUserProfile();
});

final FutureProviderFamily<void, UserProfile> onboardingUpdateProfileProvider =
    FutureProvider.family<void, UserProfile>(
        (FutureProviderRef<void> ref, UserProfile profile) async {
  final OnboardingRepository repo = ref.watch(onboardingRepositoryProvider);
  await repo.updateProfile(profile);
});
