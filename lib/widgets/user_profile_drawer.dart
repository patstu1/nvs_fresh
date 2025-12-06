import 'package:flutter/material.dart';
import '../data/mock_user_data.dart';

class UserProfileDrawer extends StatelessWidget {
  final MockUser user;
  final VoidCallback onClose;

  const UserProfileDrawer({
    super.key,
    required this.user,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      left: 0,
      right: 0,
      bottom: 0,
      height: MediaQuery.of(context).size.height * 0.55,
      child: Material(
        color: Colors.black.withValues(alpha: 0.98),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFF00FF88),
                    child: user.isAnonymous
                        ? const Icon(Icons.visibility_off,
                            color: Colors.black, size: 32)
                        : ClipOval(
                            child: Image.asset(
                              user.image,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    user.isAnonymous ? 'Anonymous' : 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'FFMagdaClean',
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: onClose,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Chat overlay placeholder
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Chat overlay goes here',
                      style: TextStyle(
                        color: Color(0xFF00FF88),
                        fontSize: 16,
                        fontFamily: 'FFMagdaClean',
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
}
