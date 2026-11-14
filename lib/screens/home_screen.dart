import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../data/catalog.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/motion.dart';
import '../widgets/netflix_logo.dart';
import '../widgets/toast.dart';
import '../widgets/ui.dart';
import 'details_screen.dart';
import 'search_screen.dart';
import 'title_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scroll = ScrollController();

  double _offset = 0;

  @override
  void initState() {
    super.initState();

    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final double value = _scroll.hasClients ? _scroll.offset : 0;

    if ((value - _offset).abs() > 0.5) {
      setState(() => _offset = value);
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _openTitle(BuildContext context, TitleItem item, {String? heroTag}) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 480),
        reverseTransitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (_, __, ___) =>
            DetailsScreen(item: item, heroTag: heroTag),
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          final Animation<double> curved = CurvedAnimation(
            parent: animation,
            curve: AppMotion.enter,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curved),
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
    final List<RowData> rows = state.rows;
    final double topInset = MediaQuery.paddingOf(context).top;
    final double heroHeight = MediaQuery.sizeOf(context).height * 0.56;

    return Stack(
      children: <Widget>[
        ListView.builder(
          controller: _scroll,
          padding: EdgeInsets.only(top: heroHeight - 46, bottom: 108),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: rows.length,
          itemBuilder: (BuildContext context, int index) {
            final RowData row = rows[index];

            return StaggeredEntrance(
              index: index,
              base: const Duration(milliseconds: 40),
              child: TitleRow(
                row: row,
                onTapItem: (TitleItem item) => _openTitle(context, item),
              ),
            );
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: heroHeight,
          child: _HeroPanel(
            item: Catalog.kandethum,
            scrollOffset: _offset,
            onPlay: () => _openTitle(context, Catalog.kandethum,
                heroTag: 'hero-${Catalog.kandethum.id}'),
            onInfo: () => _openTitle(context, Catalog.kandethum,
                heroTag: 'hero-${Catalog.kandethum.id}'),
            onMyList: () {
              final bool added =
                  AppScope.read(context).toggleSaved(Catalog.kandethum.id);
              showToast(
                context,
                added ? 'Added to My List' : 'Removed from My List',
                icon: added ? Icons.check_rounded : Icons.remove_rounded,
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(topInset: topInset, scrollOffset: _offset),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.topInset, required this.scrollOffset});

  final double topInset;
  final double scrollOffset;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final double collapse = (scrollOffset / 220).clamp(0, 1);

    return AnimatedContainer(
      duration: AppMotion.fast,
      padding: EdgeInsets.only(
        top: topInset + 8,
        left: AppDimens.gutter,
        right: 8,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.black.withAlpha(((0.35 + 0.6 * collapse) * 255).round()),
            Colors.black.withAlpha(((0.12 + 0.5 * collapse) * 255).round()),
            Colors.transparent,
          ],
          stops: const <double>[0, 0.62, 1],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              AnimatedOpacity(
                opacity: 1 - collapse,
                duration: AppMotion.fast,
                child: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: NetflixMark(size: 21),
                ),
              ),
              Expanded(
                child: Text(
                  'For ${state.activeProfile.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.cardTitle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              PressableIcon(
                icon: Icons.cast_rounded,
                size: 21,
                onTap: () =>
                    showToast(context, 'No devices found on your network'),
              ),
              PressableIcon(
                icon: Icons.download_for_offline_outlined,
                size: 22,
                onTap: () => showToast(context, 'Downloads are empty'),
              ),
              PressableIcon(
                icon: Icons.search_rounded,
                size: 23,
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      transitionDuration: const Duration(milliseconds: 280),
                      pageBuilder: (_, __, ___) => const SearchScreen(),
                      transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 31,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 8),
              itemCount: Catalog.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (BuildContext context, int index) {
                final String label = Catalog.categories[index];

                return CategoryPill(
                  label: label,
                  selected: state.category == label,
                  onTap: () => state.setCategory(label),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.item,
    required this.scrollOffset,
    required this.onPlay,
    required this.onInfo,
    required this.onMyList,
  });

  final TitleItem item;
  final double scrollOffset;
  final VoidCallback onPlay;
  final VoidCallback onInfo;
  final VoidCallback onMyList;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final bool saved = state.isSaved(item.id);
    final double parallax = (scrollOffset * 0.32).clamp(0, 120);

    return Transform.translate(
      offset: Offset(0, -parallax),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: 'hero-${item.id}',
            child: Transform.scale(
              scale: 1 + parallax / 1400,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimens.radiusLg),
                  bottomRight: Radius.circular(AppDimens.radiusLg),
                ),
                child: _HeroArt(item: item),
              ),
            ),
          ),
          const Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppDimens.radiusLg),
                    bottomRight: Radius.circular(AppDimens.radiusLg),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0x73000000),
                      Color(0x00000000),
                      Color(0x99000000),
                      Color(0xFF000000),
                    ],
                    stops: <double>[0, 0.26, 0.78, 1],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.gutter,
                0,
                AppDimens.gutter,
                14,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FadeSlideIn(
                    duration: const Duration(milliseconds: 620),
                    delay: const Duration(milliseconds: 120),
                    child: Column(
                      children: <Widget>[
                        Text(
                          item.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: AppText.title.copyWith(
                            fontSize: MediaQuery.sizeOf(context).width < 380
                                ? 25
                                : 29,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.genres.join('  •  '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.meta.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFD8D8D8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: PlayButton(onTap: onPlay, expand: true),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SecondaryButton(
                          onTap: onMyList,
                          label: 'My List',
                          icon: saved ? Icons.check_rounded : Icons.add_rounded,
                          expand: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroArt extends StatelessWidget {
  const _HeroArt({required this.item});

  final TitleItem item;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      item.poster,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
    );
  }
}
