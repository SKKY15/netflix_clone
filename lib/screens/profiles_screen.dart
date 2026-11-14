import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/motion.dart';
import '../widgets/toast.dart';
import 'app_shell.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entry = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  )..forward();

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  String? _loadingName;

  @override
  void dispose() {
    _entry.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _openProfile(int index) async {
    if (_loadingName != null) {
      return;
    }

    final Profile profile = AppState.profiles[index];

    if (profile.id == 'guest') {
      showToast(context, 'Profile creation is not available in this demo');
      return;
    }

    setState(() => _loadingName = profile.name);

    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) {
      return;
    }

    AppScope.read(context).selectProfile(index);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 460),
        pageBuilder: (_, __, ___) => const AppShell(),
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          final Animation<double> curved = CurvedAnimation(
            parent: animation,
            curve: AppMotion.enter,
          );

          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.04, end: 1).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const List<Profile> profiles = AppState.profiles;
    final double width = MediaQuery.sizeOf(context).width;
    final double tile = math.min(104.0, (width - 72) / 2);
    final bool grid = width > 560;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 6),
                child: FadeTransition(
                  opacity: _entry,
                  child: TapScale(
                    onTap: () => showToast(
                        context, 'Profiles can be managed from this screen'),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Edit',
                        style: AppText.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    const Spacer(flex: 3),
                    FadeSlideIn(
                      child: Text(
                        "Who's Watching?",
                        style: AppText.cardTitle.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    SizedBox(
                      width: grid ? tile * 4 : tile * 2 + 24,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 26,
                        children: <Widget>[
                          for (int i = 0; i < profiles.length; i++)
                            _ProfileTile(
                              profile: profiles[i],
                              size: tile,
                              index: i,
                              entry: _entry,
                              pulse: _pulse,
                              loading: _loadingName == profiles[i].name,
                              dimmed: _loadingName != null &&
                                  _loadingName != profiles[i].name,
                              onTap: () => _openProfile(i),
                            ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.profile,
    required this.size,
    required this.index,
    required this.entry,
    required this.pulse,
    required this.loading,
    required this.dimmed,
    required this.onTap,
  });

  final Profile profile;
  final double size;
  final int index;
  final AnimationController entry;
  final AnimationController pulse;
  final bool loading;
  final bool dimmed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = CurvedAnimation(
      parent: entry,
      curve: Interval(
        index * 0.12,
        (index * 0.12 + 0.62).clamp(0, 1),
        curve: AppMotion.spring,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: animation.value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, 22 * (1 - animation.value)),
            child: Transform.scale(
              scale: 0.86 + 0.14 * animation.value,
              child: child,
            ),
          ),
        );
      },
      child: AnimatedOpacity(
        duration: AppMotion.normal,
        opacity: dimmed ? 0.35 : 1,
        child: SizedBox(
          width: size,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TapScale(
                onTap: onTap,
                scale: 0.93,
                duration: const Duration(milliseconds: 170),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      if (profile.isKids)
                        _KidsAvatar(size: size, pulse: pulse)
                      else if (profile.avatar != null)
                        _PhotoAvatar(profile: profile, size: size)
                      else
                        _AddAvatar(size: size),
                      if (loading)
                        Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            color:
                                Colors.black.withAlpha(((0.55) * 255).round()),
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusSm),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.red),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.body.copyWith(
                  fontSize: 13,
                  color: profile.isKids
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoAvatar extends StatelessWidget {
  const _PhotoAvatar({required this.profile, required this.size});

  final Profile profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AppImage(asset: profile.avatar!, alignment: Alignment.topCenter),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black.withAlpha(((0.45) * 255).round()),
                  ],
                  stops: const <double>[0.5, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KidsAvatar extends StatelessWidget {
  const _KidsAvatar({required this.size, required this.pulse});

  final double size;
  final AnimationController pulse;

  static const List<Color> _colors = <Color>[
    Color(0xFFFF3B30),
    Color(0xFFFF9500),
    Color(0xFFFFCC00),
    Color(0xFF34C759),
    Color(0xFF0A84FF),
    Color(0xFFBF5AF2),
    Color(0xFFFF2D55),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AnimatedBuilder(
              animation: pulse,
              builder: (BuildContext context, Widget? child) {
                return Row(
                  children: <Widget>[
                    for (int i = 0; i < _colors.length; i++)
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            math.sin(pulse.value * 6.28318 + i * 0.9) * 3,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: _colors[i]),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(((0.2) * 255).round()),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  'children',
                  style: AppText.logo.copyWith(
                    fontSize: size * 0.19,
                    letterSpacing: -0.6,
                    color: Colors.white,
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

class _AddAvatar extends StatelessWidget {
  const _AddAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(((0.35) * 255).round()),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: const Color(0x66FFFFFF), width: 1.2),
      ),
      child: Icon(
        Icons.add_rounded,
        size: size * 0.34,
        color: Colors.white.withAlpha(((0.85) * 255).round()),
      ),
    );
  }
}
