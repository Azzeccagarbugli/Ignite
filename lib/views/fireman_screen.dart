import 'package:flutter/material.dart';

class FiremanScreen extends StatefulWidget {
  @override
  _FiremanScreenState createState() => _FiremanScreenState();
}

class _FiremanScreenState extends State<FiremanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Porco porco'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
