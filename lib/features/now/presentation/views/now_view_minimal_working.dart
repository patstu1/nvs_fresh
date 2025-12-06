import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../widgets/neon_globe_intro.dart';

class NowViewMinimalWorking extends StatefulWidget {
  const NowViewMinimalWorking({super.key});

  @override
  State<NowViewMinimalWorking> createState() => _NowViewMinimalWorkingState();
}

class _NowViewMinimalWorkingState extends State<NowViewMinimalWorking> {
  bool _showMap = false;

  @override
  void initState() {
    super.initState();

    // Show globe for 4 seconds, then switch to map
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showMap = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: _showMap ? _buildMapView() : _buildGlobeView(),
    );
  }

  Widget _buildGlobeView() {
    return NeonGlobeIntro(
      onComplete: () {
        if (mounted) {
          setState(() {
            _showMap = true;
          });
        }
      },
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: <Widget>[
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                NVSColors.pureBlack,
                NVSColors.primaryNeonMint.withOpacity(0.1),
                NVSColors.pureBlack,
              ],
            ),
          ),
        ),

        // Center content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // NOW title
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: NVSColors.primaryNeonMint, width: 2),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSColors.primaryNeonMint.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  'NOW',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    color: NVSColors.primaryNeonMint,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Status text
              const Text(
                'MAP VIEW ACTIVE',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  color: NVSColors.ultraLightMint,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 20),

              // Location indicator
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: NVSColors.primaryNeonMint,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Los Angeles, CA',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: NVSColors.primaryNeonMint,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Simulated user markers
              const Text(
                'NEARBY USERS: 23',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  color: NVSColors.turquoiseNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 30),

              // User simulation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildUserButton('USER 1', 0.2),
                  _buildUserButton('USER 2', 1.5),
                  _buildUserButton('USER 3', 3.1),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserButton(String name, double distance) {
    return GestureDetector(
      onTap: () => _showUserProfile(name, distance),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: NVSColors.primaryNeonMint.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(8),
          color: NVSColors.primaryNeonMint.withOpacity(0.1),
        ),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.person,
              color: NVSColors.primaryNeonMint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'BellGothic',
                color: NVSColors.primaryNeonMint,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${distance}km',
              style: const TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.ultraLightMint,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserProfile(String name, double distance) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NVSColors.pureBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            // Profile avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: NVSColors.primaryNeonMint, width: 2),
                color: NVSColors.primaryNeonMint.withOpacity(0.2),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.primaryNeonMint.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: NVSColors.primaryNeonMint,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            // Name
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'BellGothic',
                color: NVSColors.primaryNeonMint,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Distance
            Text(
              '${distance}km away',
              style: const TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.ultraLightMint,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            // Status
            const Text(
              'Online now',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.primaryNeonMint,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NVSColors.primaryNeonMint,
                    foregroundColor: NVSColors.pureBlack,
                  ),
                  child: const Text(
                    'MESSAGE',
                    style: TextStyle(
                      fontFamily: 'BellGothic',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: NVSColors.primaryNeonMint),
                  ),
                  child: const Text(
                    'PROFILE',
                    style: TextStyle(
                      fontFamily: 'BellGothic',
                      color: NVSColors.primaryNeonMint,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Close
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'CLOSE',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  color: NVSColors.ultraLightMint,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
