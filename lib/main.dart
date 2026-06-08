import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/borne_list_screen.dart';
import 'screens/releve_detail_screen.dart';
import 'screens/releve_form_screen.dart';
import 'screens/apropos_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  runApp(const AsuforApp());
}

class AsuforApp extends StatelessWidget {
  const AsuforApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASUFOR',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const BorneListScreen(),
      onGenerateRoute: _generateRoute,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.systemGrouped,
      fontFamily: 'SF Pro Display',
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(
          builder: (_) => const BorneListScreen(),
          settings: settings,
        );
      case '/detail':
        return CupertinoPageRoute(
          builder: (_) => const ReleveDetailScreen(),
          settings: settings,
        );
      case '/formulaire':
        return CupertinoPageRoute(
          builder: (_) => const ReleveFormScreen(),
          settings: settings,
        );
      case '/apropos':
        return CupertinoPageRoute(
          builder: (_) => const AProposScreen(),
          settings: settings,
        );
      default:
        return CupertinoPageRoute(
          builder: (_) => const BorneListScreen(),
          settings: settings,
        );
    }
  }
}
