import "package:flutter/material.dart";
import 'package:theme_provider/theme_provider.dart';

class RoundedButtonOptions extends StatelessWidget {
  const RoundedButtonOptions(
      {Key key,
      @required this.context,
      @required this.text,
      @required this.function})
      : super(key: key);

  final BuildContext context;
  final String text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 300.0,
      height: 45.0,
      buttonColor: ThemeProvider.themeOf(context).data.primaryColor,
      child: RaisedButton(
          elevation: 15,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Nunito",
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(
                  color: ThemeProvider.themeOf(context).data.primaryColor)),
          onPressed: function),
    );
  }
}
