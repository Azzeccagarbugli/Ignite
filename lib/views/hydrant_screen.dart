import 'package:flutter/material.dart';
import 'package:ignite/models/hydrant.dart';

class HydrantScreen extends StatelessWidget {
  final Hydrant hydrant;
  HydrantScreen({@required this.hydrant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Idrante"),
      ),
      body: Center(
        child: Text(hydrant.getCity()),
      ),
    );
  }
}
