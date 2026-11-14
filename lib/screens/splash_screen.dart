import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/netflix_logo.dart';
import 'profiles_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1150),
  );

  late final AnimationController _swap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3400),
  );

  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    value: 0,
  );

  Timer? _navTimer;
  Timer? _preloadTimer;

  @override
  void initState() {
    super.initState();

    _reveal.forward();

    _swap.repeat();

    _navTimer = Timer(const Duration(milliseconds: 3050), _goNext);

    _preloadTimer = Timer(const Duration(milliseconds: 380), () {
      if (mounted) {
        unawaited(AppImages.preload(context));
      }
    });
  }

  void _goNext() {
    if (!mounted) {
      return;
    }

    _fade.forward().whenComplete(() {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 520),
          pageBuilder: (_, __, ___) => const ProfilesScreen(),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(
              opacity:
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _preloadTimer?.cancel();
    _reveal.dispose();
    _swap.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[_reveal, _swap, _fade]),
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: 1 - _fade.value,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.1),
                        radius: 0.85,
                        colors: <Color>[
                          AppColors.red
                              .withAlpha(((0.1 * _reveal.value) * 255).round()),
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Transform.scale(
                    scale: 1 + 0.14 * _fade.value,
                    child: NetflixLogo(
                      reveal: Curves.easeInOutCubic.transform(_reveal.value),
                      size: _logoSize(context),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).padding.bottom + 34,
                  child: Opacity(
                    opacity: _reveal.value.clamp(0, 1) * 0.9,
                    child: const _SplashFooter(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _logoSize(BuildContext context) {
    return MediaQuery.sizeOf(context).width.clamp(320, 900) * 0.115;
  }
}

class _SplashFooter extends StatelessWidget {
  const _SplashFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            strokeWidth: 1.6,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withAlpha(((0.28) * 255).round()),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Preparing your next watch',
          style: AppText.body.copyWith(
            fontSize: 11,
            color: Colors.white.withAlpha(((0.34) * 255).round()),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
