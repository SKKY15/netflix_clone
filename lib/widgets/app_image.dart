import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppImages {
  const AppImages._();

  static const String hero = 'assets/posters/hero_kandethum.webp';
  static const String neon = 'assets/posters/p_neon.webp';
  static const String action = 'assets/posters/p_action.webp';
  static const String horror = 'assets/posters/p_horror.webp';
  static const String romance = 'assets/posters/p_romance.webp';
  static const String drama = 'assets/posters/p_drama.webp';
  static const String teen = 'assets/posters/p_teen.webp';
  static const String scifi = 'assets/posters/p_scifi.webp';
  static const String thriller = 'assets/posters/p_thriller.webp';
  static const String comedy = 'assets/posters/p_comedy.webp';

  static const List<String> all = <String>[
    hero,
    neon,
    action,
    horror,
    romance,
    drama,
    teen,
    scifi,
    thriller,
    comedy,
  ];

  static Future<void> preload(BuildContext context) async {
    final List<Future<void>> tasks = <Future<void>>[];

    for (final String path in all) {
      tasks.add(
        precacheImage(
          AssetImage(path),
          context,
          onError: (Object error, StackTrace? stack) {},
        ),
      );
    }

    await Future.wait(tasks);
  }
}

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.fade = true,
  });

  final String asset;
  final BoxFit fit;
  final Alignment alignment;
  final bool fade;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      frameBuilder:
          (BuildContext context, Widget child, int? frame, bool sync) {
        if (!fade || sync) {
          return child;
        }

        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: AppMotion.normal,
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }
}

class ImageFallback extends StatelessWidget {
  const ImageFallback({super.key, this.tint = AppColors.surfaceHigh});

  final Color tint;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[tint, AppColors.surfaceLow],
        ),
      ),
    );
  }
}
