import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../data/models.dart';
import '../widgets/app_image.dart';

class AppState extends ChangeNotifier {
  AppState();

  static const List<Profile> profiles = <Profile>[
    Profile(
      id: 'surabhi',
      name: 'SKKY',
      color: Color(0xFF3E5C76),
      avatar: AppImages.romance,
    ),
    Profile(
        id: 'kids', name: 'Children', color: Color(0xFFFFC857), isKids: true),
    Profile(id: 'guest', name: 'Add Profile', color: Color(0xFF262626)),
  ];

  int _profileIndex = 0;
  String _category = 'TV Shows';
  int _tabIndex = 0;

  final Set<String> _watchlist = <String>{'midnight-line'};
  final Map<String, double> _progress = <String, double>{};

  int get profileIndex => _profileIndex;
  Profile get activeProfile => profiles[_profileIndex];
  String get category => _category;
  int get tabIndex => _tabIndex;

  List<RowData> get rows => Catalog.rowsFor(_category);

  void selectProfile(int index) {
    if (index < 0 || index >= profiles.length || index == _profileIndex) {
      return;
    }

    _profileIndex = index;
    notifyListeners();
  }

  void setCategory(String value) {
    if (value == _category) {
      return;
    }

    _category = value;
    notifyListeners();
  }

  void setTab(int index) {
    if (index == _tabIndex) {
      return;
    }

    _tabIndex = index;
    notifyListeners();
  }

  bool isSaved(String id) => _watchlist.contains(id);

  bool toggleSaved(String id) {
    final bool added;

    if (_watchlist.contains(id)) {
      _watchlist.remove(id);
      added = false;
    } else {
      _watchlist.add(id);
      added = true;
    }

    notifyListeners();
    return added;
  }

  double progressFor(String id, double fallback) => _progress[id] ?? fallback;

  void setProgress(String id, double value) {
    _progress[id] = value.clamp(0.0, 1.0);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();

    assert(scope != null, 'AppScope was not found above this context');

    return scope!.notifier!;
  }

  static AppState read(BuildContext context) {
    final AppScope? scope = context.getInheritedWidgetOfExactType<AppScope>();

    assert(scope != null, 'AppScope was not found above this context');

    return scope!.notifier!;
  }
}

typedef AppScopeBuilder = Widget Function(BuildContext context, AppState state);
