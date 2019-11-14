import 'package:flutter/material.dart';
import 'package:ignite/views/first_screen.dart';
import 'package:ignite/views/loading_screen.dart';

void main() {
  runApp(Ignite());
}

class Ignite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstScreen(),
    );
  }
}
