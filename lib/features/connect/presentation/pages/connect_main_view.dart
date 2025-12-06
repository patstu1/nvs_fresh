import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/theme/nvs_colors.dart';

/// Main Connect view with AI-powered matching
class ConnectViewWidget extends ConsumerStatefulWidget {
  const ConnectViewWidget({super.key});

  @override
  ConsumerState<ConnectViewWidget> createState() => _ConnectViewWidgetState();
}

class _ConnectViewWidgetState extends ConsumerState<ConnectViewWidget>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _connectPages = <String>[
    'Discovery',
    'Compatibility',
    'AI Insights',
    'Match Details',
    'Conversation',
    'Profile Sync',
    'Shared Interests',
    'Meeting Setup',
    'Connection Success',
  ];

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _connectPages.length,
                onPageChanged: (int index) => setState(() => _currentPage = index),
                itemBuilder: (BuildContext context, int index) => _buildPage(index),
              ),
            ),
            _buildNavigationControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Connect',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.ultraLightMint,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: NVSColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${_currentPage + 1}/${_connectPages.length}',
                  style: const TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 12,
                    color: NVSColors.ultraLightMint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress indicator
          Row(
            children: List.generate(_connectPages.length, (int index) {
              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.only(
                    right: index < _connectPages.length - 1 ? 4 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index <= _currentPage
                        ? NVSColors.ultraLightMint
                        : NVSColors.ultraLightMint.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _connectPages[index],
            style: const TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: NVSColors.ultraLightMint,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Coming soon...',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 16,
              color: NVSColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (_currentPage > 0)
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _currentPage--);
                _pageController.animateToPage(
                  _currentPage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: NVSColors.cardBackground,
                foregroundColor: NVSColors.ultraLightMint,
              ),
            )
          else
            const SizedBox(width: 100),
          if (_currentPage < _connectPages.length - 1)
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _currentPage++);
                _pageController.animateToPage(
                  _currentPage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: NVSColors.ultraLightMint,
                foregroundColor: NVSColors.pureBlack,
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connect flow completed!'),
                    backgroundColor: NVSColors.cardBackground,
                  ),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('Complete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: NVSColors.avocadoGreen,
                foregroundColor: NVSColors.pureBlack,
              ),
            ),
        ],
      ),
    );
  }
}
