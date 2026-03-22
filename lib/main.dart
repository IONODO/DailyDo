import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:prod_app/body.dart';
import 'package:prod_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:prod_app/providers/task_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => TaskModel()),
      ChangeNotifierProvider(create: (_) => ThemeProvider())
    ],
    child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic,darkDynamic){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.green),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkDynamic ?? ColorScheme.fromSeed(seedColor: Colors.green,brightness: Brightness.dark,),
          ),
          themeMode: context.watch<ThemeProvider>().themeMode,
          home: const Body(),
        );
      },
    );
  }
}
