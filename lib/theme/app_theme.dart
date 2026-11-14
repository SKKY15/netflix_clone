import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceHigh = Color(0xFF1F1F1F);
  static const Color surfaceLow = Color(0xFF0B0B0B);
  static const Color border = Color(0xFF2C2C2C);

  static const Color red = Color(0xFFE50914);
  static const Color redDeep = Color(0xFFB0060F);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textMuted = Color(0xFF8C8C8C);

  static const Color green = Color(0xFF46D369);
  static const Color blue = Color(0xFF7BA3F5);
  static const Color gold = Color(0xFFF5C518);
}

class AppText {
  const AppText._();

  static const TextStyle logo = TextStyle(
    fontFamily: 'Anton',
    fontSize: 46,
    letterSpacing: 6,
    color: AppColors.red,
    height: 1.0,
  );

  static const TextStyle title = TextStyle(
    fontFamily: 'Anton',
    fontSize: 30,
    height: 1.06,
    letterSpacing: 0.6,
    color: AppColors.textPrimary,
  );

  static const TextStyle section = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15.5,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.textSecondary,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 8.5,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle meta = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );
}

class AppMotion {
  const AppMotion._();

  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 620);

  static const Curve enter = Cubic(0.16, 1.0, 0.3, 1.0);
  static const Curve exit = Cubic(0.5, 0.0, 0.75, 0.0);
  static const Curve spring = Cubic(0.34, 1.4, 0.4, 1.0);
}

class AppDimens {
  const AppDimens._();

  static const double gutter = 16;
  static const double posterRatio = 0.68;
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 14;
}

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    final ThemeData base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      textTheme: base.textTheme.apply(fontFamily: 'Inter'),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.red,
        secondary: AppColors.red,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: AppColors.red),
      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),
    );
  }
}
