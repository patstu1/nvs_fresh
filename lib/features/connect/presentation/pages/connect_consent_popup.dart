// NVS Connect Consent Popup (Prompt 4)
// First-time AI consent popup with glowing orb and toggle
// Triggered when user taps "Connect AI" tab for first time

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectConsentPopup extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const ConnectConsentPopup({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<ConnectConsentPopup> createState() => _ConnectConsentPopupState();

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (context) => ConnectConsentPopup(
        onAccept: () => Navigator.pop(context, true),
        onDecline: () => Navigator.pop(context, false),
      ),
    );
    return result ?? false;
  }
}

class _ConnectConsentPopupState extends State<ConnectConsentPopup>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _pulseController;
  late AnimationController _fadeController;
  
  bool _dataCollectionConsent = false;
  bool _alterConsent = false;
  bool _behaviorLearningConsent = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  bool get _canProceed => 
    _dataCollectionConsent && _alterConsent && _behaviorLearningConsent;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: _black,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _aqua.withOpacity(0.4), width: 1),
            boxShadow: [
              BoxShadow(
                color: _aqua.withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildGlowingOrb(),
                const SizedBox(height: 24),
                _buildTitle(),
                const SizedBox(height: 16),
                _buildDescription(),
                const SizedBox(height: 28),
                _buildConsentToggles(),
                const SizedBox(height: 28),
                _buildActions(),
                const SizedBox(height: 12),
                _buildFinePrint(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingOrb() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _aqua.withOpacity(0.5 * _pulseController.value + 0.2),
                blurRadius: 30 + (20 * _pulseController.value),
                spreadRadius: 5,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _aqua.withOpacity(0.6),
                  _aqua.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _aqua.withOpacity(0.4),
                  border: Border.all(color: _aqua, width: 2),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: _aqua,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        const Text(
          'WELCOME TO NVS',
          style: TextStyle(
            color: _mint,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'CONNECT AI',
          style: TextStyle(
            color: _aqua,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      'NVS uses advanced AI to learn your preferences, find compatible matches, and help you connect meaningfully. To power this experience, we need your consent for the following:',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _mint.withOpacity(0.8),
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  Widget _buildConsentToggles() {
    return Column(
      children: [
        _buildConsentItem(
          icon: Icons.analytics_outlined,
          title: 'Data Collection',
          description: 'We analyze your interactions to improve match accuracy',
          value: _dataCollectionConsent,
          onChanged: (v) => setState(() => _dataCollectionConsent = v),
        ),
        const SizedBox(height: 16),
        _buildConsentItem(
          icon: Icons.auto_awesome,
          title: 'ALTER Creation',
          description: 'Create an AI-enhanced version of your profile',
          value: _alterConsent,
          onChanged: (v) => setState(() => _alterConsent = v),
        ),
        const SizedBox(height: 16),
        _buildConsentItem(
          icon: Icons.psychology,
          title: 'Behavior Learning',
          description: 'NVS learns from your swipes and chats to refine recommendations',
          value: _behaviorLearningConsent,
          onChanged: (v) => setState(() => _behaviorLearningConsent = v),
        ),
      ],
    );
  }

  Widget _buildConsentItem({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!value);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: value ? _aqua.withOpacity(0.6) : _olive.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
          color: value ? _aqua.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: value ? _aqua : _olive, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: _mint,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      color: _olive,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            _buildCustomToggle(value),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomToggle(bool value) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? _aqua : _olive.withOpacity(0.5),
        ),
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

  Widget _buildActions() {
    return Column(
      children: [
        // Primary action - Accept
        GestureDetector(
          onTap: _canProceed
              ? () {
                  HapticFeedback.mediumImpact();
                  widget.onAccept();
                }
              : null,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _canProceed ? _aqua : _olive.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _canProceed
                      ? [
                          BoxShadow(
                            color: _aqua.withOpacity(0.3 * _pulseController.value + 0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'ENABLE NVS AI',
                    style: TextStyle(
                      color: _canProceed ? _black : _olive,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Secondary action - Decline
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onDecline();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: _olive.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                'MAYBE LATER',
                style: TextStyle(
                  color: _olive,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinePrint() {
    return GestureDetector(
      onTap: () {
        // Open privacy policy
      },
      child: Text(
        'By enabling, you agree to our Privacy Policy and AI Terms',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _olive.withOpacity(0.6),
          fontSize: 10,
          decoration: TextDecoration.underline,
          decorationColor: _olive.withOpacity(0.4),
        ),
      ),
    );
  }
}


