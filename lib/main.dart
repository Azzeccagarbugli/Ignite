import 'package:flutter/material.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/views/login_screen.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';

void main() {
  runApp(Ignite());
}

class Ignite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => AppState(),
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<AppState>(context).getTheme(),
      home: LoginScreen(),
    );
  }
}
