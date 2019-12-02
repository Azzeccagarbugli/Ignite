import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:ignite/views/citizen_screen_views/citizen_screen_map.dart';
import 'package:ignite/widgets/profile_settings_screen.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../main.dart';

class CitizenScreen extends StatefulWidget {
  String jsonStyle;
  LatLng position;
  CitizenScreen({
    @required this.position,
    @required this.jsonStyle,
  });

  @override
  _CitizenScreenState createState() => _CitizenScreenState();
}

class _CitizenScreenState extends State<CitizenScreen> {
  Widget _bodyWidget;

  @override
  void initState() {
    super.initState();
    this._bodyWidget = _mapBody();
  }

  Widget _profileSettingsBody() {
    return ProfileSettingsScreen();
  }

  Widget _mapBody() {
    return CitizenScreenMap(
        jsonStyle: widget.jsonStyle, position: widget.position);
  }

  void _setScaffoldBody(index) {
    switch (index) {
      case 2:
        setState(() {
          _bodyWidget = _profileSettingsBody();
        });
        break;
      case 0:
        setState(() {
          this._bodyWidget = _mapBody();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          ThemeProvider.optionsOf<CustomOptions>(context).brightness,
      systemNavigationBarColor:
          ThemeProvider.themeOf(context).data.bottomAppBarColor,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor:
          ThemeProvider.themeOf(context).data.bottomAppBarColor,
    ));

    return Scaffold(
      extendBody: true,
      body: _bodyWidget,
      bottomNavigationBar: CitizenCurvedNavigationBar(
        indexFun: (index) {
          _setScaffoldBody(index);
        },
      ),
    );
  }
}

class CitizenCurvedNavigationBar extends StatelessWidget {
  CitizenCurvedNavigationBar({@required this.indexFun});
  Function indexFun;
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      index: 1,
      color: ThemeProvider.themeOf(context).data.bottomAppBarColor,
      animationDuration: Duration(
        milliseconds: 500,
      ),
      buttonBackgroundColor:
          ThemeProvider.themeOf(context).data.bottomAppBarColor,
      items: <Icon>[
        Icon(
          Icons.terrain,
          size: 35,
          color: ThemeProvider.themeOf(context).data.buttonColor,
        ),
        Icon(
          Icons.add,
          size: 35,
          color: ThemeProvider.themeOf(context).data.buttonColor,
        ),
        Icon(
          Icons.person,
          size: 35,
          color: ThemeProvider.themeOf(context).data.buttonColor,
        ),
      ],
      onTap: indexFun,
    );
  }
}
