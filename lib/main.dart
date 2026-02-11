import 'package:flutter/material.dart';
import 'package:prod_app/body.dart';
import 'package:provider/provider.dart';
import 'package:prod_app/task_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => TaskModel())
    ],
    child: const MainApp(),
    ),
  );
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
