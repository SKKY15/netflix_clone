import '../widgets/app_image.dart';
import 'models.dart';

class Catalog {
  const Catalog._();

  static const String heroPoster = AppImages.hero;
  static const String neon = AppImages.neon;
  static const String action = AppImages.action;
  static const String horror = AppImages.horror;
  static const String romance = AppImages.romance;
  static const String drama = AppImages.drama;
  static const String teen = AppImages.teen;
  static const String scifi = AppImages.scifi;
  static const String thriller = AppImages.thriller;
  static const String comedy = AppImages.comedy;

  static const TitleItem kandethum = TitleItem(
    id: 'kandethum',
    name: 'Anweshippin Kandethum',
    poster: heroPoster,
    year: 2024,
    maturity: 'U/A 16+',
    episodes: 1,
    duration: '2h 24m',
    match: 97,
    genres: <String>['Underground', 'Dark', 'Drama', 'Detective'],
    synopsis:
        'A fiercely suspended officer, reeling from the injury of a young teammate, '
        'is handed one last chance: lead an unregistered investigation into a mystery '
        'that everyone in the department would rather keep buried. What begins as a '
        'routine case spirals into a tangle of old loyalties, payouts and a town that '
        'protects its own.',
    cast: 'Tovino Thomas, Siddharth Sivaraman, Gayathri, Vijay Babu',
    isSeries: false,
    badge: 'SERIES',
    seasons: 1,
  );

  static const TitleItem _midnightLine = TitleItem(
    id: 'midnight-line',
    name: 'Midnight Line',
    poster: neon,
    year: 2025,
    maturity: 'A 18+',
    episodes: 8,
    duration: '48m',
    match: 94,
    genres: <String>['Crime', 'Noir', 'Thriller'],
    synopsis:
        'In a city that never switches its neon off, a night-shift dispatcher starts '
        'receiving calls from numbers that were disconnected years ago.',
    cast: 'Rhea Kapoor, Aryan Mehta, Devika Rao',
  );

  static const TitleItem _paperSky = TitleItem(
    id: 'paper-sky',
    name: 'Paper Sky',
    poster: action,
    year: 2024,
    maturity: 'U/A 13+',
    episodes: 12,
    duration: '52m',
    match: 91,
    genres: <String>['Action', 'Adventure', 'War'],
    synopsis:
        'Two rescue pilots have ninety minutes, one working helicopter and a canyon '
        'full of fire between them and the last surviving crew.',
    cast: 'Kabir Anand, Neha Bhasin, Rahul Dev',
  );

  static const TitleItem _theWidow = TitleItem(
    id: 'the-widow',
    name: 'The Widow House',
    poster: horror,
    year: 2023,
    maturity: 'A 18+',
    episodes: 6,
    duration: '44m',
    match: 89,
    genres: <String>['Horror', 'Mystery', 'Supernatural'],
    synopsis:
        'A property surveyor is sent to value a house nobody has entered in forty '
        'years. The owners are still inside. All of them.',
    cast: 'Meera Nair, Suresh Menon',
  );

  static const TitleItem _monsoon = TitleItem(
    id: 'monsoon-letters',
    name: 'Monsoon Letters',
    poster: romance,
    year: 2025,
    maturity: 'U/A 13+',
    episodes: 10,
    duration: '41m',
    match: 96,
    genres: <String>['Romance', 'Drama', 'Feel Good'],
    synopsis:
        'Two strangers keep meeting on the same rooftop every year the rains return, '
        'and every year they are a little braver than the last.',
    cast: 'Ananya Iyer, Vikram Sethi',
  );

  static const TitleItem _docket = TitleItem(
    id: 'docket-9',
    name: 'Docket 9',
    poster: drama,
    year: 2024,
    maturity: 'U/A 16+',
    episodes: 9,
    duration: '50m',
    match: 93,
    genres: <String>['Legal', 'Drama', 'Political'],
    synopsis:
        'A junior clerk in an old courthouse finds a case file that was never filed, '
        'and the state has spent nine years making sure it stays that way.',
    cast: 'Aditya Rao, Fatima Sheikh',
  );

  static const TitleItem _halftime = TitleItem(
    id: 'halftime',
    name: 'Halftime',
    poster: teen,
    year: 2025,
    maturity: 'U/A 13+',
    episodes: 16,
    duration: '36m',
    match: 88,
    genres: <String>['Teen', 'Coming of Age', 'Comedy'],
    synopsis:
        'A losing school basketball team gets one new coach, one broken court and one '
        'summer to decide who they actually want to be.',
    cast: 'Ishaan Pillai, Tara Joshi, Nikhil Verma',
  );

  static const TitleItem _outerRim = TitleItem(
    id: 'outer-rim',
    name: 'Silent Orbit',
    poster: scifi,
    year: 2026,
    maturity: 'U/A 16+',
    episodes: 8,
    duration: '55m',
    match: 92,
    genres: <String>['Sci-Fi', 'Epic', 'Survival'],
    synopsis:
        'The last signal from the colony arrives eleven years late. A salvage crew '
        'sets out along the orbit it came from, and no one agrees on what to expect.',
    cast: 'Zoya Ahmed, Peter Dsouza',
  );

  static const TitleItem _rainCheck = TitleItem(
    id: 'rain-check',
    name: 'Rain Check',
    poster: thriller,
    year: 2024,
    maturity: 'U/A 16+',
    episodes: 7,
    duration: '46m',
    match: 90,
    genres: <String>['Crime', 'Thriller', 'Detective'],
    synopsis:
        'A detective on the night beat keeps finding the same car at the same corner, '
        'and the driver keeps swearing he has never been there before.',
    cast: 'Arjun Kamath, Sneha Reddy',
  );

  static const TitleItem _sunnySide = TitleItem(
    id: 'sunny-side',
    name: 'Sunny Side Up',
    poster: comedy,
    year: 2025,
    maturity: 'U/A 7+',
    episodes: 20,
    duration: '28m',
    match: 98,
    genres: <String>['Comedy', 'Feel Good', 'Friends'],
    synopsis:
        'Three flatmates open a cafe that fails a little more every week, and somehow '
        'becomes the most loved table in the neighbourhood.',
    cast: 'Rohit Sen, Anjali Das, Kabir Shah',
  );

  static final List<TitleItem> all = <TitleItem>[
    kandethum,
    _midnightLine,
    _paperSky,
    _theWidow,
    _monsoon,
    _docket,
    _halftime,
    _outerRim,
    _rainCheck,
    _sunnySide,
  ];

  static TitleItem byId(String id) =>
      all.firstWhere((TitleItem t) => t.id == id, orElse: () => kandethum);

  static final List<RowData> homeRows = <RowData>[
    RowData(
      title: 'Continue Watching for SKKY',
      showProgress: true,
      wide: true,
      items: <TitleItem>[
        _copy(kandethum, progress: 0.42, badge: 'S1:E4'),
        _copy(_midnightLine, progress: 0.78, badge: 'S1:E2'),
        _copy(_paperSky, progress: 0.15, badge: 'NEW SEASON'),
        _copy(_theWidow, progress: 0.63, badge: 'S2:E1'),
      ],
    ),
    RowData(
      title: 'Your Next Watch',
      items: <TitleItem>[_paperSky, _monsoon, _docket, _halftime, _rainCheck],
    ),
    RowData(
      title: 'International TV Shows Dubbed in Hindi',
      items: <TitleItem>[_theWidow, _outerRim, _sunnySide, _docket, _paperSky],
    ),
    RowData(
      title: 'Relentless Crime Dramas',
      items: <TitleItem>[
        _rainCheck,
        _docket,
        _midnightLine,
        _theWidow,
        kandethum
      ],
    ),
    RowData(
      title: 'Because You Watched Dark',
      items: <TitleItem>[
        _theWidow,
        _outerRim,
        _midnightLine,
        _rainCheck,
        _henna()
      ],
    ),
    RowData(
      title: 'Top 10 in India Today',
      items: <TitleItem>[kandethum, _sunnySide, _monsoon, _paperSky, _halftime],
    ),
  ];

  static List<RowData> rowsFor(String? category) {
    if (category == null || category == 'TV Shows') {
      return homeRows;
    }
    if (category == 'Movies') {
      return <RowData>[
        homeRows[1],
        homeRows[3],
        RowData(
          title: 'Blockbuster Movies',
          items: <TitleItem>[
            _paperSky,
            _outerRim,
            _theWidow,
            _rainCheck,
            _henna()
          ],
        ),
        homeRows[4],
      ];
    }
    if (category == 'Categories') {
      return <RowData>[
        RowData(
          title: 'Drama',
          items: <TitleItem>[
            _docket,
            _monsoon,
            kandethum,
            _theWidow,
            _paperSky
          ],
        ),
        RowData(
          title: 'Suspense & Thriller',
          items: <TitleItem>[
            _midnightLine,
            _rainCheck,
            _theWidow,
            _docket,
            _outerRim
          ],
        ),
        RowData(
          title: 'Comedy',
          items: <TitleItem>[
            _sunnySide,
            _halftime,
            _monsoon,
            _paperSky,
            _docket
          ],
        ),
        RowData(
          title: 'Sci-Fi & Fantasy',
          items: <TitleItem>[
            _outerRim,
            _midnightLine,
            _paperSky,
            _theWidow,
            _halftime
          ],
        ),
      ];
    }
    return homeRows;
  }

  static TitleItem _henna() => TitleItem(
        id: 'henna-nights',
        name: 'Henna Nights',
        poster: romance,
        year: 2023,
        maturity: 'U/A 13+',
        episodes: 8,
        duration: '39m',
        match: 87,
        genres: <String>['Romance', 'Musical'],
        synopsis:
            'A wedding planner and a stubborn chef keep ending up at the same '
            'celebrations, in the same colours, at the same wrong moment.',
        cast: 'Naina Kapoor, Arif Khan',
      );

  static TitleItem _copy(TitleItem t, {double progress = 0, String? badge}) =>
      TitleItem(
        id: t.id,
        name: t.name,
        poster: t.poster,
        year: t.year,
        maturity: t.maturity,
        episodes: t.episodes,
        duration: t.duration,
        match: t.match,
        genres: t.genres,
        synopsis: t.synopsis,
        cast: t.cast,
        isSeries: t.isSeries,
        progress: progress,
        badge: badge ?? t.badge,
        seasons: t.seasons,
      );

  static const List<String> categories = <String>[
    'TV Shows',
    'Movies',
    'Categories',
  ];
}
