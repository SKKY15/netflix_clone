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
import 'player_screen.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.item, this.heroTag});

  final TitleItem item;
  final String? heroTag;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ScrollController _scroll = ScrollController();

  double _offset = 0;

  @override
  void initState() {
    super.initState();

    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) {
      return;
    }

    final double value = _scroll.offset;

    if ((value - _offset).abs() < 0.5) {
      return;
    }

    setState(() => _offset = value);
  }

  void _play({int fromEpisode = 0}) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 460),
        pageBuilder: (_, __, ___) =>
            PlayerScreen(item: widget.item, startAt: fromEpisode),
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.08, end: 1).animate(
                CurvedAnimation(parent: animation, curve: AppMotion.enter),
              ),
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
    final TitleItem item = widget.item;
    final bool saved = state.isSaved(item.id);
    final List<TitleItem> similar = Catalog.all
        .where((TitleItem t) => t.id != item.id)
        .take(6)
        .toList(growable: false);

    final double mediaHeight = MediaQuery.sizeOf(context).width * 0.62;
    final double opacity = (1 - _offset / (mediaHeight * 0.75)).clamp(0, 1);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: <Widget>[
          ListView(
            controller: _scroll,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.zero,
            children: <Widget>[
              _DetailsHero(
                item: item,
                heroTag: widget.heroTag,
                height: mediaHeight,
                onPlay: () => _play(),
                onClose: () => Navigator.of(context).maybePop(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppDimens.gutter, 14, AppDimens.gutter, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _TitleLine(item: item),
                    const SizedBox(height: 10),
                    _MetaLine(item: item),
                    const SizedBox(height: 14),
                    PlayButton(
                        onTap: () => _play(),
                        label: 'Play',
                        expand: true,
                        height: 44),
                    const SizedBox(height: 9),
                    SecondaryButton(
                      onTap: () => showToast(
                        context,
                        'Download started • ${item.duration}',
                        icon: Icons.download_done_rounded,
                      ),
                      label: 'Download',
                      icon: Icons.download_rounded,
                      expand: true,
                      height: 44,
                    ),
                    const SizedBox(height: 16),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 60),
                      child: Text(
                        item.synopsis,
                        style:
                            AppText.body.copyWith(fontSize: 13, height: 1.45),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CreditLine(label: 'Cast', value: item.cast),
                    const SizedBox(height: 3),
                    _CreditLine(label: 'Creator', value: 'Darshil Kuriakose'),
                    const SizedBox(height: 18),
                    _ActionRail(
                      item: item,
                      saved: saved,
                      onToggle: () {
                        final bool added =
                            AppScope.read(context).toggleSaved(item.id);
                        showToast(
                          context,
                          added ? 'Added to My List' : 'Removed from My List',
                          icon: added
                              ? Icons.check_rounded
                              : Icons.remove_rounded,
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
              _EpisodeSection(
                  item: item, onPlay: (int index) => _play(fromEpisode: index)),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SectionHeader(title: 'More Like This'),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.gutter),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 12,
                        childAspectRatio: AppDimens.posterRatio / 1.34,
                      ),
                      itemCount: similar.length,
                      itemBuilder: (BuildContext context, int index) {
                        final TitleItem similarItem = similar[index];

                        return StaggeredEntrance(
                          index: index,
                          child: PosterCard(
                            item: similarItem,
                            width: double.infinity,
                            compact: true,
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder<void>(
                                  transitionDuration:
                                      const Duration(milliseconds: 320),
                                  pageBuilder: (_, __, ___) =>
                                      DetailsScreen(item: similarItem),
                                  transitionsBuilder: (_,
                                      Animation<double> animation,
                                      __,
                                      Widget child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.06, 0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.gutter),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const _InfoBlock(label: 'About'),
                          const SizedBox(height: 8),
                          _InfoRow(
                              label: 'Genres', value: item.genres.join(', ')),
                          _InfoRow(
                              label: 'This show is',
                              value: 'Suspenseful, Gritty, Dark'),
                          _InfoRow(
                              label: 'Maturity rating',
                              value:
                                  '${item.maturity} · Violence, Foul language'),
                          const SizedBox(height: 18),
                          const _InfoBlock(label: 'Languages'),
                          const SizedBox(height: 6),
                          Text(
                            'Audio: Hindi, Tamil, Telugu, Malayalam, English\nSubtitles: English, Hindi',
                            style: AppText.body.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: opacity > 0.35 ? 0 : 1,
              duration: AppMotion.fast,
              child: _CollapsedBar(item: item, height: mediaHeight * 0.18),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsedBar extends StatelessWidget {
  const _CollapsedBar({required this.item, required this.height});

  final TitleItem item;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.paddingOf(context).top;

    return Container(
      height: height + top,
      padding: EdgeInsets.only(top: top, left: AppDimens.gutter, right: 8),
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(((0.94) * 255).round()),
        border: const Border(bottom: BorderSide(color: Color(0x14FFFFFF))),
      ),
      child: Row(
        children: <Widget>[
          PressableIcon(
            icon: Icons.arrow_back_rounded,
            size: 22,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.cardTitle.copyWith(fontSize: 15),
            ),
          ),
          PressableIcon(
            icon: Icons.play_circle_fill_rounded,
            size: 24,
            onTap: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _DetailsHero extends StatelessWidget {
  const _DetailsHero({
    required this.item,
    required this.heroTag,
    required this.height,
    required this.onPlay,
    required this.onClose,
  });

  final TitleItem item;
  final String? heroTag;
  final double height;
  final VoidCallback onPlay;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.paddingOf(context).top;

    final Widget art = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        AppImage(asset: item.poster, alignment: Alignment.topCenter),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.black.withAlpha(((0.5) * 255).round()),
                Colors.transparent,
                Colors.black.withAlpha(((0.55) * 255).round()),
                AppColors.background,
              ],
              stops: const <double>[0, 0.28, 0.82, 1],
            ),
          ),
        ),
      ],
    );

    return SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: heroTag == null ? art : Hero(tag: heroTag!, child: art),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: height * 0.1,
            child: Center(
              child: _PreviewPlayer(item: item, onPlay: onPlay),
            ),
          ),
          Positioned(
            top: top + 8,
            left: AppDimens.gutter,
            right: 12,
            child: Row(
              children: <Widget>[
                const Spacer(),
                CircularIconButton(
                  icon: Icons.cast_rounded,
                  size: 34,
                  iconSize: 17,
                  onTap: () =>
                      showToast(context, 'No devices found on your network'),
                ),
                const SizedBox(width: 10),
                CircularIconButton(
                  icon: Icons.close_rounded,
                  size: 34,
                  iconSize: 18,
                  onTap: onClose,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewPlayer extends StatefulWidget {
  const _PreviewPlayer({required this.item, required this.onPlay});

  final TitleItem item;
  final VoidCallback onPlay;

  @override
  State<_PreviewPlayer> createState() => _PreviewPlayerState();
}

class _PreviewPlayerState extends State<_PreviewPlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
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
        final double wave = Curves.easeInOut.transform(_controller.value);

        return TapScale(
          onTap: widget.onPlay,
          scale: 0.9,
          child: SizedBox(
            width: 78,
            height: 78,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 58 + 26 * wave,
                  height: 58 + 26 * wave,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white
                          .withAlpha(((0.34 * (1 - wave)) * 255).round()),
                      width: 1.2,
                    ),
                  ),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withAlpha(((0.9) * 255).round()),
                        width: 1.6),
                    color: Colors.black.withAlpha(((0.16) * 255).round()),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TitleLine extends StatelessWidget {
  const _TitleLine({required this.item});

  final TitleItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.cardTitle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'N',
          style: AppText.logo.copyWith(
            fontSize: 26,
            color: AppColors.red,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'SERIES',
          style: AppText.badge.copyWith(
            fontSize: 9,
            letterSpacing: 2.2,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.item});

  final TitleItem item;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text('${item.year}', style: AppText.meta.copyWith(fontSize: 12)),
        TagBadge(label: item.maturity, color: const Color(0xFF3A3A3A)),
        Text(item.duration, style: AppText.meta.copyWith(fontSize: 12)),
        const TagBadge(label: 'HD', color: Color(0xFF3A3A3A)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const PulsingDot(size: 5, color: AppColors.green),
            const SizedBox(width: 5),
            Text(
              '${item.match}% match',
              style:
                  AppText.meta.copyWith(fontSize: 12, color: AppColors.green),
            ),
          ],
        ),
      ],
    );
  }
}

class _CreditLine extends StatelessWidget {
  const _CreditLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: AppText.body.copyWith(fontSize: 11.5),
        children: <TextSpan>[
          TextSpan(
            text: '$label: ',
            style: AppText.body.copyWith(
              fontSize: 11.5,
              color: AppColors.textMuted,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class _ActionRail extends StatelessWidget {
  const _ActionRail({
    required this.item,
    required this.saved,
    required this.onToggle,
  });

  final TitleItem item;
  final bool saved;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GhostTextButton(
          label: saved ? 'My List' : 'My List',
          icon: saved ? Icons.check_rounded : Icons.add_rounded,
          color: saved ? AppColors.red : AppColors.textPrimary,
          onTap: onToggle,
        ),
        GhostTextButton(
          label: 'Rate',
          icon: Icons.thumb_up_alt_outlined,
          color: AppColors.textPrimary,
          onTap: () => showToast(context, 'Thanks for rating ${item.name}'),
        ),
        GhostTextButton(
          label: 'Share',
          icon: Icons.send_outlined,
          color: AppColors.textPrimary,
          onTap: () => showToast(context, 'Share link copied'),
        ),
        GhostTextButton(
          label: 'Episodes',
          icon: Icons.video_library_outlined,
          color: AppColors.textPrimary,
          onTap: () =>
              showToast(context, '${item.episodes} episodes available'),
        ),
      ],
    );
  }
}

class _EpisodeSection extends StatelessWidget {
  const _EpisodeSection({required this.item, required this.onPlay});

  final TitleItem item;
  final ValueChanged<int> onPlay;

  @override
  Widget build(BuildContext context) {
    final List<_Episode> episodes = _episodeList(item);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(
          title: 'Episodes',
          trailing: Text(
            'Season ${item.seasons}',
            style: AppText.meta
                .copyWith(fontSize: 12, color: AppColors.textPrimary),
          ),
        ),
        Column(
          children: <Widget>[
            for (int i = 0; i < episodes.length; i++)
              StaggeredEntrance(
                index: i,
                child: _EpisodeTile(
                  episode: episodes[i],
                  poster: item.poster,
                  onTap: () => onPlay(i),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Episode {
  const _Episode({
    required this.number,
    required this.title,
    required this.duration,
    required this.description,
  });

  final int number;
  final String title;
  final String duration;
  final String description;
}

List<_Episode> _episodeList(TitleItem item) {
  final List<String> titles = <String>[
    'The Complaint',
    'Old Records',
    'A Town That Forgets',
    'The Second Statement',
    'Night Sweep',
    'What the Rain Washed',
    'The Last Assignment',
  ];

  final List<String> blurbs = <String>[
    'A suspension is lifted on one condition, and the paperwork disappears before sunrise.',
    'Two files share the same number, and only one of them was ever signed.',
    'Everyone in the market remembers the day, and nobody remembers the man.',
    'A witness changes his story for the third time, and the third time is the truth.',
    'The team runs a sweep of the old quarter with no warrant and no backup.',
    'Rain erases a trail that was never there in the first place.',
    'A final lead points somewhere nobody in the department wants to look.',
  ];

  final int count = item.episodes.clamp(3, 7);

  return <_Episode>[
    for (int i = 0; i < count; i++)
      _Episode(
        number: i + 1,
        title: titles[i % titles.length],
        duration: '${44 + (i * 3) % 12}m',
        description: blurbs[i % blurbs.length],
      ),
  ];
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({
    required this.episode,
    required this.poster,
    required this.onTap,
  });

  final _Episode episode;
  final String poster;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      scale: 0.98,
      duration: const Duration(milliseconds: 140),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.gutter, vertical: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          '${episode.number}. ${episode.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.cardTitle.copyWith(fontSize: 13.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        episode.duration,
                        style: AppText.meta.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    episode.description,
                    style: AppText.body.copyWith(fontSize: 11.5, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              child: SizedBox(
                width: 104,
                height: 60,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AppImage(asset: poster, alignment: Alignment.center),
                    Container(
                        color: Colors.black.withAlpha(((0.28) * 255).round())),
                    Center(
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white
                                  .withAlpha(((0.8) * 255).round())),
                          color: Colors.black.withAlpha(((0.3) * 255).round()),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
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

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style:
          AppText.cardTitle.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: AppText.body.copyWith(fontSize: 12),
          children: <TextSpan>[
            TextSpan(
              text: '$label: ',
              style: AppText.body
                  .copyWith(fontSize: 12, color: AppColors.textMuted),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
