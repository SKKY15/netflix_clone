import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/motion.dart';
import 'home_screen.dart';
import 'my_netflix_screen.dart';
import 'new_hot_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final PageController _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _select(int index) {
    if (index == _index) {
      if (index == 0) {
        AppScope.read(context).setTab(0);
      }

      return;
    }

    setState(() => _index = index);

    _pages.animateToPage(
      index,
      duration: const Duration(milliseconds: 380),
      curve: AppMotion.enter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: PageView(
        controller: _pages,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          const HomeScreen(),
          const NewHotScreen(),
          const MyNetflixScreen(),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        index: _index,
        avatar: state.activeProfile.avatar,
        isKids: state.activeProfile.isKids,
        onSelect: _select,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.index,
    required this.avatar,
    required this.isKids,
    required this.onSelect,
  });

  final int index;
  final String? avatar;
  final bool isKids;
  final ValueChanged<int> onSelect;

  static const List<_NavItem> _items = <_NavItem>[
    _NavItem('Home', Icons.home_outlined, Icons.home_rounded),
    _NavItem('New & Hot', Icons.local_fire_department_outlined,
        Icons.local_fire_department_rounded),
    _NavItem('My Netflix', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: bottomInset > 0 ? bottomInset - 4 : 8),
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(((0.97) * 255).round()),
        border: const Border(top: BorderSide(color: Color(0x14FFFFFF))),
      ),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < _items.length; i++)
            Expanded(
              child: _NavButton(
                item: _items[i],
                selected: i == index,
                onTap: () => onSelect(i),
                avatar: i == 2 ? avatar : null,
                isKids: i == 2 && isKids,
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon, this.activeIcon);

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
    this.avatar,
    this.isKids = false,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final String? avatar;
  final bool isKids;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1, end: selected ? 1.12 : 1),
              duration: AppMotion.normal,
              curve: AppMotion.spring,
              builder: (BuildContext context, double scale, Widget? child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: avatar != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: isKids
                            ? DecoratedBox(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFFFF3B30),
                                      Color(0xFF34C759),
                                      Color(0xFF0A84FF),
                                    ],
                                  ),
                                ),
                              )
                            : Opacity(
                                opacity: selected ? 1 : 0.7,
                                child: AppImage(
                                  asset: avatar!,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                      ),
                    )
                  : Icon(
                      selected ? item.activeIcon : item.icon,
                      size: 23,
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: AppText.label.copyWith(
                fontSize: 9.5,
                letterSpacing: 0.1,
                color: selected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
