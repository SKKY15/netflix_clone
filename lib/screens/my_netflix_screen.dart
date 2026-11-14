import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../data/catalog.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/motion.dart';
import '../widgets/poster_card.dart';
import '../widgets/toast.dart';
import '../widgets/ui.dart';
import 'details_screen.dart';
import 'profiles_screen.dart';

class MyNetflixScreen extends StatefulWidget {
  const MyNetflixScreen({super.key});

  @override
  State<MyNetflixScreen> createState() => _MyNetflixScreenState();
}

class _MyNetflixScreenState extends State<MyNetflixScreen> {
  bool _autoplay = true;
  bool _downloadsWifi = false;
  bool _notifications = true;

  void _open(TitleItem item) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, __, ___) => DetailsScreen(item: item),
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(
                  CurvedAnimation(parent: animation, curve: AppMotion.enter)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final Profile profile = state.activeProfile;
    final double topInset = MediaQuery.paddingOf(context).top;
    final List<TitleItem> saved = Catalog.all
        .where((TitleItem item) => state.isSaved(item.id))
        .toList(growable: false);

    return ListView(
      padding: EdgeInsets.only(top: topInset + 12, bottom: 110),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 26,
                height: 26,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: profile.isKids
                      ? const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFFFF3B30),
                                Color(0xFF34C759),
                                Color(0xFF0A84FF),
                              ],
                            ),
                          ),
                        )
                      : profile.avatar == null
                          ? const ImageFallback()
                          : AppImage(
                              asset: profile.avatar!,
                              alignment: Alignment.topCenter),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.cardTitle
                      .copyWith(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: Colors.white.withAlpha(((0.7) * 255).round()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _QuickAction(
                  label: 'Notifications',
                  icon: Icons.notifications_none_rounded,
                  onTap: () => showToast(context, 'No new notifications'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickAction(
                  label: 'Downloads',
                  icon: Icons.download_done_rounded,
                  onTap: () =>
                      showToast(context, 'No downloads on this device'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionHeader(
          title: 'My List',
          trailing: Text(
            saved.length == 1 ? '1 title' : '${saved.length} titles',
            style: AppText.meta.copyWith(fontSize: 11),
          ),
        ),
        if (saved.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.gutter, vertical: 18),
            child: Text(
              'Titles you add to My List will appear here.',
              style: AppText.body.copyWith(fontSize: 12.5),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
              itemCount: saved.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (BuildContext context, int index) {
                final TitleItem item = saved[index];

                return PosterCard(
                  item: item,
                  width: 112,
                  onTap: () => _open(item),
                );
              },
            ),
          ),
        const SizedBox(height: 18),
        const SectionHeader(title: 'Your Account'),
        _SettingTile(
          icon: Icons.settings_outlined,
          label: 'App Settings',
          onTap: () => showToast(context, 'Streamly 1.0.0 • Flutter build'),
        ),
        _SettingTile(
          icon: Icons.lock_outline_rounded,
          label: 'Privacy & Security',
          onTap: () => showToast(context, 'Your data stays on this device'),
        ),
        _SettingTile(
          icon: Icons.help_outline_rounded,
          label: 'Help Center',
          onTap: () =>
              showToast(context, 'Documentation is offline in this demo'),
        ),
        const SizedBox(height: 10),
        const SectionHeader(title: 'Playback'),
        _SwitchTile(
          label: 'Autoplay next episode',
          value: _autoplay,
          onChanged: (bool value) => setState(() => _autoplay = value),
        ),
        _SwitchTile(
          label: 'Download over Wi-Fi only',
          value: _downloadsWifi,
          onChanged: (bool value) => setState(() => _downloadsWifi = value),
        ),
        _SwitchTile(
          label: 'Push notifications',
          value: _notifications,
          onChanged: (bool value) => setState(() => _notifications = value),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
          child: SecondaryButton(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder<void>(
                  transitionDuration: const Duration(milliseconds: 420),
                  pageBuilder: (_, __, ___) => const ProfilesScreen(),
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
                (Route<dynamic> route) => false,
              );
            },
            label: 'Switch Profile',
            icon: Icons.swap_horiz_rounded,
            expand: true,
            height: 44,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: <Widget>[
              Text(
                'STREAMLY',
                style: AppText.logo.copyWith(
                  fontSize: 18,
                  letterSpacing: 4,
                  color: Colors.white.withAlpha(((0.18) * 255).round()),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Version 1.0.0 (24)',
                style: AppText.meta.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.96,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 22, color: AppColors.textPrimary),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppText.label.copyWith(
                fontSize: 10.5,
                color: AppColors.textSecondary,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      behavior: HitTestBehavior.deferToChild,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.gutter, vertical: 13),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 19, color: AppColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppText.body
                    .copyWith(fontSize: 13, color: AppColors.textPrimary),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Colors.white.withAlpha(((0.35) * 255).round()),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimens.gutter, vertical: 2),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: AppText.body
                  .copyWith(fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          Transform.scale(
            scale: 0.78,
            child: Switch(
              value: value,
              onChanged: onChanged,
              // ignore: deprecated_member_use
              activeColor: AppColors.background,
              activeTrackColor: AppColors.red,
              inactiveThumbColor: const Color(0xFFB3B3B3),
              inactiveTrackColor: const Color(0xFF3A3A3A),
            ),
          ),
        ],
      ),
    );
  }
}
