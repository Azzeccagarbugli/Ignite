import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class HomePageButton extends StatelessWidget {
  final IconData icon;
  final Function function;
  final String heroTag;

  HomePageButton({
    @required this.function,
    @required this.icon,
    @required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Container(
        child: FloatingActionButton(
          heroTag: this.heroTag,
          onPressed: function,
          elevation: 30,
          shape: new CircleBorder(),
          child: Icon(
            icon,
            color: ThemeProvider.themeOf(context).data.buttonColor,
          ),
          backgroundColor:
              ThemeProvider.themeOf(context).data.bottomAppBarColor,
        ),
      ),
    );
  }
}
