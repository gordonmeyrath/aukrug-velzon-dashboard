import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_controller.dart';
import 'localization/app_localizations.dart';
import 'router/app_router.dart';

// ThemeMode Provider ausgelagert in core/theme/theme_mode_controller.dart

void main() {
  runApp(const ProviderScope(child: AukrugApp()));
}

class AukrugApp extends ConsumerWidget {
  const AukrugApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Aukrug',

      // Localization configuration
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de'), // German
        Locale('en'), // English
      ],

      // Theme configuration
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,

      // Router configuration
      routerConfig: router,

      // Debug settings
      debugShowCheckedModeBanner: false,
    );
  }
}
