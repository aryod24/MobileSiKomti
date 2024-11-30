import 'package:flutter/material.dart';

class LogoProfilWidget extends StatelessWidget {
  final VoidCallback onProfileTap;

  LogoProfilWidget({required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo tetap berada di sebelah kiri
        Image.asset(
          'assets/image/logonew.png',
          width: 60,
          height: 60,
        ),
        // Profil berada di sebelah kanan dan dapat diklik
        GestureDetector(
          onTap: onProfileTap,
          child: Image.asset(
            'assets/image/profile.png',
            width: 80,
            height: 80,
          ),
        ),
      ],
    );
  }
}
