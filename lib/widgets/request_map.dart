import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui' as ui;

import 'homepage_button.dart';

class RequestMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool isHydrant;

  RequestMap({
    @required this.latitude,
    @required this.longitude,
    @required this.isHydrant,
  });

  @override
  _RequestMapState createState() => _RequestMapState();
}

class _RequestMapState extends State<RequestMap> {
  GoogleMapController _mapController;

  Uint8List markerIconHydrant, markerIconDepartment;

  BitmapDescriptor icon;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  Future<BitmapDescriptor> _buildMarkers() async {
    markerIconHydrant =
        await getBytesFromAsset('assets/images/marker_1.png', 130);
    markerIconDepartment =
        await getBytesFromAsset('assets/images/marker_2.png', 130);

    switch (widget.isHydrant) {
      case true:
        return BitmapDescriptor.fromBytes(markerIconHydrant);
        break;
      case false:
        return BitmapDescriptor.fromBytes(markerIconDepartment);
        break;
      default:
        return BitmapDescriptor.fromBytes(markerIconHydrant);
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))
        .buffer
        .asUint8List();
  }

  void _animateCameraOnMe() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(widget.latitude, widget.longitude),
        zoom: 18,
      ),
    ));
  }

  Stack googleMap() {
    _buildMarkers().then((value) {
      setState(() {
        icon = value;
      });
    });
    return Stack(
      children: <Widget>[
        GoogleMap(
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: true,
          markers: {
            Marker(
              markerId: MarkerId('Marker'),
              position: LatLng(
                widget.latitude,
                widget.longitude,
              ),
              icon: icon,
            )
          },
          mapType: MapType.satellite,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.latitude,
              widget.longitude,
            ),
            zoom: 18.0,
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
                    heroTag: 'GPS_REQUEST_MAP',
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return googleMap();
  }
}
