import 'package:flutter/material.dart';
import 'package:ignite/models/app_state.dart';
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
          id: "dark",
          description: "Tema scuro",
          data: Provider.of<AppState>(context).darkTheme(),
          options: CustomOptions(
            filename: 'map_style_dark',
            brightness: Brightness.light,
          ),
        ),
        AppTheme(
          id: "main",
          description: "Tema principale",
          data: Provider.of<AppState>(context).mainTheme(),
          options: CustomOptions(
            filename: 'map_style_main',
            brightness: Brightness.dark,
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

class CustomOptions implements AppThemeOptions {
  final String filename;
  final Brightness brightness;
  CustomOptions({
    @required this.filename,
    @required this.brightness,
  });
}
