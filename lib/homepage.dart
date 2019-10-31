import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class Homepage extends StatefulWidget {
  Homepage({@required this.position});
  LatLng position;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Coppola puzza',
          style: TextStyle(
            fontFamily: 'Product Sans',
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        indoorViewEnabled: true,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target: widget.position,
          zoom: 11.0,
        ),
      ),
    );
  }
}
