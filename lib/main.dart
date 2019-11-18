import 'package:flutter/material.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/views/homepage.dart';
import 'package:ignite/views/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'models/app_state.dart';

void main() {
  runApp(Ignite());
}

class Ignite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => AppState(),
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
          id: "main",
          description: "Tema principale",
          data: Provider.of<AppState>(context).mainTheme(),
          options: CustomMapStyle(
            filename: 'map_style_main',
          ),
        ),
        AppTheme(
          id: "dark",
          description: "Tema scuro",
          data: Provider.of<AppState>(context).darkTheme(),
          options: CustomMapStyle(
            filename: 'map_style_dark',
          ),
        ),
      ],
      child: ThemeConsumer(
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Nunito',
          ),
          home: LoginScreen(),
        ),
      ),
    );
  }
}

class CustomMapStyle implements AppThemeOptions {
  final String filename;
  CustomMapStyle({
    @required this.filename,
  });
}
