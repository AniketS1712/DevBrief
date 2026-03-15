import 'package:devbrief/widgets/main_navigation_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DevBriefApp());
}

class DevBriefApp extends StatelessWidget {
  const DevBriefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevBrief',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const MainNavigationScreen(),
    );
  }
}

