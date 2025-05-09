import 'package:finance/config/dependencies.dart';
import 'package:finance/firebase_options.dart';
import 'package:finance/ui/core/themes/theme.dart';
import 'package:finance/ui/core/themes/util.dart';
import 'package:finance/ui/core/ui/scroll_beheavior.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    // final brightness = Brightness.light;
    // final brightness = Brightness.dark;

    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'Financeiro',
      scrollBehavior: AppCustomScrollBehavior(),
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      // themeMode: ThemeMode.light,
      routerConfig: router(context.read()),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
