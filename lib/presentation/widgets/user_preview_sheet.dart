import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/now_map_model.dart';
import 'user_avatar_widget.dart';

class UserPreviewSheet extends StatelessWidget {
  final NowMapUser user;
  final bool isFavorite;
  final bool hasYoSent;
  final VoidCallback onYO;
  final VoidCallback onFavorite;
  final VoidCallback onChat;

  const UserPreviewSheet({
    super.key,
    required this.user,
    required this.isFavorite,
    required this.hasYoSent,
    required this.onYO,
    required this.onFavorite,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // User info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar and basic info
                _buildUserHeader(),
                const SizedBox(height: 20),
                
                // Tags and mood
                _buildUserDetails(),
                const SizedBox(height: 20),
                
                // Action buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        // Avatar
        UserAvatarWidget(
          user: user,
          size: 80,
          showGlow: true,
          showPulse: true,
        ),
        
        const SizedBox(width: 16),
        
        // User info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user.isVerified) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 4),
              
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(user.distance / 1000).toStringAsFixed(1)} km away',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 4),
              
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: user.isOnline 
                          ? const Color(0xFF4BEFE0)
                          : Colors.grey[600],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.isOnline ? 'Online now' : 'Last seen ${_getLastSeenText()}',
                    style: TextStyle(
                      color: user.isOnline 
                          ? const Color(0xFF4BEFE0)
                          : Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags
        if (user.tags.isNotEmpty) ...[
          const Text(
            'Interests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4BEFE0).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF4BEFE0)),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Color(0xFF4BEFE0),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        
        // Mood and role
        Row(
          children: [
            if (user.role != null) ...[
              _buildInfoChip(
                icon: _getRoleIcon(user.role!),
                label: user.role!.name.toUpperCase(),
                color: Colors.purple,
              ),
              const SizedBox(width: 12),
            ],
            _buildInfoChip(
              icon: _getMoodIcon(user.mood),
              label: user.mood.name.toUpperCase(),
              color: _getMoodColor(user.mood),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // YO button
        Expanded(
          child: _buildActionButton(
            icon: Icons.waving_hand,
            label: hasYoSent ? 'YO Sent!' : 'YO',
            color: hasYoSent ? Colors.grey : const Color(0xFF4BEFE0),
            onTap: hasYoSent ? null : onYO,
            isDisabled: hasYoSent,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Favorite button
        Expanded(
          child: _buildActionButton(
            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
            label: isFavorite ? 'Favorited' : 'Favorite',
            color: isFavorite ? Colors.red : Colors.grey[400]!,
            onTap: onFavorite,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Chat button
        Expanded(
          child: _buildActionButton(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            color: const Color(0xFF4BEFE0),
            onTap: onChat,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDisabled 
              ? Colors.grey[800]
              : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDisabled ? Colors.grey[600]! : color,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isDisabled ? Colors.grey[600] : color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isDisabled ? Colors.grey[600] : color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .scale(duration: const Duration(milliseconds: 200))
      .then()
      .shimmer(duration: const Duration(milliseconds: 1000), delay: const Duration(milliseconds: 500));
  }

  String _getLastSeenText() {
    final now = DateTime.now();
    final difference = now.difference(user.lastActive);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.top:
        return Icons.keyboard_arrow_up;
      case UserRole.bottom:
        return Icons.keyboard_arrow_down;
      case UserRole.vers:
        return Icons.swap_horiz;
      case UserRole.dom:
        return Icons.psychology;
      case UserRole.sub:
        return Icons.favorite;
      case UserRole.switch_:
        return Icons.swap_vert;
    }
  }

  IconData _getMoodIcon(UserMood mood) {
    switch (mood) {
      case UserMood.happy:
        return Icons.sentiment_satisfied;
      case UserMood.excited:
        return Icons.sentiment_very_satisfied;
      case UserMood.calm:
        return Icons.sentiment_neutral;
      case UserMood.mysterious:
        return Icons.visibility_off;
      case UserMood.playful:
        return Icons.sports_esports;
      case UserMood.serious:
        return Icons.sentiment_dissatisfied;
    }
  }

  Color _getMoodColor(UserMood mood) {
    switch (mood) {
      case UserMood.happy:
        return Colors.yellow;
      case UserMood.excited:
        return Colors.orange;
      case UserMood.calm:
        return Colors.green;
      case UserMood.mysterious:
        return Colors.purple;
      case UserMood.playful:
        return Colors.pink;
      case UserMood.serious:
        return Colors.red;
    }
  }
} 