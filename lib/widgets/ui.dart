import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'motion.dart';

class CategoryPill extends StatelessWidget {
  const CategoryPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.94,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.textPrimary : AppColors.border,
            width: 1,
          ),
        ),
        child: AnimatedDefaultTextStyle(
          duration: AppMotion.fast,
          style: AppText.label.copyWith(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: selected ? AppColors.background : AppColors.textPrimary,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.onTap,
    this.label = 'Play',
    this.expand = false,
    this.height = 40,
  });

  final VoidCallback onTap;
  final String label;
  final bool expand;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.96,
      child: Container(
        height: height,
        width: expand ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: expand ? 0 : 16),
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm + 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.play_arrow_rounded,
                size: 22, color: AppColors.background),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.background,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
    this.expand = false,
    this.height = 40,
  });

  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final bool expand;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.96,
      child: Container(
        height: height,
        width: expand ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: expand ? 0 : 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A).withAlpha(((0.92) * 255).round()),
          borderRadius: BorderRadius.circular(AppDimens.radiusSm + 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 19, color: AppColors.textPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(AppDimens.gutter, 18, AppDimens.gutter, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.section,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class TagBadge extends StatelessWidget {
  const TagBadge(
      {super.key, required this.label, this.color = AppColors.surfaceHigh});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(label, style: AppText.badge),
    );
  }
}

class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.background = const Color(0xCC1A1A1A),
    this.iconColor = AppColors.textPrimary,
    this.size = 38,
    this.iconSize = 19,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color background;
  final Color iconColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.88,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x33FFFFFF)),
        ),
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}

class GhostTextButton extends StatelessWidget {
  const GhostTextButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.color = AppColors.textSecondary,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.92,
      behavior: HitTestBehavior.deferToChild,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 21, color: color),
            const SizedBox(height: 5),
            Text(
              label,
              style: AppText.label.copyWith(
                fontSize: 9.5,
                color: color,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientScrim extends StatelessWidget {
  const GradientScrim({
    super.key,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.colors,
    this.stops,
  });

  final Alignment begin;
  final Alignment end;
  final List<Color>? colors;
  final List<double>? stops;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ??
              <Color>[
                Colors.transparent,
                AppColors.background.withAlpha(((0.35) * 255).round()),
                AppColors.background,
              ],
          stops: stops,
        ),
      ),
    );
  }
}
