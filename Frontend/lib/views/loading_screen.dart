import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  final String pathFlare;
  final String nameAnimation;
  LoadingScreen({
    @required this.message,
    @required this.pathFlare,
    @required this.nameAnimation,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).id == "main"
          ? Colors.white
          : Colors.grey[900],
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: ThemeProvider.themeOf(context).id == "main"
            ? SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.red[600],
              )
            : SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: Colors.black,
              ),
        child: Stack(
          children: <Widget>[
            FlareActor(
              "assets/general/intro.flr",
              alignment: Alignment.center,
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.red[600]
                  : Colors.orangeAccent,
              animation: "Untitled",
            ),
            Positioned(
              left: 16,
              top: 42,
              right: 16,
              child: Chip(
                elevation: 6,
                avatar: CircleAvatar(
                  backgroundColor:
                      ThemeProvider.themeOf(context).data.primaryColor,
                  child: Transform.scale(
                    scale: 0.7,
                    child: FlareActor(
                      this.pathFlare,
                      animation: nameAnimation,
                      color: Colors.white,
                    ),
                  ),
                ),
                label: Text(
                  message,
                  style: TextStyle(fontSize: 15.0),
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
