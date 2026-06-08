import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/borne_list_screen.dart';
import 'screens/releve_detail_screen.dart';
import 'screens/releve_form_screen.dart';
import 'screens/apropos_screen.dart';

void main() => runApp(const AsuforApp());

// couleurs globales
const kTeal = Color(0xFF2BB5A0);
const kBackground = Color(0xFFF2F2F7);
const kCard = Colors.white;
const kLabel = Color(0xFF1C1C1E);
const kSublabel = Color(0xFF8E8E93);
const kOrange = Color(0xFFFF9F0A);
const kDanger = Color(0xFFFF453A);
const double kTarifM3 = 350.0;

class AsuforApp extends StatelessWidget {
  const AsuforApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASUFOR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kTeal),
        useMaterial3: true,
        scaffoldBackgroundColor: kBackground,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return CupertinoPageRoute(builder: (_) => const BorneListScreen(), settings: settings);
          case '/detail':
            return CupertinoPageRoute(builder: (_) => const RelevelDetailScreen(), settings: settings);
          case '/formulaire':
            return CupertinoPageRoute(builder: (_) => const ReleveFormScreen(), settings: settings);
          case '/apropos':
            return CupertinoPageRoute(builder: (_) => const AProposScreen(), settings: settings);
          default:
            return CupertinoPageRoute(builder: (_) => const BorneListScreen(), settings: settings);
        }
      },
    );
  }
}