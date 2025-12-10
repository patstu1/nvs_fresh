// NVS Meat Market - Full Profile View (Prompt 27)
// Complete profile with ALL details from spec
// Colors: #000000 background, #E3F2DE mint, #6B7F4A olive, #20B2A6 aqua

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeatMarketProfileView extends StatefulWidget {
  final String? userId;
  
  const MeatMarketProfileView({super.key, this.userId});

  @override
  State<MeatMarketProfileView> createState() => _MeatMarketProfileViewState();
}

class _MeatMarketProfileViewState extends State<MeatMarketProfileView>
    with TickerProviderStateMixin {
  // NVS Color Palette (from spec)
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  late AnimationController _pulseController;
  late AnimationController _glowController;
  final ScrollController _scrollController = ScrollController();
  
  double _headerOpacity = 0.0;
  int _currentPhotoIndex = 0;
  final int _totalPhotos = 4;
  
  // YO states
  bool _yoSent = false;
  bool _yoReceived = false;
  bool _isSaved = false;
  bool _isFavorited = false;
  bool _hasConversation = false;

  // Mock profile data
  final _ProfileData _profile = _ProfileData.mock();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _headerOpacity = (offset / 100).clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Photo section (55% of screen)
              SliverToBoxAdapter(child: _buildPhotoSection()),
              // Profile content
              SliverToBoxAdapter(child: _buildBasicInfo()),
              SliverToBoxAdapter(child: _buildAboutMeSection()),
              SliverToBoxAdapter(child: _buildStatsSection()),
              SliverToBoxAdapter(child: _buildLookingForSection()),
              SliverToBoxAdapter(child: _buildExpectationsSection()),
              SliverToBoxAdapter(child: _buildSafetySection()),
              SliverToBoxAdapter(child: _buildInterestsSection()),
              SliverToBoxAdapter(child: _buildTribesSection()),
              SliverToBoxAdapter(child: _buildKinksSection()),
              SliverToBoxAdapter(child: _buildCompatibilitySection()),
              SliverToBoxAdapter(child: _buildNVSInsightSection()),
              SliverToBoxAdapter(child: _buildLocationSection()),
              SliverToBoxAdapter(child: _buildSocialLinksSection()),
              SliverToBoxAdapter(child: _buildProfileMetadata()),
              // Bottom padding for action bar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          // Fixed header
          _buildHeader(),
          // Fixed bottom action bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  // ============ HEADER (Prompt 27 spec) ============
  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _black.withOpacity(_headerOpacity),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // X close button with drop shadow
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _black.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.close, color: _mint, size: 24),
                  ),
                ),
                const Spacer(),
                // Right side icons (8px gap as per spec)
                Row(
                  children: [
                    // Save/Bookmark
                    GestureDetector(
                      onTap: () => setState(() => _isSaved = !_isSaved),
                      child: Icon(
                        _isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: _isSaved ? _aqua : _mint,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Block icon
                    GestureDetector(
                      onTap: _showBlockConfirmation,
                      child: const Icon(Icons.block, color: _olive, size: 24),
                    ),
                    const SizedBox(width: 8),
                    // Star/Favorite
                    GestureDetector(
                      onTap: () => setState(() => _isFavorited = !_isFavorited),
                      child: Icon(
                        _isFavorited ? Icons.star : Icons.star_border,
                        color: _isFavorited ? _aqua : _mint,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // More options
                    GestureDetector(
                      onTap: _showMoreOptions,
                      child: const Icon(Icons.more_vert, color: _mint, size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ PHOTO SECTION (55% of screen, Prompt 27 spec) ============
  Widget _buildPhotoSection() {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return SizedBox(
      height: screenHeight * 0.55,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photo carousel
          PageView.builder(
            itemCount: _totalPhotos,
            onPageChanged: (index) => setState(() => _currentPhotoIndex = index),
            itemBuilder: (context, index) {
              return Container(
                color: _mint.withOpacity(0.08),
                child: Icon(
                  Icons.person,
                  color: _mint.withOpacity(0.2),
                  size: 120,
                ),
              );
            },
          ),
          // Photo counter (top right, 12px, mint green)
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentPhotoIndex + 1}/$_totalPhotos',
                style: const TextStyle(
                  color: _mint,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Gradient overlay bottom 40%
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.55 * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, _black.withOpacity(0.9)],
                ),
              ),
            ),
          ),
          // Dot indicators (aqua active, olive inactive)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPhotos, (index) {
                final isActive = index == _currentPhotoIndex;
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? _aqua : _olive,
                  ),
                );
              }),
            ),
          ),
          // Interaction badges (bottom left, stacked vertically)
          Positioned(
            bottom: 40,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_profile.lastChatted != null)
                  _buildInteractionBadge(
                    Icons.chat_bubble,
                    'Chatted ${_profile.lastChatted}',
                    _aqua,
                  ),
                if (_profile.viewedYou != null)
                  _buildInteractionBadge(
                    Icons.visibility,
                    'Viewed you ${_profile.viewedYou}',
                    _mint,
                  ),
                if (_yoReceived)
                  _buildInteractionBadge(
                    Icons.waving_hand,
                    'YO\'d you 2 hours ago',
                    _aqua,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionBadge(IconData icon, String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ============ BASIC INFO SECTION ============
  Widget _buildBasicInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Name + Age + Verification badge
          Row(
            children: [
              Text(
                _profile.name,
                style: const TextStyle(
                  color: _mint,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_profile.age}',
                style: const TextStyle(
                  color: _mint,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (_profile.isVerified) ...[
                const SizedBox(width: 8),
                const Icon(Icons.verified, color: _aqua, size: 20),
              ],
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: Online Status + Distance
          Row(
            children: [
              // Online dot (pulsing if online now)
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _profile.isOnline ? _aqua : _olive,
                      boxShadow: _profile.isOnline
                          ? [
                              BoxShadow(
                                color: _aqua.withOpacity(0.5 * _pulseController.value),
                                blurRadius: 6,
                              ),
                            ]
                          : null,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                _profile.onlineStatus,
                style: TextStyle(
                  color: _profile.isOnline ? _aqua : _olive,
                  fontSize: 14,
                ),
              ),
              Text(' • ', style: TextStyle(color: _olive)),
              Icon(Icons.near_me, color: _olive, size: 14),
              const SizedBox(width: 4),
              Text(
                '${_profile.distance} miles away',
                style: const TextStyle(color: _olive, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 3: Quick Stats
          Row(
            children: [
              Icon(Icons.swap_vert, color: _olive, size: 14),
              const SizedBox(width: 4),
              Text(_profile.position, style: const TextStyle(color: _mint, fontSize: 14)),
              Text(' • ', style: TextStyle(color: _olive)),
              Icon(Icons.straighten, color: _olive, size: 14),
              const SizedBox(width: 4),
              Text(_profile.height, style: const TextStyle(color: _mint, fontSize: 14)),
              Text(' • ', style: TextStyle(color: _olive)),
              Icon(Icons.fitness_center, color: _olive, size: 14),
              const SizedBox(width: 4),
              Text(_profile.weight, style: const TextStyle(color: _mint, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  // ============ ABOUT ME SECTION ============
  Widget _buildAboutMeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('ABOUT ME'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _black,
              border: Border.all(color: _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _profile.bio,
              style: const TextStyle(
                color: _mint,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ STATS SECTION (Two column grid) ============
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('STATS'),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  children: [
                    _buildStatRow(Icons.straighten, 'Height', _profile.height),
                    _buildStatRow(Icons.fitness_center, 'Weight', _profile.weight),
                    _buildStatRow(Icons.accessibility_new, 'Body Type', _profile.bodyType),
                    _buildStatRow(Icons.cake, 'Age', '${_profile.age}'),
                    if (_profile.endowment != null)
                      _buildStatRow(Icons.straighten, 'Endowment', _profile.endowment!),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right column
              Expanded(
                child: Column(
                  children: [
                    _buildStatRow(Icons.swap_vert, 'Position', _profile.position),
                    _buildStatRow(Icons.person, 'Pronouns', _profile.pronouns),
                    _buildStatRow(Icons.favorite, 'Relationship', _profile.relationship),
                    if (_profile.ethnicity != null)
                      _buildStatRow(Icons.public, 'Ethnicity', _profile.ethnicity!),
                    if (_profile.eyeColor != null)
                      _buildStatRow(Icons.visibility, 'Eyes', _profile.eyeColor!),
                    if (_profile.hairColor != null)
                      _buildStatRow(Icons.face, 'Hair', _profile.hairColor!),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _olive.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Icon(icon, color: _olive, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(color: _mint, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ============ LOOKING FOR SECTION ============
  Widget _buildLookingForSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('LOOKING FOR'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _profile.lookingFor.map((tag) => _buildPill(tag)).toList(),
          ),
        ],
      ),
    );
  }

  // ============ EXPECTATIONS SECTION ============
  Widget _buildExpectationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('EXPECTATIONS'),
          const SizedBox(height: 12),
          _buildExpectationRow(Icons.home, 'Meet at:', _profile.meetAt),
          _buildExpectationRow(
            Icons.camera_alt,
            'NSFW pics?',
            _profile.nsfwPics,
            highlightValue: _profile.nsfwPics == 'Yes Please',
          ),
          _buildExpectationRow(
            Icons.visibility,
            'Accepts NSFW:',
            _profile.acceptsNsfw,
            highlightValue: _profile.acceptsNsfw == 'Yes',
          ),
        ],
      ),
    );
  }

  Widget _buildExpectationRow(IconData icon, String label, String value, {bool highlightValue = false}) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _olive, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: _olive, fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: highlightValue ? _aqua : _mint,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ============ SAFETY & HEALTH SECTION ============
  Widget _buildSafetySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('SAFETY'),
          const SizedBox(height: 12),
          _buildSafetyRow(Icons.shield, 'HIV Status:', _profile.hivStatus),
          _buildSafetyRow(Icons.medication, 'On PrEP:', _profile.onPrep),
          _buildSafetyRow(Icons.calendar_today, 'Last Tested:', _profile.lastTested),
          _buildSafetyRow(Icons.vaccines, 'Vaccinated:', _profile.vaccinated),
        ],
      ),
    );
  }

  Widget _buildSafetyRow(IconData icon, String label, String value) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _olive, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: _olive, fontSize: 14)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(color: _mint, fontSize: 14)),
        ],
      ),
    );
  }

  // ============ INTERESTS SECTION ============
  Widget _buildInterestsSection() {
    if (_profile.interests.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('INTERESTS'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _profile.interests.map((tag) => _buildPill(tag)).toList(),
          ),
        ],
      ),
    );
  }

  // ============ TRIBES SECTION ============
  Widget _buildTribesSection() {
    if (_profile.tribes.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('TRIBES'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _profile.tribes.map((tag) => _buildPill(tag)).toList(),
          ),
        ],
      ),
    );
  }

  // ============ KINKS SECTION ============
  Widget _buildKinksSection() {
    if (_profile.kinks.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('INTO'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _profile.kinks.map((tag) => _buildPill(tag)).toList(),
          ),
        ],
      ),
    );
  }

  // ============ COMPATIBILITY SECTION ============
  Widget _buildCompatibilitySection() {
    if (_profile.compatibilityScore == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _black,
              border: Border.all(color: _aqua, width: 2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _aqua.withOpacity(0.2 * _glowController.value),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  '${_profile.compatibilityScore}%',
                  style: const TextStyle(
                    color: _aqua,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Compatible',
                        style: TextStyle(color: _mint, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to see full breakdown',
                        style: TextStyle(color: _olive, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                // Mini chart placeholder
                Row(
                  children: List.generate(5, (i) {
                    final height = 10.0 + Random().nextDouble() * 20;
                    return Container(
                      width: 6,
                      height: height,
                      margin: const EdgeInsets.only(left: 3),
                      decoration: BoxDecoration(
                        color: _aqua.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============ NVS INSIGHT SECTION ============
  Widget _buildNVSInsightSection() {
    if (_profile.nvsInsight == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _black,
          border: Border.all(color: _olive),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: _aqua.withOpacity(0.5), blurRadius: 8),
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: _aqua, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _profile.nvsInsight!,
                style: const TextStyle(
                  color: _mint,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ LOCATION SECTION ============
  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('LOCATION'),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, color: _olive, size: 20),
              const SizedBox(width: 8),
              Text(_profile.location, style: const TextStyle(color: _mint, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  // ============ SOCIAL LINKS SECTION ============
  Widget _buildSocialLinksSection() {
    if (_profile.socialLinks.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('LINKS'),
          const SizedBox(height: 12),
          Row(
            children: _profile.socialLinks.map((link) {
              IconData icon;
              switch (link) {
                case 'instagram':
                  icon = Icons.camera_alt;
                  break;
                case 'twitter':
                  icon = Icons.alternate_email;
                  break;
                case 'spotify':
                  icon = Icons.music_note;
                  break;
                default:
                  icon = Icons.link;
              }
              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Icon(icon, color: _mint, size: 28),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ============ PROFILE METADATA ============
  Widget _buildProfileMetadata() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Member since ${_profile.memberSince}',
            style: const TextStyle(color: _olive, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Profile updated ${_profile.lastUpdated}',
            style: const TextStyle(color: _olive, fontSize: 12),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showReportDialog,
            child: const Text(
              'Report this profile',
              style: TextStyle(
                color: _olive,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ BOTTOM ACTION BAR (90px height, fixed) ============
  Widget _buildBottomActionBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _black,
          border: Border(top: BorderSide(color: _olive.withOpacity(0.2))),
        ),
        child: SafeArea(
          top: false,
          child: _hasConversation
              ? _buildConversationActionBar()
              : _buildDefaultActionBar(),
        ),
      ),
    );
  }

  Widget _buildDefaultActionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Block button (50px circle)
        GestureDetector(
          onTap: _showBlockConfirmation,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _black,
              border: Border.all(color: _olive),
            ),
            child: const Icon(Icons.close, color: _olive, size: 24),
          ),
        ),
        // Message button (140px wide, 50px tall, pill shape)
        GestureDetector(
          onTap: _openChat,
          child: Container(
            width: 140,
            height: 50,
            decoration: BoxDecoration(
              color: _aqua,
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: const Text(
              'MESSAGE',
              style: TextStyle(
                color: _black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // YO button (50px circle)
        _buildYoButton(),
      ],
    );
  }

  Widget _buildYoButton() {
    // State 1: Default (can send)
    // State 2: Sent (already YO'd)
    // State 3: Received (they YO'd you)
    // State 4: Mutual (both YO'd)
    
    final bool isMutual = _yoSent && _yoReceived;
    
    return GestureDetector(
      onTap: _yoSent ? null : _sendYo,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMutual
                  ? _aqua
                  : _yoSent
                      ? _olive
                      : _aqua,
              boxShadow: _yoReceived && !_yoSent
                  ? [
                      BoxShadow(
                        color: _aqua.withOpacity(0.5 * _pulseController.value),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              isMutual
                  ? '👋👋'
                  : _yoSent
                      ? 'SENT'
                      : _yoReceived
                          ? 'YO!'
                          : 'YO',
              style: TextStyle(
                color: _black,
                fontSize: isMutual || _yoSent ? 10 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversationActionBar() {
    return Row(
      children: [
        // Block button
        GestureDetector(
          onTap: _showBlockConfirmation,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _black,
              border: Border.all(color: _olive),
            ),
            child: const Icon(Icons.close, color: _olive, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        // Message input
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _black,
              border: Border.all(color: _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: _mint),
                    decoration: InputDecoration(
                      hintText: 'Say something...',
                      hintStyle: TextStyle(color: _olive),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Icon(Icons.send, color: _aqua, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // YO button
        _buildYoButton(),
      ],
    );
  }

  // ============ HELPER WIDGETS ============
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _olive,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _black,
        border: Border.all(color: _mint.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: _mint, fontSize: 12),
      ),
    );
  }

  // ============ ACTIONS ============
  void _sendYo() {
    HapticFeedback.heavyImpact();
    setState(() => _yoSent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('YO sent to ${_profile.name}!'),
        backgroundColor: _aqua,
      ),
    );
  }

  void _openChat() {
    HapticFeedback.selectionClick();
    // TODO: Navigate to chat
  }

  void _showBlockConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _mint.withOpacity(0.2)),
        ),
        title: const Text('Block this user?', style: TextStyle(color: _mint)),
        content: Text(
          'They won\'t be able to see your profile or message you.',
          style: TextStyle(color: _olive),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: _olive)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Block', style: TextStyle(color: Colors.red.shade300)),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _black,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOptionTile(Icons.share, 'Share Profile'),
            _buildOptionTile(Icons.copy, 'Copy Profile Link'),
            _buildOptionTile(Icons.flag, 'Report'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: _mint),
      title: Text(label, style: const TextStyle(color: _mint)),
      onTap: () => Navigator.pop(context),
    );
  }

  void _showReportDialog() {
    // TODO: Implement report dialog
  }
}

// ============ PROFILE DATA MODEL ============
class _ProfileData {
  final String name;
  final int age;
  final bool isVerified;
  final bool isOnline;
  final String onlineStatus;
  final double distance;
  final String position;
  final String height;
  final String weight;
  final String bodyType;
  final String pronouns;
  final String relationship;
  final String? ethnicity;
  final String? eyeColor;
  final String? hairColor;
  final String? endowment;
  final String bio;
  final List<String> lookingFor;
  final String meetAt;
  final String nsfwPics;
  final String acceptsNsfw;
  final String hivStatus;
  final String onPrep;
  final String lastTested;
  final String vaccinated;
  final List<String> interests;
  final List<String> tribes;
  final List<String> kinks;
  final int? compatibilityScore;
  final String? nvsInsight;
  final String location;
  final List<String> socialLinks;
  final String memberSince;
  final String lastUpdated;
  final String? lastChatted;
  final String? viewedYou;

  _ProfileData({
    required this.name,
    required this.age,
    required this.isVerified,
    required this.isOnline,
    required this.onlineStatus,
    required this.distance,
    required this.position,
    required this.height,
    required this.weight,
    required this.bodyType,
    required this.pronouns,
    required this.relationship,
    this.ethnicity,
    this.eyeColor,
    this.hairColor,
    this.endowment,
    required this.bio,
    required this.lookingFor,
    required this.meetAt,
    required this.nsfwPics,
    required this.acceptsNsfw,
    required this.hivStatus,
    required this.onPrep,
    required this.lastTested,
    required this.vaccinated,
    required this.interests,
    required this.tribes,
    required this.kinks,
    this.compatibilityScore,
    this.nvsInsight,
    required this.location,
    required this.socialLinks,
    required this.memberSince,
    required this.lastUpdated,
    this.lastChatted,
    this.viewedYou,
  });

  factory _ProfileData.mock() {
    return _ProfileData(
      name: 'Alex',
      age: 28,
      isVerified: true,
      isOnline: true,
      onlineStatus: 'Online now',
      distance: 2.3,
      position: 'Versatile',
      height: "5'10\"",
      weight: '175 lb',
      bodyType: 'Toned',
      pronouns: 'He/Him',
      relationship: 'Single',
      ethnicity: 'White',
      eyeColor: 'Brown',
      hairColor: 'Dark Brown',
      endowment: '7 inches',
      bio: 'Lead with face pics. 📍Hollywood. Looking for fun. Can host. Down for whatever, just be real about it.',
      lookingFor: ['Chat', 'Friends', 'Dates', 'Hookups'],
      meetAt: 'My Place, Your Place',
      nsfwPics: 'Yes Please',
      acceptsNsfw: 'Yes',
      hivStatus: 'Negative',
      onPrep: 'Yes',
      lastTested: 'October 2024',
      vaccinated: 'Yes',
      interests: ['Music', 'Travel', 'Gym', 'Gaming', 'Dogs'],
      tribes: ['Jock', 'Clean Cut'],
      kinks: ['Voyeurism', 'Exhibitionism'],
      compatibilityScore: 87,
      nvsInsight: 'Strong chemistry potential. Go for it.',
      location: 'Hollywood, CA',
      socialLinks: ['instagram', 'spotify'],
      memberSince: 'January 2024',
      lastUpdated: '2 days ago',
      lastChatted: '6 hours ago',
      viewedYou: '3 hours ago',
    );
  }
}

