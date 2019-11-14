import 'package:flutter/material.dart';
import 'package:ignite/views/first_screen.dart';

void main() {
  runApp(Ignite());
}

class Ignite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Product Sans',
        primaryColor: Colors.red[600],
        accentColor: Colors.white,
      ),
      home: FirstScreen(),
    );
  }
}
