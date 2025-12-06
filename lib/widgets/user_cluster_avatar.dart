import 'package:flutter/material.dart';

class NowUserAvatarModel {
  final String image;
  final bool isAnonymous;
  const NowUserAvatarModel({required this.image, this.isAnonymous = false});
}

class UserClusterAvatar extends StatelessWidget {
  final NowUserAvatarModel user;

  const UserClusterAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF00FF88), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF88).withValues(alpha: 0.25),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: user.isAnonymous
            ? Container(
                color: Colors.black,
                child: Icon(Icons.visibility_off, color: Colors.grey[700], size: 32),
              )
            : Image.asset(user.image, fit: BoxFit.cover),
      ),
    );
  }
}
