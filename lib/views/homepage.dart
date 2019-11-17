import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/widgets/hydrant_card.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  LatLng position;
  Homepage({@required this.position});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  StreamSubscription<Position> _positionStream;
  GoogleMapController _mapController;
  Set<Marker> _markerSet = Set();
  double _zoomCameraOnMe = 18.0;
  Marker resultMarker;

  @override
  void initState() {
    super.initState();
    this.setupPositionStream();
  }

  void setupPositionStream() {
    _positionStream = Geolocator()
        .getPositionStream(
      LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 1000),
    )
        .listen((pos) {
      widget.position = LatLng(pos.latitude, pos.longitude);
    });
  }

  void _addMarker() {
    setState(() {
      _markerSet.add(resultMarker);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _mapController.setMapStyle(Provider.of<AppState>(context).getMapStyle());
      this._addMarker();
    });
  }

  void _animateCameraOnMe() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(widget.position.latitude, widget.position.longitude),
        zoom: _zoomCameraOnMe,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor:
          Provider.of<AppState>(context).getTheme().bottomAppBarColor,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor:
          Provider.of<AppState>(context).getTheme().bottomAppBarColor,
    ));

    resultMarker = Marker(
      markerId: MarkerId(
        "Primo idrante",
      ),
      position: LatLng(0, 0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HydrantCard()),
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapToolbarEnabled: false,
            indoorViewEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            markers: _markerSet,
            initialCameraPosition: CameraPosition(
              target: widget.position,
              zoom: _zoomCameraOnMe,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    MapButton(
                      function: _animateCameraOnMe,
                      icon: Icons.gps_fixed,
                    ),
                    /* MapButton(
                      icon: Icons.autorenew,
                      function: () {
                        Provider.of<AppState>(context).toggleTheme();
                        setState(() {
                          _mapController.setMapStyle(
                              Provider.of<AppState>(context).getMapStyle());
                        });
                      },
                    ),*/
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: 1,
        color: Provider.of<AppState>(context).getTheme().bottomAppBarColor,
        animationDuration: Duration(
          milliseconds: 500,
        ),
        buttonBackgroundColor:
            Provider.of<AppState>(context).getTheme().bottomAppBarColor,
        items: <Icon>[
          Icon(
            Icons.terrain,
            size: 35,
            color: Provider.of<AppState>(context).getTheme().buttonColor,
          ),
          Icon(
            Icons.add,
            size: 35,
            color: Provider.of<AppState>(context).getTheme().buttonColor,
          ),
          Icon(
            Icons.supervisor_account,
            size: 35,
            color: Provider.of<AppState>(context).getTheme().buttonColor,
          ),
        ],
        onTap: (index) {},
      ),
    );
  }
}

class MapButton extends StatelessWidget {
  MapButton({@required this.function, @required this.icon});
  IconData icon;
  Function function;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: FloatingActionButton.extended(
          onPressed: function,
          elevation: 30,
          shape: new CircleBorder(),
          backgroundColor:
              Provider.of<AppState>(context).getTheme().bottomAppBarColor,
          label: Icon(
            icon,
            color: Provider.of<AppState>(context).getTheme().buttonColor,
          ),
        ),
      ),
    );
  }
}
