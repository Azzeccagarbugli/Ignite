import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ignite/widgets/homepage_button.dart';

class CitizenScreenMap extends StatefulWidget {
  String jsonStyle;
  LatLng position;
  CitizenScreenMap({
    @required this.position,
    @required this.jsonStyle,
  });
  @override
  _FiremanScreenMapState createState() => _FiremanScreenMapState();
}

class _FiremanScreenMapState extends State<CitizenScreenMap> {
  StreamSubscription<Position> _positionStream;
  GoogleMapController _mapController;
  Set<Marker> _markerSet = Set();
  double _zoomCameraOnMe = 18.0;
  Marker resultMarker;

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
      _mapController.setMapStyle(widget.jsonStyle);
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
  void initState() {
    super.initState();
    this.setupPositionStream();
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(
              top: 30.0,
              right: 15.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    HomePageButton(
                      function: _animateCameraOnMe,
                      icon: Icons.gps_fixed,
                      heroTag: 'GPS',
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
