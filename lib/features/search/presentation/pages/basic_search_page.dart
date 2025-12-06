// lib/features/search/presentation/pages/basic_search_page.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';

/// SEARCH - Advanced search with filters
/// Enterprise-grade search functionality with AI-driven filters
class BasicSearchPage extends StatefulWidget {
  const BasicSearchPage({super.key});

  @override
  State<BasicSearchPage> createState() => _BasicSearchPageState();
}

class _BasicSearchPageState extends State<BasicSearchPage> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final TextEditingController _searchController = TextEditingController();
  final List<SearchResult> _results = <SearchResult>[];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _results.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _results.clear();

          // Mock search results
          if (query.toLowerCase().contains('alex')) {
            _results.add(
              const SearchResult(
                id: '1',
                name: 'ALEX',
                location: 'Los Angeles, CA',
                age: 28,
                isOnline: true,
                compatibility: 85,
              ),
            );
          }

          if (query.toLowerCase().contains('jordan')) {
            _results.add(
              const SearchResult(
                id: '2',
                name: 'JORDAN',
                location: 'San Francisco, CA',
                age: 30,
                isOnline: false,
                compatibility: 92,
              ),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildSearchInput(),
            _buildFilterChips(),
            Expanded(
              child: _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (BuildContext context, Widget? child) {
          return Row(
            children: <Widget>[
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: QuantumDesignTokens.neonMint,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: QuantumDesignTokens.neonMint.withValues(
                        alpha: _glowAnimation.value * 0.6,
                      ),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'SEARCH',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: NVSColors.ultraLightMint,
                    letterSpacing: 2.0,
                    shadows: <Shadow>[
                      Shadow(
                        color: QuantumDesignTokens.neonMint.withValues(
                          alpha: _glowAnimation.value * 0.8,
                        ),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: NVSColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _performSearch,
        style: const TextStyle(
          fontFamily: 'MagdaCleanMono',
          fontSize: 16,
          color: NVSColors.ultraLightMint,
        ),
        decoration: const InputDecoration(
          hintText: 'Search users, locations, interests...',
          hintStyle: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 14,
            color: QuantumDesignTokens.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: QuantumDesignTokens.neonMint,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<String> filters = <String>[
      'ONLINE NOW',
      'NEARBY',
      'VERIFIED',
      'PREMIUM',
      'COMPATIBLE',
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(
                filters[index],
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: QuantumDesignTokens.neonMint,
                  letterSpacing: 0.5,
                ),
              ),
              onSelected: (bool selected) {
                // Handle filter selection
              },
              backgroundColor: Colors.transparent,
              selectedColor: QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: QuantumDesignTokens.neonMint,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsList() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              color: QuantumDesignTokens.neonMint,
            ),
            SizedBox(height: 16),
            Text(
              'SCANNING NEURAL NETWORK...',
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 14,
                color: QuantumDesignTokens.textSecondary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty && _searchController.text.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search,
              size: 80,
              color: QuantumDesignTokens.textSecondary,
            ),
            SizedBox(height: 20),
            Text(
              'DISCOVER CONNECTIONS',
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: QuantumDesignTokens.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Search for users, locations, or interests',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 12,
                color: QuantumDesignTokens.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty && _searchController.text.isNotEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search_off,
              size: 80,
              color: QuantumDesignTokens.textSecondary,
            ),
            SizedBox(height: 20),
            Text(
              'NO MATCHES FOUND',
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: QuantumDesignTokens.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try different search terms or filters',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 12,
                color: QuantumDesignTokens.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _results.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildResultTile(_results[index]);
      },
    );
  }

  Widget _buildResultTile(SearchResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSColors.darkBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: result.isOnline ? QuantumDesignTokens.neonMint : QuantumDesignTokens.textSecondary,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                result.name[0],
                style: const TextStyle(
                  fontFamily: 'BellGothic',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.ultraLightMint,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        result.name,
                        style: const TextStyle(
                          fontFamily: 'BellGothic',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: NVSColors.ultraLightMint,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${result.compatibility}%',
                        style: const TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: QuantumDesignTokens.neonMint,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${result.age} • ${result.location}',
                  style: const TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 14,
                    color: QuantumDesignTokens.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            result.isOnline ? QuantumDesignTokens.neonMint : QuantumDesignTokens.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      result.isOnline ? 'ONLINE' : 'OFFLINE',
                      style: TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color:
                            result.isOnline ? QuantumDesignTokens.neonMint : QuantumDesignTokens.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Search result model
class SearchResult {
  const SearchResult({
    required this.id,
    required this.name,
    required this.location,
    required this.age,
    required this.isOnline,
    required this.compatibility,
  });

  final String id;
  final String name;
  final String location;
  final int age;
  final bool isOnline;
  final int compatibility;
}
