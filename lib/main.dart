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
  const App({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: [
        AppTheme(
          id: "main",
          description: "Tema principale",
          data: Provider.of<AppState>(context).mainTheme(),
        ),
        AppTheme(
          id: "dark",
          description: "Tema scuro",
          data: Provider.of<AppState>(context).darkTheme(),
        ),
      ],
      child: ThemeConsumer(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );
  }
}
