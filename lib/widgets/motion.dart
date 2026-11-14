import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 520),
    this.offset = const Offset(0, 0.16),
    this.curve = AppMotion.enter,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration + delay,
      curve: Interval(
        (delay.inMilliseconds /
                (duration.inMilliseconds + delay.inMilliseconds))
            .clamp(0.0, 0.95),
        1,
        curve: curve,
      ),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(
                offset.dx * (1 - value) * 60, offset.dy * (1 - value) * 60),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class TapScale extends StatefulWidget {
  const TapScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.95,
    this.duration = AppMotion.fast,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;
  final HitTestBehavior behavior;

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _pressed = false;

  void _set(bool value) {
    if (_pressed == value) {
      return;
    }

    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (_) => _set(true),
      onTapCancel: () => _set(false),
      onTapUp: (_) {
        _set(false);
        widget.onTap?.call();
      },
      onTap: widget.onTap == null ? null : () {},
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class PressableIcon extends StatelessWidget {
  const PressableIcon({
    super.key,
    required this.icon,
    this.size = 22,
    this.color = AppColors.textPrimary,
    this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final Widget button = TapScale(
      onTap: onTap,
      scale: 0.82,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: size, color: color),
      ),
    );

    if (tooltip == null) {
      return button;
    }

    return Tooltip(message: tooltip!, child: button);
  }
}

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.radius = AppDimens.radiusSm,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double shift = _controller.value * 2 - 1;

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + shift, -0.4),
              end: Alignment(1 + shift, 0.4),
              colors: const <Color>[
                AppColors.surface,
                AppColors.surfaceHigh,
                AppColors.surface,
              ],
              stops: const <double>[0.2, 0.5, 0.8],
            ),
          ),
        );
      },
    );
  }
}

class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.step = const Duration(milliseconds: 55),
    this.base = const Duration(milliseconds: 60),
    this.duration = const Duration(milliseconds: 420),
  });

  final int index;
  final Widget child;
  final Duration step;
  final Duration base;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      delay: base + step * index,
      duration: duration,
      offset: const Offset(0, 0.10),
      child: child,
    );
  }
}

class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key, this.size = 6, this.color = AppColors.red});

  final double size;
  final Color color;

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double value = Curves.easeInOut.transform(_controller.value);

        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                widget.color.withAlpha(((0.55 + 0.45 * value) * 255).round()),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: widget.color.withAlpha(((0.35 * value) * 255).round()),
                blurRadius: 8 * value,
                spreadRadius: 2 * value,
              ),
            ],
          ),
        );
      },
    );
  }
}
