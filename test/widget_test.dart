import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streamly/app/app_state.dart';
import 'package:streamly/data/catalog.dart';
import 'package:streamly/screens/app_shell.dart';
import 'package:streamly/screens/splash_screen.dart';
import 'package:streamly/theme/app_theme.dart';

void main() {
  testWidgets('splash reveals the wordmark then shows the profiles',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark, home: const SplashScreen()),
    );

    expect(find.text('NETFLIX'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3200));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text("Who's Watching?"), findsOneWidget);
    expect(find.text('Children'), findsOneWidget);
    expect(find.text('Add Profile'), findsOneWidget);
  });

  testWidgets('home shell renders the header and the first rows',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      AppScope(
        state: AppState(),
        child: MaterialApp(theme: AppTheme.dark, home: const AppShell()),
      ),
    );

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('For Surabhi Saini'), findsOneWidget);
    expect(find.text('Continue Watching for Surabhi'), findsOneWidget);
    expect(find.text('Your Next Watch'), findsOneWidget);
    expect(find.text('ANWESHIPPIN KANDETHUM'), findsOneWidget);
  });

  testWidgets('a title card opens the details screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      AppScope(
        state: AppState(),
        child: MaterialApp(theme: AppTheme.dark, home: const AppShell()),
      ),
    );

    await tester.pump(const Duration(milliseconds: 800));

    await tester.tap(find.text('Play').first);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Download'), findsOneWidget);
    expect(find.text('Anweshippin Kandethum'), findsWidgets);

    await tester.drag(find.byType(ListView).last, const Offset(0, -1400));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('More Like This'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  test('categories swap the rows', () {
    final AppState state = AppState();

    expect(state.category, 'TV Shows');
    expect(state.rows.first.title, 'Continue Watching for Surabhi');

    state.setCategory('Movies');
    expect(state.rows.first.title, 'Your Next Watch');
    expect(
      state.rows.any((dynamic row) => row.title == 'Blockbuster Movies'),
      isTrue,
    );

    state.setCategory('Categories');
    expect(state.rows.first.title, 'Drama');
  });

  test('watchlist toggles', () {
    final AppState state = AppState();

    expect(state.isSaved('kandethum'), isFalse);
    expect(state.toggleSaved('kandethum'), isTrue);
    expect(state.isSaved('kandethum'), isTrue);
    expect(state.toggleSaved('kandethum'), isFalse);
  });

  test('catalog is complete and points to bundled posters', () {
    expect(Catalog.all.length, 10);

    final Set<String> ids =
        Catalog.all.map((dynamic t) => t.id as String).toSet();
    expect(ids.length, Catalog.all.length);

    for (final dynamic title in Catalog.all) {
      expect(title.poster as String, startsWith('assets/posters/'));
      expect((title.poster as String).endsWith('.webp'), isTrue);
      expect((title.synopsis as String).length, greaterThan(40));
    }
  });
}
