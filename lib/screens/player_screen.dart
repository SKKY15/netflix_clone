import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/motion.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.item, this.startAt = 0});

  final TitleItem item;
  final int startAt;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _kenBurns = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..forward();

  Timer? _ticker;
  Timer? _hideTimer;

  bool _controls = true;
  bool _buffering = true;
  bool _playing = true;
  double _position = 0.02;

  static const double _total = 148;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Future<void>.delayed(const Duration(milliseconds: 760), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _buffering = false;
        _position = widget.startAt == 0 ? 0.02 : 0.12;
      });

      _scheduleHide();
    });

    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted || !_playing || _buffering) {
        return;
      }

      setState(() {
        _position += 0.25 / _total;

        if (_position >= 1) {
          _position = 1;
          _playing = false;
          _controls = true;
        }
      });
    });
  }

  void _scheduleHide() {
    _hideTimer?.cancel();

    if (!_playing) {
      return;
    }

    _hideTimer = Timer(const Duration(milliseconds: 3200), () {
      if (mounted) {
        setState(() => _controls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _controls = !_controls);

    if (_controls) {
      _scheduleHide();
    }
  }

  void _togglePlay() {
    setState(() {
      _playing = !_playing;
      _controls = true;
    });

    _scheduleHide();
  }

  void _seek(double delta) {
    setState(() {
      _position = (_position + delta / _total).clamp(0.0, 1.0);
      _controls = true;
    });

    _scheduleHide();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _hideTimer?.cancel();
    _kenBurns.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _format(double value) {
    final int total = (_total * value).round();
    final int minutes = total ~/ 60;
    final int seconds = total % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AnimatedBuilder(
              animation: _kenBurns,
              builder: (BuildContext context, Widget? child) {
                final double value =
                    Curves.easeInOut.transform(_kenBurns.value);

                return Transform.scale(
                  scale: 1.12 + 0.12 * value,
                  child: Transform.translate(
                    offset: Offset(-12 + 24 * value, -8 + 10 * value),
                    child: child,
                  ),
                );
              },
              child: AppImage(
                  asset: widget.item.poster, alignment: Alignment.center),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0x8C000000),
                      Color(0x14000000),
                      Color(0x14000000),
                      Color(0xA6000000),
                    ],
                    stops: <double>[0, 0.24, 0.62, 1],
                  ),
                ),
              ),
            ),
            if (_buffering)
              const Center(
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
                  ),
                ),
              ),
            AnimatedOpacity(
              opacity: _controls ? 1 : 0,
              duration: AppMotion.normal,
              child: IgnorePointer(
                ignoring: !_controls,
                child: _Controls(
                  item: widget.item,
                  playing: _playing,
                  position: _position,
                  positionLabel: _format(_position),
                  remainingLabel: '-${_format(1 - _position)}',
                  topInset: topInset,
                  onPlayToggle: _togglePlay,
                  onBack: () => Navigator.of(context).maybePop(),
                  onSeekBack: () => _seek(-10),
                  onSeekForward: () => _seek(10),
                  onScrub: (double value) {
                    setState(() => _position = value);
                    _scheduleHide();
                  },
                  onLockTap: () => setState(() {
                    _playing = false;
                    _controls = true;
                  }),
                ),
              ),
            ),
            if (!_controls)
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.paddingOf(context).bottom + 18,
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(((0.45) * 255).round()),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const PulsingDot(size: 5, color: AppColors.red),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.item.name}  •  ${_format(_position)}',
                            style: AppText.meta.copyWith(
                              fontSize: 10.5,
                              color: Colors.white
                                  .withAlpha(((0.85) * 255).round()),
                            ),
                          ),
                        ],
                      ),
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

class _Controls extends StatelessWidget {
  const _Controls({
    required this.item,
    required this.playing,
    required this.position,
    required this.positionLabel,
    required this.remainingLabel,
    required this.topInset,
    required this.onPlayToggle,
    required this.onBack,
    required this.onSeekBack,
    required this.onSeekForward,
    required this.onScrub,
    required this.onLockTap,
  });

  final TitleItem item;
  final bool playing;
  final double position;
  final String positionLabel;
  final String remainingLabel;
  final double topInset;
  final VoidCallback onPlayToggle;
  final VoidCallback onBack;
  final VoidCallback onSeekBack;
  final VoidCallback onSeekForward;
  final ValueChanged<double> onScrub;
  final VoidCallback onLockTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(8, topInset + 6, 16, 0),
          child: Row(
            children: <Widget>[
              PressableIcon(
                icon: Icons.keyboard_arrow_down_rounded,
                size: 30,
                onTap: onBack,
              ),
              const Spacer(),
              Text(
                'Preview',
                style: AppText.label.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.4,
                  color: Colors.white.withAlpha(((0.75) * 255).round()),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _CircleAction(
              icon: Icons.replay_10_rounded,
              size: 46,
              onTap: onSeekBack,
            ),
            const SizedBox(width: 34),
            _CircleAction(
              icon: playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 72,
              iconSize: 38,
              filled: true,
              onTap: onPlayToggle,
            ),
            const SizedBox(width: 34),
            _CircleAction(
              icon: Icons.forward_10_rounded,
              size: 46,
              onTap: onSeekForward,
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.cardTitle.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 2),
              Text(
                item.genres.join('  •  '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.meta.copyWith(fontSize: 10.5),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 10),
              Text(
                positionLabel,
                style:
                    AppText.meta.copyWith(fontSize: 10.5, color: Colors.white),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2.5,
                    activeTrackColor: AppColors.red,
                    inactiveTrackColor:
                        Colors.white.withAlpha(((0.35) * 255).round()),
                    thumbColor: AppColors.red,
                    overlayColor:
                        AppColors.red.withAlpha(((0.15) * 255).round()),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 5.5),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 14),
                    trackShape: const RectangularSliderTrackShape(),
                  ),
                  child: Slider(
                    value: position.clamp(0.0, 1.0),
                    onChanged: onScrub,
                  ),
                ),
              ),
              Text(
                remainingLabel,
                style:
                    AppText.meta.copyWith(fontSize: 10.5, color: Colors.white),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              16, 4, 16, MediaQuery.paddingOf(context).bottom + 14),
          child: Row(
            children: <Widget>[
              PressableIcon(
                icon: Icons.lock_outline_rounded,
                size: 20,
                color: Colors.white.withAlpha(((0.8) * 255).round()),
                onTap: onLockTap,
              ),
              const SizedBox(width: 18),
              PressableIcon(
                icon: Icons.volume_up_outlined,
                size: 20,
                color: Colors.white.withAlpha(((0.8) * 255).round()),
                onTap: () {},
              ),
              const Spacer(),
              PressableIcon(
                icon: Icons.subtitles_outlined,
                size: 20,
                color: Colors.white.withAlpha(((0.8) * 255).round()),
                onTap: () {},
              ),
              const SizedBox(width: 14),
              PressableIcon(
                icon: Icons.speed_rounded,
                size: 20,
                color: Colors.white.withAlpha(((0.8) * 255).round()),
                onTap: () {},
              ),
              const SizedBox(width: 14),
              PressableIcon(
                icon: Icons.fullscreen_rounded,
                size: 22,
                color: Colors.white.withAlpha(((0.8) * 255).round()),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.size,
    required this.onTap,
    this.iconSize,
    this.filled = false,
  });

  final IconData icon;
  final double size;
  final VoidCallback onTap;
  final double? iconSize;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.85,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled
              ? Colors.white.withAlpha(((0.16) * 255).round())
              : Colors.transparent,
          border: Border.all(
            color: Colors.white.withAlpha(((filled ? 0.0 : 0.0) * 255).round()),
          ),
        ),
        child: Icon(
          icon,
          size: iconSize ?? size * 0.55,
          color: Colors.white,
        ),
      ),
    );
  }
}
