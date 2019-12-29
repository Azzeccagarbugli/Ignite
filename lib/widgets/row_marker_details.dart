import "package:flutter/material.dart";
import 'package:theme_provider/theme_provider.dart';

class RowMarkerDetails extends StatelessWidget {
  final String value;
  final String tag;

  RowMarkerDetails({
    @required this.value,
    @required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Chip(
          backgroundColor: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red
              : Colors.grey[800],
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.red
                  : Colors.grey[800],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6.0),
              bottomLeft: Radius.circular(6.0),
            ),
          ),
          label: Text(
            this.tag,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
            ),
          ),
        ),
        Chip(
          backgroundColor: ThemeProvider.themeOf(context).id == "main"
              ? Colors.transparent
              : Colors.grey[600],
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.red
                  : Colors.grey[600],
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(6.0),
              bottomRight: Radius.circular(6.0),
            ),
          ),
          label: Text(
            this.value,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

