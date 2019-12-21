import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsButton extends StatelessWidget {
  final String title;
  final String subtitlte;
  final Function onTap;
  final Icon icon;

  SettingsButton({
    @required this.title,
    @required this.subtitlte,
    @required this.onTap,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 3,
          ),
          child: Card(
            elevation: ThemeProvider.themeOf(context).id == "main" ? 12 : 5,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.white
                : Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: icon,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == "main"
                          ? Colors.grey[800]
                          : Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    subtitlte,
                    style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == "main"
                          ? Colors.grey[600]
                          : Colors.grey[200],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
