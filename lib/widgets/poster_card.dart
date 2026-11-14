import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';
import 'motion.dart';

class PosterCard extends StatelessWidget {
  const PosterCard({
    super.key,
    required this.item,
    required this.width,
    required this.onTap,
    this.heroTag,
    this.showProgress = false,
    this.progress = 0,
    this.compact = false,
  });

  final TitleItem item;
  final double width;
  final VoidCallback onTap;
  final String? heroTag;
  final bool showProgress;
  final double progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final Widget poster = ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AppImage(
            asset: item.poster,
            alignment: Alignment.topCenter,
          ),
          if (showProgress)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black.withAlpha(((0.15) * 255).round()),
                    Colors.black.withAlpha(((0.55) * 255).round()),
                  ],
                  stops: const <double>[0.35, 0.7, 1],
                ),
              ),
            ),
          if (showProgress)
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withAlpha(((0.35) * 255).round()),
                  border: Border.all(
                      color: Colors.white.withAlpha(((0.75) * 255).round()),
                      width: 1.4),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          if (item.badge != null && !compact)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xE60A0A0A),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  item.badge!,
                  style:
                      AppText.badge.copyWith(fontSize: 8, letterSpacing: 0.6),
                ),
              ),
            ),
          if (showProgress)
            Positioned(
              left: 6,
              right: 6,
              bottom: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: progress),
                      duration: AppMotion.slow,
                      curve: AppMotion.enter,
                      builder:
                          (BuildContext context, double value, Widget? child) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 3,
                          backgroundColor: const Color(0x66FFFFFF),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.red),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    final Widget card = SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: heroTag == null
                ? poster
                : Hero(
                    tag: heroTag!,
                    child: poster,
                  ),
          ),
          if (compact) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.cardTitle.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              showProgress
                  ? '${(progress * 100).round()}% watched'
                  : item.duration,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.meta.copyWith(fontSize: 10),
            ),
          ],
        ],
      ),
    );

    return TapScale(
      onTap: onTap,
      scale: 0.96,
      duration: const Duration(milliseconds: 140),
      child: card,
    );
  }
}

class RankedPosterCard extends StatelessWidget {
  const RankedPosterCard({
    super.key,
    required this.item,
    required this.width,
    required this.rank,
    required this.onTap,
    this.heroTag,
  });

  final TitleItem item;
  final double width;
  final int rank;
  final VoidCallback onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final Widget poster = ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      child: AppImage(asset: item.poster, alignment: Alignment.topCenter),
    );

    return TapScale(
      onTap: onTap,
      scale: 0.96,
      duration: const Duration(milliseconds: 140),
      child: SizedBox(
        width: width,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              left: 0,
              bottom: -6,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontFamily: 'Anton',
                  fontSize: 104,
                  height: 1,
                  letterSpacing: -6,
                  color: Colors.transparent,
                  shadows: <Shadow>[
                    const Shadow(
                        color: Color(0xFF1C1C1C), offset: Offset(2, 0)),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              left: 34,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AspectRatio(
                  aspectRatio: AppDimens.posterRatio,
                  child: heroTag == null
                      ? poster
                      : Hero(
                          tag: heroTag!,
                          child: poster,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
