import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NetflixLogo extends StatelessWidget {
  const NetflixLogo({
    super.key,
    this.reveal = 1,
    this.size = 58,
    this.color = AppColors.red,
  });

  final double reveal;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: LogoBlockClipper(reveal: reveal, bands: 14),
      child: Text(
        'NETFLIX',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Anton',
          fontSize: size,
          height: 1.02,
          letterSpacing: size * 0.012,
          color: color,
        ),
      ),
    );
  }
}

class LogoBlockClipper extends CustomClipper<Path> {
  const LogoBlockClipper({required this.reveal, this.bands = 14});

  final double reveal;
  final int bands;

  @override
  Path getClip(Size size) {
    final double value = reveal.clamp(0.0, 1.0);
    final Path path = Path();

    if (value <= 0) {
      return path;
    }

    if (value >= 1) {
      path.addRect(Offset.zero & size);
      return path;
    }

    final double bandHeight = size.height / bands;
    final double edge = value * (size.width + bandHeight * 1.6);

    for (int i = 0; i < bands; i++) {
      final double wave = (i.isEven ? 1 : -1) * bandHeight * 0.6;
      final double stagger = (i % 3) * bandHeight * 0.5;
      final double width = (edge + wave + stagger).clamp(0.0, size.width);

      path.addRect(Rect.fromLTWH(0, i * bandHeight, width, bandHeight + 0.8));
    }

    return path;
  }

  @override
  bool shouldReclip(covariant LogoBlockClipper oldClipper) {
    return oldClipper.reveal != reveal || oldClipper.bands != bands;
  }
}

class NetflixMark extends StatelessWidget {
  const NetflixMark({super.key, this.size = 26, this.color = AppColors.red});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'N',
      style: TextStyle(
        fontFamily: 'Anton',
        fontSize: size,
        height: 1.1,
        color: color,
      ),
    );
  }
}
