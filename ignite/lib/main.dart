import 'package:flutter/material.dart';
import 'homepage.dart';
import 'loadingscreen.dart';

void main() => runApp(Ignite());

class Ignite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingScreen(),
    );
  }
}
