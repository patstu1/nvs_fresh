// NVS Profile Setup Flow - 7 Screen Wizard
// Colors: #000000 background, #E4FFF0 accent only

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupFlow extends StatefulWidget {
  const ProfileSetupFlow({super.key});

  @override
  State<ProfileSetupFlow> createState() => _ProfileSetupFlowState();
}

class _ProfileSetupFlowState extends State<ProfileSetupFlow>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 7;

  // Screen 1: Photos
  final List<File?> _publicPhotos = List.filled(6, null);
  final List<File?> _privatePhotos = List.filled(10, null);

  // Screen 2: Basics
  final TextEditingController _nameController = TextEditingController();
  int _age = 25;
  int _heightFeet = 5;
  int _heightInches = 10;
  String _bodyType = 'Average';
  String _location = 'Detecting...';

  // Screen 3: Identity
  String _gender = 'Man';
  String _pronouns = 'He/Him';
  List<String> _lookingFor = ['Men'];

  // Screen 4: Position
  String _position = 'Verse';
  double _roleSlider = 0.5; // 0 = Dom, 1 = Sub
  String _status = 'Single';
  List<String> _seekingTypes = ['Chat'];

  // Screen 5: Bio
  final TextEditingController _bioController = TextEditingController();

  // Screen 6: TradeBlock Settings
  bool _anonymousMode = false;
  bool _usePrivatePic = false;
  int _selectedPrivatePicIndex = 0;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _detectLocation();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pageController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _detectLocation() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _location = 'San Francisco, CA');
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _pickImage(bool isPublic, int index) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isPublic) {
          _publicPhotos[index] = File(picked.path);
        } else {
          _privatePhotos[index] = File(picked.path);
        }
      });
      HapticFeedback.mediumImpact();
    }
  }

  // Called when profile setup is complete
  // ignore: unused_element
  void _completeSetup() {
    HapticFeedback.heavyImpact();
    // Save profile data and navigate to main app
    Navigator.of(context).pushReplacementNamed('/main');
  }

  void _skipDeepProfile() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pushReplacementNamed('/main');
  }

  void _startDeepProfile() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushNamed('/deep-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildPhotosScreen(),
                  _buildBasicsScreen(),
                  _buildIdentityScreen(),
                  _buildPositionScreen(),
                  _buildBioScreen(),
                  _buildTradeBlockScreen(),
                  _buildDeepProfileScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                GestureDetector(
                  onTap: _previousPage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: _mint.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.arrow_back, color: _mint, size: 20),
                  ),
                )
              else
                const SizedBox(width: 36),
              Text(
                'STEP ${_currentPage + 1} OF $_totalPages',
                style: TextStyle(
                  color: _mint.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(_totalPages, (index) {
              final isActive = index <= _currentPage;
              return Expanded(
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      height: 3,
                      margin: EdgeInsets.only(right: index < _totalPages - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: isActive ? _mint : _mint.withOpacity(0.15),
                        boxShadow: isActive && index == _currentPage
                            ? [
                                BoxShadow(
                                  color: _mint.withOpacity(0.5 * _glowAnimation.value),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ============ SCREEN 1: PHOTOS ============
  Widget _buildPhotosScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('PUBLIC ALBUM', 'Visible to all users'),
          const SizedBox(height: 12),
          _buildPhotoGrid(true, 6, 3),
          const SizedBox(height: 8),
          Text(
            'First photo = main profile pic • Face required for verification',
            style: TextStyle(
              color: _mint.withOpacity(0.4),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('PRIVATE ALBUM', 'Locked • Grant access per conversation'),
          const SizedBox(height: 12),
          _buildPhotoGrid(false, 10, 5),
          const SizedBox(height: 8),
          Text(
            'Can also be used as TradeBlock profile pic',
            style: TextStyle(
              color: _mint.withOpacity(0.4),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 40),
          _buildContinueButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(bool isPublic, int count, int crossAxisCount) {
    final photos = isPublic ? _publicPhotos : _privatePhotos;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        final hasPhoto = index < photos.length && photos[index] != null;
        final isMain = isPublic && index == 0;

        return GestureDetector(
          onTap: () => _pickImage(isPublic, index),
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isMain
                        ? _mint.withOpacity(0.8)
                        : _mint.withOpacity(hasPhoto ? 0.4 : 0.15),
                    width: isMain ? 2 : 1,
                  ),
                  boxShadow: isMain
                      ? [
                          BoxShadow(
                            color: _mint.withOpacity(0.3 * _glowAnimation.value),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: hasPhoto
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(photos[index]!, fit: BoxFit.cover),
                            if (isMain)
                              Positioned(
                                top: 4,
                                left: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _mint,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'MAIN',
                                    style: TextStyle(
                                      color: _black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            if (!isPublic)
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Icon(
                                  Icons.lock,
                                  color: _mint.withOpacity(0.8),
                                  size: 14,
                                ),
                              ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: _mint.withOpacity(0.3),
                              size: isPublic ? 28 : 20,
                            ),
                            if (isMain) ...[
                              const SizedBox(height: 4),
                              Text(
                                'MAIN',
                                style: TextStyle(
                                  color: _mint.withOpacity(0.5),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ============ SCREEN 2: BASICS ============
  Widget _buildBasicsScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('BASICS', 'Tell us about yourself'),
          const SizedBox(height: 24),
          _buildTextField('DISPLAY NAME', _nameController, 'Enter your name'),
          const SizedBox(height: 24),
          _buildAgeSelector(),
          const SizedBox(height: 24),
          _buildHeightSelector(),
          const SizedBox(height: 24),
          _buildBodyTypeSelector(),
          const SizedBox(height: 24),
          _buildLocationDisplay(),
          const SizedBox(height: 40),
          _buildContinueButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _mint.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: _mint.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: _mint, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: _mint.withOpacity(0.3)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AGE',
          style: TextStyle(
            color: _mint.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildNumberButton(
              Icons.remove,
              () => setState(() => _age = (_age - 1).clamp(18, 99)),
            ),
            const SizedBox(width: 20),
            Text(
              '$_age',
              style: const TextStyle(
                color: _mint,
                fontSize: 32,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 20),
            _buildNumberButton(
              Icons.add,
              () => setState(() => _age = (_age + 1).clamp(18, 99)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: _mint.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, color: _mint, size: 20),
      ),
    );
  }

  Widget _buildHeightSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HEIGHT',
          style: TextStyle(
            color: _mint.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildHeightDropdown(_heightFeet, 4, 7, (v) => setState(() => _heightFeet = v)),
            const SizedBox(width: 8),
            Text('ft', style: TextStyle(color: _mint.withOpacity(0.5), fontSize: 14)),
            const SizedBox(width: 20),
            _buildHeightDropdown(_heightInches, 0, 11, (v) => setState(() => _heightInches = v)),
            const SizedBox(width: 8),
            Text('in', style: TextStyle(color: _mint.withOpacity(0.5), fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildHeightDropdown(int value, int min, int max, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: _mint.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<int>(
        value: value,
        dropdownColor: _black,
        underline: const SizedBox(),
        iconEnabledColor: _mint,
        style: const TextStyle(color: _mint, fontSize: 18),
        items: List.generate(
          max - min + 1,
          (i) => DropdownMenuItem(value: min + i, child: Text('${min + i}')),
        ),
        onChanged: (v) {
          HapticFeedback.selectionClick();
          if (v != null) onChanged(v);
        },
      ),
    );
  }

  Widget _buildBodyTypeSelector() {
    final types = ['Slim', 'Fit', 'Average', 'Muscular', 'Stocky', 'Large'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BODY TYPE',
          style: TextStyle(
            color: _mint.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: types.map((type) => _buildChip(type, _bodyType == type, () {
            HapticFeedback.selectionClick();
            setState(() => _bodyType = type);
          })).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _mint.withOpacity(0.15) : Colors.transparent,
          border: Border.all(
            color: selected ? _mint : _mint.withOpacity(0.25),
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [BoxShadow(color: _mint.withOpacity(0.2), blurRadius: 8)]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _mint : _mint.withOpacity(0.6),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LOCATION',
          style: TextStyle(
            color: _mint.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: _mint.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: _mint.withOpacity(0.6),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _location,
                  style: TextStyle(
                    color: _mint.withOpacity(0.8),
                    fontSize: 15,
                  ),
                ),
              ),
              Icon(
                Icons.gps_fixed,
                color: _mint.withOpacity(0.4),
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============ SCREEN 3: IDENTITY ============
  Widget _buildIdentityScreen() {
    final genders = ['Man', 'Trans Man', 'Non-binary', 'Other'];
    final pronounsList = ['He/Him', 'They/Them', 'She/Her', 'He/They', 'Any'];
    final lookingForOptions = ['Men', 'Trans Men', 'Non-binary', 'Everyone'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('IDENTITY', 'How do you identify?'),
          const SizedBox(height: 24),
          Text(
            'GENDER',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: genders.map((g) => _buildChip(g, _gender == g, () {
              setState(() => _gender = g);
            })).toList(),
          ),
          const SizedBox(height: 28),
          Text(
            'PRONOUNS',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pronounsList.map((p) => _buildChip(p, _pronouns == p, () {
              setState(() => _pronouns = p);
            })).toList(),
          ),
          const SizedBox(height: 28),
          Text(
            'LOOKING FOR',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: lookingForOptions.map((l) {
              final selected = _lookingFor.contains(l);
              return _buildChip(l, selected, () {
                setState(() {
                  if (l == 'Everyone') {
                    _lookingFor = ['Everyone'];
                  } else {
                    _lookingFor.remove('Everyone');
                    if (selected) {
                      _lookingFor.remove(l);
                    } else {
                      _lookingFor.add(l);
                    }
                  }
                });
              });
            }).toList(),
          ),
          const SizedBox(height: 40),
          _buildContinueButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============ SCREEN 4: POSITION ============
  Widget _buildPositionScreen() {
    final positions = ['Top', 'Bottom', 'Verse', 'Verse Top', 'Verse Bottom', 'Side'];
    final statuses = ['Single', 'Open', 'Partnered'];
    final seekingOptions = ['Chat', 'Friends', 'Dates', 'Hookups', 'Relationship'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('POSITION', 'Your preferences'),
          const SizedBox(height: 24),
          Text(
            'POSITION',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: positions.map((p) => _buildChip(p, _position == p, () {
              setState(() => _position = p);
            })).toList(),
          ),
          const SizedBox(height: 28),
          Text(
            'ROLE',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildRoleSlider(),
          const SizedBox(height: 28),
          Text(
            'STATUS',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: statuses.map((s) => _buildChip(s, _status == s, () {
              setState(() => _status = s);
            })).toList(),
          ),
          const SizedBox(height: 28),
          Text(
            'LOOKING FOR',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: seekingOptions.map((s) {
              final selected = _seekingTypes.contains(s);
              return _buildChip(s, selected, () {
                setState(() {
                  if (selected) {
                    _seekingTypes.remove(s);
                  } else {
                    _seekingTypes.add(s);
                  }
                });
              });
            }).toList(),
          ),
          const SizedBox(height: 40),
          _buildContinueButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRoleSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DOMINANT',
              style: TextStyle(
                color: _mint.withOpacity(_roleSlider < 0.5 ? 0.9 : 0.4),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'SUBMISSIVE',
              style: TextStyle(
                color: _mint.withOpacity(_roleSlider > 0.5 ? 0.9 : 0.4),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _mint,
            inactiveTrackColor: _mint.withOpacity(0.2),
            thumbColor: _mint,
            overlayColor: _mint.withOpacity(0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: _roleSlider,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              setState(() => _roleSlider = v);
            },
          ),
        ),
        Text(
          _roleSlider < 0.3
              ? 'Dominant'
              : _roleSlider > 0.7
                  ? 'Submissive'
                  : 'Versatile',
          style: TextStyle(
            color: _mint.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ============ SCREEN 5: BIO ============
  Widget _buildBioScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('BIO', 'Tell people about yourself'),
          const SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                TextField(
                  controller: _bioController,
                  maxLength: 500,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(color: _mint, fontSize: 15, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'Write something about yourself...',
                    hintStyle: TextStyle(color: _mint.withOpacity(0.3)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    counterText: '',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Text(
                    '${_bioController.text.length}/500',
                    style: TextStyle(
                      color: _mint.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildContinueButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============ SCREEN 6: TRADEBLOCK SETTINGS ============
  Widget _buildTradeBlockScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('TRADEBLOCK', 'Your anonymous trading identity'),
          const SizedBox(height: 24),
          _buildToggleRow(
            'ANONYMOUS MODE',
            'Hide your name, use anonymous avatar',
            _anonymousMode,
            (v) => setState(() => _anonymousMode = v),
          ),
          const SizedBox(height: 20),
          _buildToggleRow(
            'USE PRIVATE PIC',
            'Select a private photo for TradeBlock',
            _usePrivatePic,
            (v) => setState(() => _usePrivatePic = v),
          ),
          if (_usePrivatePic) ...[
            const SizedBox(height: 20),
            _buildPrivatePicSelector(),
          ],
          const SizedBox(height: 32),
          _buildTradeBlockPreview(),
          const SizedBox(height: 40),
          _buildContinueButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: _mint.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
            activeColor: _mint,
            activeTrackColor: _mint.withOpacity(0.3),
            inactiveThumbColor: _mint.withOpacity(0.4),
            inactiveTrackColor: _mint.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivatePicSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT PRIVATE PHOTO',
          style: TextStyle(
            color: _mint.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _privatePhotos.where((p) => p != null).length,
            itemBuilder: (context, index) {
              final selected = _selectedPrivatePicIndex == index;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedPrivatePicIndex = index);
                },
                child: Container(
                  width: 60,
                  height: 80,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected ? _mint : _mint.withOpacity(0.2),
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: _privatePhotos[index] != null
                        ? Image.file(_privatePhotos[index]!, fit: BoxFit.cover)
                        : Container(color: _mint.withOpacity(0.1)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTradeBlockPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PREVIEW ON MAP',
          style: TextStyle(
            color: _mint.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(color: _mint.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Map preview placeholder
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  gradient: RadialGradient(
                    colors: [
                      _mint.withOpacity(0.08),
                      _black,
                    ],
                    radius: 1.5,
                  ),
                ),
              ),
              // Grid lines
              Positioned.fill(
                child: CustomPaint(
                  painter: _GridPainter(_mint.withOpacity(0.1)),
                ),
              ),
              // User marker
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _mint, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _mint.withOpacity(0.4),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _anonymousMode
                            ? Container(
                                color: _mint.withOpacity(0.1),
                                child: Icon(
                                  Icons.person_outline,
                                  color: _mint.withOpacity(0.5),
                                  size: 28,
                                ),
                              )
                            : _usePrivatePic && _privatePhotos.isNotEmpty
                                ? (_privatePhotos[_selectedPrivatePicIndex] != null
                                    ? Image.file(
                                        _privatePhotos[_selectedPrivatePicIndex]!,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(color: _mint.withOpacity(0.1)))
                                : Container(
                                    color: _mint.withOpacity(0.1),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: _mint.withOpacity(0.5),
                                      size: 28,
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _anonymousMode ? 'Anonymous' : _nameController.text.isEmpty ? 'You' : _nameController.text,
                      style: TextStyle(
                        color: _mint.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============ SCREEN 7: DEEP PROFILE ============
  Widget _buildDeepProfileScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _mint.withOpacity(0.6), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: _mint.withOpacity(0.3 * _glowAnimation.value),
                      blurRadius: 24,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  color: _mint,
                  size: 56,
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'DEEP PROFILE',
            style: TextStyle(
              color: _mint,
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Complete the Deep Profile to unlock\nConnect AI compatibility matching',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
          _buildGlowButton('START DEEP PROFILE', _startDeepProfile),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _skipDeepProfile,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'SKIP FOR NOW',
                style: TextStyle(
                  color: _mint.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ COMMON WIDGETS ============
  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _mint,
            fontSize: 28,
            fontWeight: FontWeight.w300,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: _mint.withOpacity(0.5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return _buildGlowButton('CONTINUE', _nextPage);
  }

  Widget _buildGlowButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: _mint, width: 1.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _mint.withOpacity(0.3 * _glowAnimation.value),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _mint,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    const spacing = 30.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  // ignore: unused_element
  Size get preferredSize => const Size(double.infinity, double.infinity);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

