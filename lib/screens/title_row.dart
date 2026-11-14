import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/motion.dart';
import '../widgets/poster_card.dart';
import '../widgets/toast.dart';
import '../widgets/ui.dart';

class TitleRow extends StatefulWidget {
  const TitleRow({
    super.key,
    required this.row,
    required this.onTapItem,
  });

  final RowData row;
  final ValueChanged<TitleItem> onTapItem;

  @override
  State<TitleRow> createState() => _TitleRowState();
}

class _TitleRowState extends State<TitleRow> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RowData row = widget.row;
    final double width = MediaQuery.sizeOf(context).width;
    final double cardWidth = row.wide
        ? (width * 0.37).clamp(132.0, 190.0)
        : row.items.length > 4
            ? (width * 0.30).clamp(104.0, 150.0)
            : (width - AppDimens.gutter * 2 - 30) / 3.15;

    final double height =
        row.wide ? cardWidth / 0.72 + 46 : cardWidth / AppDimens.posterRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(
          title: row.title,
          trailing: Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(
          height: height,
          child: ListView.separated(
            controller: _scroll,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
            itemCount: row.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (BuildContext context, int index) {
              final TitleItem item = row.items[index];

              if (row.showProgress) {
                return _ContinueCard(
                  item: item,
                  width: cardWidth,
                  onTap: () => widget.onTapItem(item),
                  onInfo: () =>
                      showToast(context, '${item.name} • ${item.metaLine}'),
                );
              }

              return PosterCard(
                item: item,
                width: cardWidth,
                onTap: () => widget.onTapItem(item),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.item,
    required this.width,
    required this.onTap,
    required this.onInfo,
  });

  final TitleItem item;
  final double width;
  final VoidCallback onTap;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: PosterCard(
              item: item,
              width: width,
              onTap: onTap,
              showProgress: true,
              progress: item.progress,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              _RoundAction(
                icon: Icons.play_arrow_rounded,
                onTap: onTap,
                size: 30,
                iconSize: 20,
              ),
              const SizedBox(width: 10),
              _RoundAction(
                icon: Icons.more_vert_rounded,
                onTap: onInfo,
                size: 30,
                iconSize: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.onTap,
    this.size = 30,
    this.iconSize = 18,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

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
          border: Border.all(color: const Color(0x59FFFFFF), width: 1.1),
          color: AppColors.background,
        ),
        child: Icon(icon, size: iconSize, color: AppColors.textPrimary),
      ),
    );
  }
}
