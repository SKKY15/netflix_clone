import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/motion.dart';
import 'details_screen.dart';

class NewHotScreen extends StatefulWidget {
  const NewHotScreen({super.key});

  @override
  State<NewHotScreen> createState() => _NewHotScreenState();
}

class _NewHotScreenState extends State<NewHotScreen> {
  int _tab = 0;

  static const List<String> _tabs = <String>[
    'Coming Soon',
    'Everyone’s Watching'
  ];

  List<TitleItem> get _items {
    final List<TitleItem> list = List<TitleItem>.of(Catalog.all);

    if (_tab == 1) {
      list.sort((TitleItem a, TitleItem b) => b.match.compareTo(a.match));
    } else {
      list.sort((TitleItem a, TitleItem b) => b.year.compareTo(a.year));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;
    final List<TitleItem> items = _items;

    return Stack(
      children: <Widget>[
        ListView.builder(
          padding: EdgeInsets.only(top: topInset + 108, bottom: 110),
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final TitleItem item = items[index];

            return StaggeredEntrance(
              index: index,
              child: _NewHotTile(
                item: item,
                rank: _tab == 1 ? index + 1 : null,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DetailsScreen(item: item),
                    ),
                  );
                },
              ),
            );
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(top: topInset + 10, bottom: 10),
            color: AppColors.background,
            child: Column(
              children: <Widget>[
                Text(
                  'New & Hot',
                  style: AppText.cardTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < _tabs.length; i++)
                        Expanded(
                          child: _TabHeader(
                            label: _tabs[i],
                            selected: _tab == i,
                            onTap: () => setState(() => _tab = i),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TabHeader extends StatelessWidget {
  const _TabHeader({
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
      behavior: HitTestBehavior.deferToChild,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.label.copyWith(
                fontSize: 12,
                letterSpacing: 0.1,
                color: selected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ),
          AnimatedContainer(
            duration: AppMotion.normal,
            curve: AppMotion.enter,
            height: 2.4,
            width: selected ? 92 : 0,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewHotTile extends StatelessWidget {
  const _NewHotTile({required this.item, required this.onTap, this.rank});

  final TitleItem item;
  final VoidCallback onTap;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.985,
      duration: const Duration(milliseconds: 140),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppDimens.gutter, 6, AppDimens.gutter, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  child: SizedBox(
                    width: 108,
                    height: 152,
                    child: AppImage(
                        asset: item.poster, alignment: Alignment.topCenter),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          if (rank != null) ...<Widget>[
                            Text(
                              '$rank',
                              style: AppText.logo.copyWith(
                                fontSize: 19,
                                color: AppColors.red,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.cardTitle.copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${item.badge ?? 'NEW'}  •  ${item.genres.first}',
                        style: AppText.meta
                            .copyWith(fontSize: 10.5, letterSpacing: 0.4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.synopsis,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body.copyWith(fontSize: 11.5),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.textPrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Icon(
                                  Icons.notifications_none_rounded,
                                  size: 14,
                                  color: AppColors.background,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Remind Me',
                                  style: AppText.label.copyWith(
                                    fontSize: 10.5,
                                    color: AppColors.background,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.share_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Text(item.metaLine,
                    style: AppText.meta.copyWith(fontSize: 10.5)),
                const Spacer(),
                const PulsingDot(size: 5),
                const SizedBox(width: 6),
                Text(
                  '${item.match}% match',
                  style: AppText.meta
                      .copyWith(fontSize: 10.5, color: AppColors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
