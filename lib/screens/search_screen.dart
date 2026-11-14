import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/catalog.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/motion.dart';
import '../widgets/toast.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  String _query = '';

  static const List<String> _suggestions = <String>[
    'Midnight Line',
    'Monsoon Letters',
    'Detective',
    'Crime',
    'Dark',
    'Sci-Fi',
    'Comedy',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  List<TitleItem> get _results {
    final String query = _query.trim().toLowerCase();

    if (query.isEmpty) {
      return <TitleItem>[];
    }

    return Catalog.all.where((TitleItem item) {
      return item.name.toLowerCase().contains(query) ||
          item.genres.any((String g) => g.toLowerCase().contains(query));
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final List<TitleItem> results = _results;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 12, 6),
              child: Row(
                children: <Widget>[
                  PressableIcon(
                    icon: Icons.arrow_back_rounded,
                    size: 23,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.search_rounded,
                            size: 19,
                            color:
                                Colors.white.withAlpha(((0.6) * 255).round()),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focus,
                              cursorColor: AppColors.red,
                              style: AppText.body.copyWith(
                                fontSize: 13.5,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Search shows, movies, genres',
                                hintStyle: AppText.body.copyWith(
                                  fontSize: 13.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              onChanged: (String value) {
                                setState(() => _query = value);
                              },
                            ),
                          ),
                          if (_query.isNotEmpty)
                            PressableIcon(
                              icon: Icons.close_rounded,
                              size: 17,
                              onTap: () {
                                _controller.clear();
                                setState(() => _query = '');
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _query.trim().isEmpty
                  ? _Suggestions(
                      suggestions: _suggestions,
                      onTap: (String value) {
                        _controller.text = value;
                        _controller.selection =
                            TextSelection.collapsed(offset: value.length);
                        setState(() => _query = value);
                      },
                    )
                  : results.isEmpty
                      ? _EmptyState(query: _query)
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimens.gutter,
                            12,
                            AppDimens.gutter,
                            100,
                          ),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            childAspectRatio: AppDimens.posterRatio / 1.34,
                          ),
                          itemCount: results.length,
                          itemBuilder: (BuildContext context, int index) {
                            final TitleItem item = results[index];

                            return StaggeredEntrance(
                              index: index,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: TapScale(
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                DetailsScreen(item: item),
                                          ),
                                        );
                                      },
                                      scale: 0.96,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppDimens.radiusSm),
                                        child: AppImage(
                                          asset: item.poster,
                                          alignment: Alignment.topCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.cardTitle
                                        .copyWith(fontSize: 11.5),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.suggestions, required this.onTap});

  final List<String> suggestions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppDimens.gutter, 10, AppDimens.gutter, 100),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Text(
          'Top searches',
          style: AppText.cardTitle
              .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < suggestions.length; i++)
          StaggeredEntrance(
            index: i,
            child: TapScale(
              onTap: () => onTap(suggestions[i]),
              behavior: HitTestBehavior.deferToChild,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search_rounded,
                      size: 16,
                      color: Colors.white.withAlpha(((0.5) * 255).round()),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        suggestions[i],
                        style: AppText.body.copyWith(
                          fontSize: 13.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.north_west_rounded,
                      size: 15,
                      color: Colors.white.withAlpha(((0.4) * 255).round()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 20),
        Text(
          'Browse by genre',
          style: AppText.cardTitle
              .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            for (final String genre in <String>[
              'Action',
              'Comedy',
              'Crime',
              'Drama',
              'Horror',
              'Romance',
              'Sci-Fi',
              'Thriller',
            ])
              TapScale(
                onTap: () {
                  onTap(genre);
                  showToast(context, 'Showing $genre titles');
                },
                scale: 0.94,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    genre,
                    style: AppText.label.copyWith(
                      fontSize: 11.5,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.search_off_rounded,
              size: 46,
              color: Colors.white.withAlpha(((0.3) * 255).round()),
            ),
            const SizedBox(height: 16),
            Text(
              'No results for "$query"',
              textAlign: TextAlign.center,
              style: AppText.cardTitle.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different title, genre or keyword.',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}
