import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/onboarding_provider.dart';
import 'dart:ui';
import 'package:nvs/features/onboarding/presentation/pages/onboarding_sequence.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _step = 0;
  late UserProfile _profile;
  final TextEditingController _bioController = TextEditingController();
  VideoPlayerController? _videoController;
  GoogleMapController? _mapController;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _getUserLocation();
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.asset(
      'assets/videos/blurrr_mint.mov',
    );
    await _videoController!.initialize();
    setState(() {});
    _videoController!.play();
    _videoController!.setLooping(true);
  }

  Future<void> _getUserLocation() async {
    try {
      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Use default location (Los Angeles) if permission denied
        setState(() {
          _userLocation = const LatLng(34.0522, -118.2437); // LA coordinates
        });
        return;
      }

      final Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Use default location if any error occurs
      setState(() {
        _userLocation = const LatLng(34.0522, -118.2437); // LA coordinates
      });
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use new onboarding sequence, then continue to rest of onboarding
    if (_step == 0) {
      return OnboardingSequence(onFinished: () => setState(() => _step = 1));
    }

    final AsyncValue<UserProfile?> profileAsync = ref.watch(onboardingProfileProvider);
    final bool isLoading = profileAsync.isLoading;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const NvsLogo(letterSpacing: 10),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileAsync.when(
              error: (Object e, StackTrace st) => Center(child: Text('Error: $e')),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (UserProfile? profile) {
                if (profile == null) {
                  return const Center(child: Text('No profile found.'));
                }
                _profile = profile;
                _bioController.text = profile.bio ?? '';
                return Stepper(
                  currentStep: _step,
                  onStepContinue: () async {
                    if (_step == 0) {
                      setState(() => _step++);
                    } else if (_step == 1) {
                      // Save bio
                      final UserProfile updated = _profile.copyWith(bio: _bioController.text);
                      await ref.read(
                        onboardingUpdateProfileProvider(updated).future,
                      );
                      setState(() => _step++);
                    } else if (_step == 2) {
                      // Complete onboarding
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                  onStepCancel: () {
                    if (_step > 0) setState(() => _step--);
                  },
                  steps: <Step>[
                    Step(
                      title: const Text('Photo'),
                      content: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                _profile.photoURL != null && _profile.photoURL!.isNotEmpty
                                    ? NetworkImage(_profile.photoURL!)
                                    : null,
                            child: _profile.photoURL == null || _profile.photoURL!.isEmpty
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement photo upload
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Photo upload coming soon!'),
                                ),
                              );
                            },
                            child: const Text('Upload Photo'),
                          ),
                        ],
                      ),
                      isActive: _step == 0,
                    ),
                    Step(
                      title: const Text('Bio'),
                      content: _step == 1
                          ? Column(
                              children: <Widget>[
                                if (_videoController != null &&
                                    _videoController!.value.isInitialized)
                                  Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 18,
                                            sigmaY: 18,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: AspectRatio(
                                              aspectRatio: _videoController!.value.aspectRatio,
                                              child: VideoPlayer(
                                                _videoController!,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Mint tint overlay
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xAAE6FFF4),
                                            // light mint with opacity
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                      // Glitch effect overlay (placeholder, replace with actual effect if available)
                                      // Positioned.fill(
                                      //   child: GlitchEffectWidget(),
                                      // ),
                                    ],
                                  )
                                else
                                  const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 200,
                                  child: _userLocation != null
                                      ? GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                            target: _userLocation!,
                                            zoom: 12,
                                          ),
                                          onMapCreated: (GoogleMapController controller) {
                                            _mapController = controller;
                                            _mapController!.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                  target: _userLocation!,
                                                  zoom: 16,
                                                ),
                                              ),
                                            );
                                          },
                                          markers: <Marker>{
                                            Marker(
                                              markerId: const MarkerId('user'),
                                              position: _userLocation!,
                                            ),
                                          },
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      isActive: _step == 1,
                    ),
                    Step(
                      title: const Text('Preferences'),
                      content: const Column(
                        children: <Widget>[
                          // TODO: Add preferences form
                          Text('Preferences form coming soon!'),
                        ],
                      ),
                      isActive: _step == 2,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
