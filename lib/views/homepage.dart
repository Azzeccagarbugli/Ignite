import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:ignite/components/hydrant_card.dart';

class Homepage extends StatefulWidget {
  Homepage({@required this.position});
  LatLng position;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  StreamSubscription<Position> _positionStream;
  GoogleMapController _mapController;
  String _mapStyle;
  Set<Marker> _markerSet = Set();
  double _zoomCameraOnMe = 18.0;
  Marker resultMarker;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/general/map_style.json').then((string) {
      _mapStyle = string;
    });
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
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
    this._addMarker();
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
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.white,
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
      extendBody: true,
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
        ],
      ),
      floatingActionButton: Container(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 150.0),
          child: FloatingActionButton.extended(
            onPressed: _animateCameraOnMe,
            elevation: 30,
            shape: new CircleBorder(),
            backgroundColor: Colors.red[800],
            label: Icon(Icons.gps_fixed),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: 1,
        animationDuration: Duration(milliseconds: 500),
        buttonBackgroundColor: Colors.white,
        items: <Icon>[
          Icon(
            Icons.terrain,
            size: 35,
            color: Colors.red[800],
          ),
          Icon(
            Icons.add,
            size: 35,
            color: Colors.red[800],
          ),
          Icon(
            Icons.supervisor_account,
            size: 35,
            color: Colors.red[800],
          ),
        ],
        onTap: (index) {},
      ),
    );
  }
}
