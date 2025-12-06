// Meat Market TradeBlock - Industrial hookup aesthetic
// Dark, brutal, cold warehouse vibe with chrome accents

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/providers/tradeblock_provider.dart';
import '../../data/models/vibe_lens_types.dart';
import 'package:nvs/theme/nvs_palette.dart';
import 'dart:ui';

/// MEAT MARKET - Industrial TradeBlock with warehouse aesthetic
class TradeblockViewMeatMarket extends ConsumerStatefulWidget {
  const TradeblockViewMeatMarket({super.key});

  @override
  ConsumerState<TradeblockViewMeatMarket> createState() => _TradeblockViewMeatMarketState();
}

class _TradeblockViewMeatMarketState extends ConsumerState<TradeblockViewMeatMarket> 
    with SingleTickerProviderStateMixin {
  VibeLensType _activeLens = VibeLensType.nearby;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(tradeblockProfilesProvider(_activeLens));

    return Scaffold(
      backgroundColor: const Color(0xFF050505), // Matte black
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF050505),
              const Color(0xFF0A0A0A),
              const Color(0xFF050505),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              
              // Chrome gradient header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      NVSPalette.primary,
                      const Color(0xFF808080),
                      Colors.white,
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ).createShader(bounds),
                  child: const Text(
                    'MEAT MARKET',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'BellGothic',
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 8.0,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Text(
                    'FRESH CUTS • COLD STORAGE • GRADE A',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      fontSize: 10,
                      color: NVSPalette.secondary.withOpacity(_glowAnimation.value),
                      letterSpacing: 3.0,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Stats panel - stainless steel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A1A1A),
                        Color(0xFF0D0D0D),
                        Color(0xFF1A1A1A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFF2A2A2A),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                      ),
                      BoxShadow(
                        color: NVSPalette.secondary.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('ONLINE', '247'),
                      _buildDivider(),
                      _buildStat('NEARBY', '89'),
                      _buildDivider(),
                      _buildStat('NEW', '12'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Separator line
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      NVSPalette.secondary.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Grid content
              Expanded(
                child: profilesAsync.when(
                  data: (profiles) => _buildMeatGrid(profiles),
                  loading: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: NVSPalette.secondary,
                          strokeWidth: 2,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'LOADING INVENTORY...',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 10,
                            color: NVSPalette.secondary.withOpacity(0.6),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      'ERROR: ${error.toString().toUpperCase()}',
                      style: TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        fontSize: 12,
                        color: NVSPalette.secondary.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'BellGothic',
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 9,
            color: NVSPalette.secondary.withOpacity(0.6),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF2A2A2A),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildMeatGrid(List<UserProfile> profiles) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return _buildMeatCard(profiles[index]);
      },
    );
  }

  Widget _buildMeatCard(UserProfile profile) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0D0D0D),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder for image
                  Center(
                    child: Icon(
                      Icons.person,
                      size: 64,
                      color: NVSPalette.secondary.withOpacity(0.3),
                    ),
                  ),
                  
                  // Online indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: NVSPalette.secondary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: NVSPalette.secondary.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Info section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'BellGothic',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${profile.age} • ${profile.location ?? 'Unknown'}',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 9,
                          color: NVSPalette.secondary.withOpacity(0.6),
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  
                  // Tags
                  if (profile.tags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: profile.tags.take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0A0A),
                            border: Border.all(
                              color: NVSPalette.secondary.withOpacity(0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            tag.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'MagdaCleanMono',
                              fontSize: 8,
                              color: NVSPalette.secondary.withOpacity(0.7),
                              letterSpacing: 0.5,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _loadMoreProfiles() {
    ref.read(tradeblockProfilesProvider(_activeLens).notifier).loadMore();
  }
}
