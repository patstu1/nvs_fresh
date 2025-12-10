// NVS ALTER Creation Flow (Prompts 5-8)
// Multi-step ALTER creation: Consent → Style Selection → Customization → Preview
// ALTER = AI-enhanced digital avatar that represents user in Connect AI

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlterCreationFlow extends StatefulWidget {
  const AlterCreationFlow({super.key});

  @override
  State<AlterCreationFlow> createState() => _AlterCreationFlowState();
}

class _AlterCreationFlowState extends State<AlterCreationFlow>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  int _currentStep = 0;
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late PageController _pageController;

  // Step 1: Consent
  bool _understandAlter = false;
  bool _consentToGeneration = false;

  // Step 2: Style Selection
  int _selectedStyleIndex = -1;
  final List<_AlterStyle> _styles = [
    _AlterStyle('MINIMAL', 'Clean, subtle enhancement', Icons.lens_blur),
    _AlterStyle('ETHEREAL', 'Soft glow, dreamlike quality', Icons.auto_awesome),
    _AlterStyle('BOLD', 'High contrast, striking features', Icons.contrast),
    _AlterStyle('CYBER', 'Digital, futuristic aesthetic', Icons.memory),
    _AlterStyle('NATURAL', 'Enhanced but realistic', Icons.nature),
    _AlterStyle('ABSTRACT', 'Artistic, non-literal', Icons.palette),
  ];

  // Step 3: Customization
  double _enhancementLevel = 0.5;
  double _glowIntensity = 0.5;
  double _colorSaturation = 0.5;
  bool _includeBackground = true;
  bool _animateAlter = true;

  // Step 4: Preview
  bool _isGenerating = false;
  bool _generationComplete = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildConsentStep(),
                  _buildStyleSelectionStep(),
                  _buildCustomizationStep(),
                  _buildPreviewStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: _previousStep,
            child: const Icon(Icons.arrow_back, color: _mint),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CREATE YOUR ALTER',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  _getStepTitle(),
                  style: TextStyle(color: _olive, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0: return 'Step 1: Understanding';
      case 1: return 'Step 2: Style';
      case 2: return 'Step 3: Customize';
      case 3: return 'Step 4: Preview';
      default: return '';
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          final isCurrent = index == _currentStep;
          
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive ? _aqua : _olive.withOpacity(0.3),
                boxShadow: isCurrent
                    ? [BoxShadow(color: _aqua.withOpacity(0.5), blurRadius: 8)]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  // ============ STEP 1: CONSENT (Prompt 5) ============
  Widget _buildConsentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildAlterPreviewOrb(),
          const SizedBox(height: 32),
          const Text(
            'WHAT IS AN ALTER?',
            style: TextStyle(
              color: _mint,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your ALTER is an AI-enhanced digital representation of you. It\'s designed to attract compatible matches while staying true to who you are.',
            style: TextStyle(
              color: _mint.withOpacity(0.8),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          _buildFeatureList(),
          const SizedBox(height: 32),
          _buildConsentCheckbox(
            'I understand what an ALTER is',
            _understandAlter,
            (v) => setState(() => _understandAlter = v),
          ),
          const SizedBox(height: 12),
          _buildConsentCheckbox(
            'I consent to AI generation of my ALTER',
            _consentToGeneration,
            (v) => setState(() => _consentToGeneration = v),
          ),
          const SizedBox(height: 32),
          _buildContinueButton(
            enabled: _understandAlter && _consentToGeneration,
          ),
        ],
      ),
    );
  }

  Widget _buildAlterPreviewOrb() {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _aqua.withOpacity(0.4 * _pulseController.value + 0.1),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _aqua.withOpacity(0.5),
                    _aqua.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(color: _aqua, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  color: _aqua,
                  size: 40,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildFeatureItem(Icons.face, 'Enhanced profile appearance'),
        _buildFeatureItem(Icons.auto_awesome, 'AI-optimized for attraction'),
        _buildFeatureItem(Icons.visibility, 'Shows to other ALTER users'),
        _buildFeatureItem(Icons.tune, 'Fully customizable'),
        _buildFeatureItem(Icons.lock, 'You control visibility'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _aqua, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: _mint.withOpacity(0.9), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentCheckbox(String text, bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!value);
      },
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: value ? _aqua : _olive),
              color: value ? _aqua.withOpacity(0.2) : Colors.transparent,
            ),
            child: value
                ? const Icon(Icons.check, color: _aqua, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: _mint.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ STEP 2: STYLE SELECTION (Prompt 6) ============
  Widget _buildStyleSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'CHOOSE YOUR STYLE',
            style: TextStyle(
              color: _mint,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the aesthetic that best represents you',
            style: TextStyle(color: _olive, fontSize: 14),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.2,
            ),
            itemCount: _styles.length,
            itemBuilder: (context, index) => _buildStyleCard(index),
          ),
          const SizedBox(height: 32),
          _buildContinueButton(enabled: _selectedStyleIndex >= 0),
        ],
      ),
    );
  }

  Widget _buildStyleCard(int index) {
    final style = _styles[index];
    final isSelected = _selectedStyleIndex == index;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedStyleIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _aqua : _olive.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? _aqua.withOpacity(0.1) : Colors.transparent,
          boxShadow: isSelected
              ? [BoxShadow(color: _aqua.withOpacity(0.3), blurRadius: 20)]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              style.icon,
              color: isSelected ? _aqua : _mint.withOpacity(0.6),
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              style.name,
              style: TextStyle(
                color: isSelected ? _aqua : _mint,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              style.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _olive,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ STEP 3: CUSTOMIZATION (Prompt 7) ============
  Widget _buildCustomizationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'CUSTOMIZE YOUR ALTER',
            style: TextStyle(
              color: _mint,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fine-tune your ALTER\'s appearance',
            style: TextStyle(color: _olive, fontSize: 14),
          ),
          const SizedBox(height: 32),
          _buildSliderControl(
            'Enhancement Level',
            'How much AI enhancement to apply',
            _enhancementLevel,
            (v) => setState(() => _enhancementLevel = v),
          ),
          const SizedBox(height: 24),
          _buildSliderControl(
            'Glow Intensity',
            'Brightness of the ALTER glow effect',
            _glowIntensity,
            (v) => setState(() => _glowIntensity = v),
          ),
          const SizedBox(height: 24),
          _buildSliderControl(
            'Color Saturation',
            'Vibrancy of colors in your ALTER',
            _colorSaturation,
            (v) => setState(() => _colorSaturation = v),
          ),
          const SizedBox(height: 32),
          _buildToggleOption(
            'Include Background',
            'Generate an atmospheric background',
            _includeBackground,
            (v) => setState(() => _includeBackground = v),
          ),
          const SizedBox(height: 16),
          _buildToggleOption(
            'Animated ALTER',
            'Add subtle motion effects',
            _animateAlter,
            (v) => setState(() => _animateAlter = v),
          ),
          const SizedBox(height: 32),
          _buildContinueButton(enabled: true, label: 'GENERATE ALTER'),
        ],
      ),
    );
  }

  Widget _buildSliderControl(
    String title,
    String description,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: _mint,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(color: _aqua, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(color: _olive, fontSize: 11),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: _aqua,
            inactiveTrackColor: _olive.withOpacity(0.3),
            thumbColor: _aqua,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayColor: _aqua.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption(
    String title,
    String description,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!value);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? _aqua.withOpacity(0.5) : _olive.withOpacity(0.3),
          ),
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(color: _olive, fontSize: 11),
                  ),
                ],
              ),
            ),
            _buildToggle(value),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(bool value) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: value ? _aqua : _olive.withOpacity(0.5)),
        color: value ? _aqua.withOpacity(0.3) : Colors.transparent,
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: value ? 22 : 2,
            top: 2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? _aqua : _olive,
                boxShadow: value
                    ? [BoxShadow(color: _aqua.withOpacity(0.5), blurRadius: 6)]
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ STEP 4: PREVIEW (Prompt 8) ============
  Widget _buildPreviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          if (_isGenerating)
            _buildGeneratingState()
          else if (_generationComplete)
            _buildCompletedState()
          else
            _buildReadyToGenerateState(),
        ],
      ),
    );
  }

  Widget _buildReadyToGenerateState() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _aqua.withOpacity(0.5), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _aqua.withOpacity(0.3 * _pulseController.value),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: _aqua, size: 50),
                    const SizedBox(height: 12),
                    Text(
                      'Ready to generate',
                      style: TextStyle(color: _mint.withOpacity(0.8), fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        Text(
          'Your ALTER will be generated using the ${_selectedStyleIndex >= 0 ? _styles[_selectedStyleIndex].name : "MINIMAL"} style with your custom settings.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _mint.withOpacity(0.8),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: _startGeneration,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: _aqua,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: _aqua.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'CREATE ALTER',
                style: TextStyle(
                  color: _black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratingState() {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated spinning ring
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _glowController.value * 2 * pi,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _aqua.withOpacity(0.5),
                          width: 3,
                        ),
                        gradient: SweepGradient(
                          colors: [
                            _aqua.withOpacity(0.1),
                            _aqua,
                            _aqua.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Center icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _black,
                  border: Border.all(color: _aqua, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome, color: _aqua, size: 40),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'GENERATING YOUR ALTER',
          style: TextStyle(
            color: _aqua,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'This may take a moment...',
          style: TextStyle(color: _olive, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCompletedState() {
    return Column(
      children: [
        // ALTER preview
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _aqua, width: 3),
            boxShadow: [
              BoxShadow(
                color: _aqua.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    _aqua.withOpacity(0.3),
                    _aqua.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: _aqua, size: 50),
                    const SizedBox(height: 8),
                    Text(
                      'ALTER READY',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'YOUR ALTER IS READY',
          style: TextStyle(
            color: _mint,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your AI-enhanced avatar is now active and will be shown to compatible users.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _mint.withOpacity(0.8),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context, true);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: _aqua,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: _aqua.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'CONTINUE',
                style: TextStyle(
                  color: _black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            // Regenerate
            setState(() {
              _generationComplete = false;
              _isGenerating = false;
            });
          },
          child: Text(
            'Regenerate ALTER',
            style: TextStyle(
              color: _olive,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _startGeneration() async {
    HapticFeedback.mediumImpact();
    setState(() => _isGenerating = true);
    
    // Simulate generation time
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      _isGenerating = false;
      _generationComplete = true;
    });
    HapticFeedback.heavyImpact();
  }

  Widget _buildContinueButton({required bool enabled, String label = 'CONTINUE'}) {
    return GestureDetector(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              _nextStep();
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: enabled ? _aqua : _olive.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
          boxShadow: enabled
              ? [BoxShadow(color: _aqua.withOpacity(0.3), blurRadius: 15)]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: enabled ? _black : _olive,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _AlterStyle {
  final String name;
  final String description;
  final IconData icon;

  _AlterStyle(this.name, this.description, this.icon);
}

