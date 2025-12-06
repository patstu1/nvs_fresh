import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VaultSection extends ConsumerWidget {
  const VaultSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == 0) {
              // The special "Mask" Album
              return const MaskAlbumTile();
            }
            // Regular album tiles
            return AlbumTile(
              title: _getAlbumTitle(index),
              photoCount: _getPhotoCount(index),
              isLocked: _isAlbumLocked(index),
            );
          },
          childCount: 7, // 1 Mask Album + 6 regular albums
        ),
      ),
    );
  }

  String _getAlbumTitle(int index) {
    const List<String> titles = <String>[
      'MASK', // index 0 - special case
      'PUBLIC GALLERY',
      'PRIVATE COLLECTION',
      'NEXUS MOMENTS',
      'VERIFIED SHOTS',
      'UNDERGROUND',
      'ARCHIVE',
    ];
    return titles[index % titles.length];
  }

  int _getPhotoCount(int index) {
    // Simulated photo counts
    const List<int> counts = <int>[0, 12, 8, 24, 6, 15, 31];
    return counts[index % counts.length];
  }

  bool _isAlbumLocked(int index) {
    // Some albums are locked/premium
    return index == 2 || index == 5; // Private Collection and Underground
  }
}

class MaskAlbumTile extends StatefulWidget {
  const MaskAlbumTile({super.key});

  @override
  State<MaskAlbumTile> createState() => _MaskAlbumTileState();
}

class _MaskAlbumTileState extends State<MaskAlbumTile> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _maskController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _maskController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMaskAlbum,
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable?>[_glowController, _maskController]),
        builder: (BuildContext context, Widget? child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.purple.withOpacity(0.1 + _glowController.value * 0.1),
                  Colors.cyan.withOpacity(0.1 + _glowController.value * 0.1),
                  Colors.black.withOpacity(0.8),
                ],
              ),
              border: Border.all(
                color: Colors.purple.withOpacity(0.5 + _glowController.value * 0.3),
                width: 2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3 + _glowController.value * 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                // Background pattern
                _buildMaskPattern(),

                // Main content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Animated mask icon
                      Transform.rotate(
                        angle: _maskController.value * 0.1,
                        child: Icon(
                          Icons.theater_comedy,
                          size: 48,
                          color: Colors.purple.withOpacity(0.8 + _glowController.value * 0.2),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title
                      const Text(
                        'THE MASK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Description
                      Text(
                        'Anonymous Profile\nPhotos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Photo count
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '3 photos',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantum lock indicator
                Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(
                    Icons.security,
                    color: Colors.purple.withOpacity(0.7),
                    size: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMaskPattern() {
    return CustomPaint(
      painter: MaskPatternPainter(animationValue: _maskController.value),
      size: Size.infinite,
    );
  }

  void _openMaskAlbum() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const MaskAlbumDetailView(),
      ),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _maskController.dispose();
    super.dispose();
  }
}

class AlbumTile extends StatelessWidget {
  const AlbumTile({
    required this.title, required this.photoCount, super.key,
    this.isLocked = false,
  });
  final String title;
  final int photoCount;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openAlbum(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[900]?.withOpacity(0.5),
          border: Border.all(
            color: isLocked ? Colors.yellow.withOpacity(0.3) : Colors.cyan.withOpacity(0.3),
          ),
        ),
        child: Stack(
          children: <Widget>[
            // Background photo grid simulation
            _buildPhotoGrid(),

            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isLocked)
                        const Icon(
                          Icons.lock,
                          color: Colors.yellow,
                          size: 16,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$photoCount photos',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[800],
        child: const Icon(
          Icons.photo_library,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }

  void _openAlbum(BuildContext context) {
    if (isLocked) {
      _showUpgradeDialog(context);
    } else {
      // Navigate to album detail view
      print('Opening album: $title');
    }
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'NVS+ Required',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This album requires NVS+ membership to access.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to upgrade flow
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
            child: const Text('Upgrade', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class MaskPatternPainter extends CustomPainter {
  MaskPatternPainter({required this.animationValue});
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.purple.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw flowing lines that represent the "mask" concept
    final Path path = Path();
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    for (int i = 0; i < 3; i++) {
      final double offset = animationValue * 20 + i * 10;
      path.moveTo(0, centerY + offset);
      path.quadraticBezierTo(
        centerX,
        centerY - offset,
        size.width,
        centerY + offset,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MaskAlbumDetailView extends StatelessWidget {
  const MaskAlbumDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('THE MASK'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () {
              // Add photo to mask album
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.theater_comedy,
              size: 64,
              color: Colors.purple,
            ),
            SizedBox(height: 16),
            Text(
              'Anonymous Profile Photos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Photos for consent-driven reveals',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
