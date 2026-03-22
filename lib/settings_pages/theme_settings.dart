import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prod_app/providers/theme_provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme"),
      ),
      body: RadioGroup(
        groupValue: themeProvider.themeMode,
        onChanged: (value){
          context.read<ThemeProvider>().setTheme(value!);
        },
        child: Column(
          children: [
            RadioListTile(
              title: const Text("Light"),
              value: ThemeMode.light,
            ),
            RadioListTile(
              title: const Text("Dark"),
              value: ThemeMode.dark,
            ),
            RadioListTile(
              title: const Text("System"),
              value: ThemeMode.system,
            ),
          ],
        ),
      ),
    );
  }
}