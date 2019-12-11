import "package:flutter/material.dart";
import 'package:theme_provider/theme_provider.dart';

class TopButtonRequest extends StatelessWidget {
  TopButtonRequest(
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
      child: Column(
        children: <Widget>[
          Container(
            transform: Matrix4.translationValues(0.0, 46.0, 0.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                  bottom: 4,
                  left: 8,
                  right: 8,
                ),
                child: Container(
                  child: Text(
                    "Ottieni le informazioni automaticamente",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -28.0, 0.0),
            child: RaisedButton.icon(
              elevation: 10,
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              label: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(
                    color: ThemeProvider.themeOf(context).data.primaryColor),
              ),
              onPressed: function,
            ),
          ),
        ],
      ),
    );
  }
}
