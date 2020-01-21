import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  LoadingScreen({@required this.message});
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        backgroundColor: ThemeProvider.themeOf(context).id == "main"
            ? Colors.red[800]
            : Colors.grey[900],
        body: FlareActor(
          "assets/general/intro.flr",
          alignment: Alignment.center,
          animation: "Untitled",
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 500.0),
        child: Center(
          child: Chip(
            label: Text(
              message,
              style: TextStyle(fontSize: 15.0),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    ]);
  }
}
