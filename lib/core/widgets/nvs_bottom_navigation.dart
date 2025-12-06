import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:nvs/meatup_core.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class NvsBottomNavigation extends StatelessWidget {
  const NvsBottomNavigation({super.key});

  static const String _iconGrid = 'assets/icons/yo.jpg';
  static const String _iconNow = 'assets/icons/now.jpeg';
  static const String _iconConnect = 'assets/icons/connect.jpeg';
  static const String _iconLive = 'assets/icons/hqdefault.jpg';
  static const String _iconMessages = 'assets/icons/messages.jpeg';
  static const String _iconSearch = 'assets/icons/searchbar.jpeg';
  static const String _iconProfile = 'assets/icons/yo.jpg';

  int _routeToIndex(String location) {
    if (location.startsWith('/grid')) return 0;
    if (location.startsWith('/now') || location == '/') return 1;
    if (location.startsWith('/connect')) return 2;
    if (location.startsWith('/live')) return 3;
    if (location.startsWith('/messages')) return 4;
    if (location.startsWith('/search')) return 5;
    if (location.startsWith('/profile')) return 6;
    return 1;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/grid');
        break;
      case 1:
        context.go('/now');
        break;
      case 2:
        context.go('/connect/dashboard');
        break;
      case 3:
        context.go('/live');
        break;
      case 4:
        context.go('/messages');
        break;
      case 5:
        context.go('/search');
        break;
      case 6:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouter.of(context).routeInformationProvider.value.location;
    final int currentIndex = _routeToIndex(location);

    return DecoratedBox(
      decoration: const BoxDecoration(color: NVSColors.pureBlack, boxShadow: NVSColors.mintGlow),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: NVSColors.ultraLightMint,
          unselectedItemColor: Colors.white24,
          currentIndex: currentIndex,
          onTap: (int i) => _onTap(context, i),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _AssetIcon(path: _iconGrid, isActive: currentIndex == 0),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _AssetIcon(path: _iconNow, isActive: currentIndex == 1),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _AssetIcon(path: _iconConnect, isActive: currentIndex == 2),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _AssetIcon(path: _iconLive, isActive: currentIndex == 3),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _AssetIcon(path: _iconMessages, isActive: currentIndex == 4),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _AssetIcon(path: _iconSearch, isActive: currentIndex == 5),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _AssetIcon(path: _iconProfile, isActive: currentIndex == 6),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetIcon extends StatelessWidget {
  const _AssetIcon({required this.path, required this.isActive});
  final String path;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 28;
    return FutureBuilder<Uint8List?>(
      future: _loadAsPngBytes(path),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snap) {
        final Widget imageWidget = snap.hasData
            ? Image.memory(
                snap.data!,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              )
            : Image.asset(
                path,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              );

        return DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: isActive
                ? <BoxShadow>[
                    BoxShadow(
                      color: NVSColors.ultraLightMint.withValues(alpha: 0.45),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: imageWidget,
        );
      },
    );
  }

  Future<Uint8List?> _loadAsPngBytes(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) return bytes; // best effort
      final Uint8List png = Uint8List.fromList(img.encodePng(decoded));
      return png;
    } catch (_) {
      return null;
    }
  }
}
