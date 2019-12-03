import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  RequestMap({@required this.latitude, @required this.longitude});

  final Completer<GoogleMapController> _mapsController = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _mapsController.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 150.0,
      child: GoogleMap(
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
        markers: {
          Marker(
            markerId: MarkerId('Hydrant'),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarker,
          ),
        },
        mapType: MapType.satellite,
        onMapCreated: _onMapCreated,
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 18.0),
      ),
    );
  }
}
