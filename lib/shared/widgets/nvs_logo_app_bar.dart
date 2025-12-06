import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/widgets/nvs_logo.dart';

class NvsLogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NvsLogoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const NvsLogo(size: 32),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
