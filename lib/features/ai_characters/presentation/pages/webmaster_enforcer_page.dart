import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nvs/features/ai_characters/data/ai_character_repository.dart';
import '../../data/ai_character_model.dart';
import '../../data/ai_character_provider.dart';
import '../widgets/animated_ai_character.dart';

class WebmasterEnforcerPage extends ConsumerStatefulWidget {
  const WebmasterEnforcerPage({super.key});

  @override
  ConsumerState<WebmasterEnforcerPage> createState() => _WebmasterEnforcerPageState();
}

class _WebmasterEnforcerPageState extends ConsumerState<WebmasterEnforcerPage> {
  final TextEditingController _reportController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedReason;
  final List<String> _evidence = <String>[];

  final List<String> _reportReasons = <String>[
    'Inappropriate content',
    'Harassment or bullying',
    'Spam or fake profiles',
    'Underage user',
    'Violence or threats',
    'Impersonation',
    'Other',
  ];

  final List<Map<String, dynamic>> _communityRules = <Map<String, dynamic>>[
    <String, dynamic>{
      'title': 'Respect & Consent',
      'description':
          'Always treat others with respect. No harassment, bullying, or unwanted advances.',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
    <String, dynamic>{
      'title': 'Authenticity',
      'description': 'Be yourself. No fake profiles, impersonation, or misleading information.',
      'icon': Icons.verified,
      'color': Colors.blue,
    },
    <String, dynamic>{
      'title': 'Age Requirements',
      'description': 'You must be 18 or older to use this platform. No exceptions.',
      'icon': Icons.person,
      'color': Colors.orange,
    },
    <String, dynamic>{
      'title': 'Content Guidelines',
      'description': 'No explicit content, violence, or illegal activities in public spaces.',
      'icon': Icons.photo_library,
      'color': Colors.purple,
    },
    <String, dynamic>{
      'title': 'Privacy & Safety',
      'description': "Respect others' privacy. No sharing of personal information without consent.",
      'icon': Icons.security,
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeWebmaster();
  }

  void _initializeWebmaster() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiCharacterProvider.notifier).showCharacter(AICharacterType.webmaster);
    });
  }

  @override
  void dispose() {
    _reportController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildReportDialog(),
    );
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildRulesDialog(),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildHelpDialog(),
    );
  }

  Future<void> _submitReport() async {
    if (_selectedReason == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final AICharacterRepository repository = ref.read(aiCharacterRepositoryProvider);
      await repository.reportUser(
        reportedUserId: _reportController.text,
        reason: _selectedReason!,
        description: _descriptionController.text,
        evidence: _evidence,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _reportController.clear();
        _descriptionController.clear();
        _selectedReason = null;
        _evidence.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: <Widget>[
                // Header
                _buildHeader(),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Welcome message
                        _buildWelcomeSection(),

                        const SizedBox(height: 30),

                        // Quick actions
                        _buildQuickActions(),

                        const SizedBox(height: 30),

                        // Recent reports
                        _buildRecentReports(),

                        const SizedBox(height: 30),

                        // Community rules preview
                        _buildRulesPreview(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Webmaster character
          Positioned(
            bottom: 20,
            right: 20,
            child: AnimatedAICharacter(
              characterType: AICharacterType.webmaster,
              floating: true,
              onTap: () {
                ref.read(aiCharacterProvider.notifier).triggerAnimation(
                      AICharacterType.webmaster,
                      AICharacterState.warning,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Webmaster',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF6B6B).withValues(alpha: 0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.security, color: Color(0xFFFF6B6B), size: 24),
              SizedBox(width: 12),
              Text(
                'Digital Guardian',
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'I am Webmaster, guardian of this digital realm. I ensure the safety and integrity of our community. How may I assist you today?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildActionCard(
                'Report User',
                Icons.report,
                const Color(0xFFFF6B6B),
                _showReportDialog,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                'View Rules',
                Icons.rule,
                Colors.blue,
                _showRulesDialog,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildActionCard(
                'Get Help',
                Icons.help,
                Colors.green,
                _showHelpDialog,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                'Privacy',
                Icons.privacy_tip,
                Colors.purple,
                () {
                  // Navigate to privacy settings
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: <Widget>[
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReports() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Recent Reports',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: ref.read(aiCharacterRepositoryProvider).getUserReports(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if (snapshot.hasError) {
              return const Text(
                'Error loading reports',
                style: TextStyle(color: Colors.red),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF6B6B)),
              );
            }

            final List<QueryDocumentSnapshot<Object?>> reports =
                snapshot.data?.docs ?? <QueryDocumentSnapshot<Object?>>[];

            if (reports.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'No reports submitted yet',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reports.take(3).length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> report = reports[index].data() as Map<String, dynamic>;
                return _buildReportCard(report);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                _getReportIcon(report['reason']),
                color: _getReportColor(report['reason']),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  report['reason'] ?? 'Unknown reason',
                  style: TextStyle(
                    color: _getReportColor(report['reason']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(report['status']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report['status'] ?? 'pending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report['description'] ?? '',
            style: const TextStyle(color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'Reported: ${_formatTimestamp(report['timestamp'])}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  IconData _getReportIcon(String? reason) {
    switch (reason) {
      case 'Inappropriate content':
        return Icons.photo_library;
      case 'Harassment or bullying':
        return Icons.block;
      case 'Spam or fake profiles':
        return Icons.person_off;
      case 'Underage user':
        return Icons.child_care;
      case 'Violence or threats':
        return Icons.warning;
      case 'Impersonation':
        return Icons.person_remove;
      default:
        return Icons.report;
    }
  }

  Color _getReportColor(String? reason) {
    switch (reason) {
      case 'Inappropriate content':
        return Colors.orange;
      case 'Harassment or bullying':
        return Colors.red;
      case 'Spam or fake profiles':
        return Colors.purple;
      case 'Underage user':
        return Colors.amber;
      case 'Violence or threats':
        return Colors.red;
      case 'Impersonation':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'resolved':
        return Colors.green;
      case 'investigating':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final DateTime now = DateTime.now();
      final Duration diff = now.difference(timestamp.toDate());

      if (diff.inDays > 0) {
        return '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    }
    return 'Unknown';
  }

  Widget _buildRulesPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Community Guidelines',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._communityRules.take(3).map(_buildRuleCard),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _showRulesDialog,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF6B6B)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'View All Rules',
              style: TextStyle(
                color: Color(0xFFFF6B6B),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRuleCard(Map<String, dynamic> rule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: rule['color'].withValues(alpha: 0.3)),
      ),
      child: Row(
        children: <Widget>[
          Icon(rule['icon'], color: rule['color'], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  rule['title'],
                  style: TextStyle(
                    color: rule['color'],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rule['description'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportDialog() {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Report User',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _reportController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'User ID or Username',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedReason,
              style: const TextStyle(color: Colors.white),
              dropdownColor: Colors.grey[900],
              decoration: const InputDecoration(
                labelText: 'Reason for Report',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
              items: _reportReasons.map((String reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(reason, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
          ),
          child: const Text('Submit Report'),
        ),
      ],
    );
  }

  Widget _buildRulesDialog() {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Community Guidelines',
        style: TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _communityRules.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> rule = _communityRules[index];
            return _buildRuleCard(rule);
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildHelpDialog() {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Help & Support',
        style: TextStyle(color: Colors.white),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'How can I help you?',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '• Report inappropriate behavior\n'
            '• Get help with account issues\n'
            '• Learn about privacy settings\n'
            '• Understand community rules\n'
            '• Contact support team',
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
