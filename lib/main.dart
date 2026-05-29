import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import 'screens/coloring_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await YandexAds.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Раскрасим',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4FA3)),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ColoringScreen(),
    );
  }
}