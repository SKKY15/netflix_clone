import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app_state.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      isToolbarVisible: false,
      builder: (context) => const StreamlyApp(),
    ),
  );
}

class StreamlyApp extends StatefulWidget {
  const StreamlyApp({super.key});

  @override
  State<StreamlyApp> createState() => _StreamlyAppState();
}

class _StreamlyAppState extends State<StreamlyApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'Streamly',
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        theme: AppTheme.dark,
        scrollBehavior: const _AppScrollBehavior(),
        builder: (BuildContext context, Widget? child) {
          final Widget wrapped = Builder(
            builder: (BuildContext innerContext) {
              return MediaQuery(
                data: MediaQuery.of(innerContext).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.textScalerOf(innerContext).scale(12) / 12,
                  ),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
          return DevicePreview.appBuilder(context, wrapped);
        },
        home: const SplashScreen(),
      ),
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}