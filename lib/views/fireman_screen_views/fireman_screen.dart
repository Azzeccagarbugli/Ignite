import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:ignite/views/fireman_screen_views/fireman_screen_requests.dart';
import 'package:ignite/widgets/profile_settings_screen.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'fireman_screen_map.dart';

class FiremanScreen extends StatefulWidget {
  String jsonStyle;
  LatLng position;
  FiremanScreen({
    @required this.position,
    @required this.jsonStyle,
  });
  @override
  _FiremanScreenState createState() => _FiremanScreenState();
}

class _FiremanScreenState extends State<FiremanScreen> {
  /* StreamSubscription<Position> _positionStream;
  GoogleMapController _mapController;
  Set<Marker> _markerSet = Set();
  double _zoomCameraOnMe = 18.0;
  Marker resultMarker;*/
  Widget _bodyWidget;
  final dbFireStore = Firestore.instance;

  @override
  void initState() {
    super.initState();
    this._bodyWidget = _mapBody();
  }

  Widget _mapBody() {
    return FiremanScreenMap(
      jsonStyle: widget.jsonStyle,
      position: widget.position,
    );
  }

  Widget _profileSettingsBody() {
    return ProfileSettingsScreen(jsonFaq: 'assets/general/faqFireman.json');
  }

  Widget _requestsBody() {
    return FiremanScreenRequests();
  }

  void _setScaffoldBody(index) {
    switch (index) {
      case 2:
        setState(() {
          _bodyWidget = _requestsBody();
        });
        break;
      case 3:
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
      bottomNavigationBar: new FiremanCurvedNavigationBar(
        indexFun: (index) {
          _setScaffoldBody(index);
        },
      ),
    );
  }
}

class FiremanCurvedNavigationBar extends StatelessWidget {
  FiremanCurvedNavigationBar({@required this.indexFun});
  Function indexFun;
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: 0,
      backgroundColor: Colors.transparent,
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
          Icons.check_circle,
          size: 35,
          color: ThemeProvider.themeOf(context).data.buttonColor,
        ),
        Icon(
          Icons.info,
          size: 35,
          color: ThemeProvider.themeOf(context).data.buttonColor,
        ),
      ],
      onTap: indexFun,
    );
  }
}
