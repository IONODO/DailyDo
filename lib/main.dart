import 'package:flutter/material.dart';
import 'package:prod_app/body.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
    brightness: Brightness.light,
  ),
  darkTheme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber, brightness: Brightness.dark),
    brightness: Brightness.dark,
  ),
  themeMode: ThemeMode.light, // system / light / dark
  home: const Body(),
);

  }
}
