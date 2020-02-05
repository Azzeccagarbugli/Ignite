import "package:flutter/material.dart";
import 'package:theme_provider/theme_provider.dart';

class TopButtonRequest extends StatelessWidget {
  TopButtonRequest({
    Key key,
    @required this.context,
    @required this.title,
    @required this.subtitle,
    @required this.function,
    @required this.icon,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final String subtitle;
  final Icon icon;
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
                    subtitle,
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
              icon: icon,
              label: Text(
                title,
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
