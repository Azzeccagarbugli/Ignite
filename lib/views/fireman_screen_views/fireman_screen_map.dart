import 'dart:async';
import 'dart:typed_data';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ignite/helper/map_launcher.dart';
import 'package:ignite/models/department.dart';

import 'package:ignite/models/hydrant.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/views/department_screen.dart';
import 'package:ignite/views/fireman_screen_views/request_approval_screen.dart';
import 'package:ignite/widgets/button_decline_approve.dart';

import 'package:ignite/widgets/homepage_button.dart';
import 'package:provider/provider.dart';

import 'dart:ui' as ui;

import 'package:theme_provider/theme_provider.dart';

class FiremanScreenMap extends StatefulWidget {
  String jsonStyle;
  LatLng position;
  FiremanScreenMap({
    @required this.position,
    @required this.jsonStyle,
  });
  @override
  _FiremanScreenMapState createState() => _FiremanScreenMapState();
}

class _FiremanScreenMapState extends State<FiremanScreenMap> {
  StreamSubscription<Position> _positionStream;

  GoogleMapController _mapController;

  List<Marker> _markerSet;
  List<Hydrant> _approvedHydrants;

  double _zoomCameraOnMe = 18.0;

  void setupPositionStream() {
    _positionStream = Geolocator()
        .getPositionStream(
      LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 500),
    )
        .listen((pos) {
      widget.position = LatLng(pos.latitude, pos.longitude);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void _buildHydrantMarkers() async {
    final Uint8List markerIconHydrant =
        await getBytesFromAsset('assets/images/marker_1.png', 130);
    await Provider.of<DbProvider>(context).getApprovedHydrants().then((value) {
      _approvedHydrants = value;
    });
    for (Hydrant h in _approvedHydrants) {
      _markerSet.add(
        new Marker(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RequestScreenRecap(
                hydrant: h,
                buttonBar: Container(
                  color: Colors.red[600],
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton.icon(
                    onPressed: () {
                      MapUtils.openMap(
                        h.getLat(),
                        h.getLong(),
                      );
                    },
                    icon: Icon(
                      Icons.navigation,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Ottieni indicazioni",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                isHydrant: true,
              );
            }));
          },
          markerId: MarkerId(h.getDBReference()),
          position: LatLng(
            h.getLat(),
            h.getLong(),
          ),
          icon: BitmapDescriptor.fromBytes(markerIconHydrant),
        ),
      );
    }
  }

  void _buildDepartmentsMarkers() async {
    final Uint8List markerIconDepartment =
        await getBytesFromAsset('assets/images/marker_2.png', 130);
    await Provider.of<DbProvider>(context).getDepartments().then((value) {
      for (Department d in value) {
        _markerSet.add(
          new Marker(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DepartmentScreen(
                  department: d,
                  buttonBar: Container(
                    color: Colors.red[600],
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton.icon(
                      onPressed: () {
                        MapUtils.openMap(
                          d.getLat(),
                          d.getLong(),
                        );
                      },
                      icon: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Ottieni indicazioni",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }));
            },
            markerId: MarkerId(d.getDBReference()),
            position: LatLng(
              d.getLat(),
              d.getLong(),
            ),
            icon: BitmapDescriptor.fromBytes(markerIconDepartment),
          ),
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _mapController.setMapStyle(widget.jsonStyle);
    });
  }

  GoogleMap _buildGoogleMap() {
    this._buildDepartmentsMarkers();
    this._buildHydrantMarkers();
    return GoogleMap(
      mapToolbarEnabled: false,
      indoorViewEnabled: true,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: _onMapCreated,
      markers: _markerSet.toSet(),
      initialCameraPosition: CameraPosition(
        target: widget.position,
        zoom: _zoomCameraOnMe,
      ),
    );
  }

  void _animateCameraOnMe() {
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: ThemeProvider.themeOf(context).data.bottomAppBarColor,
      icon: Icon(
        Icons.gps_fixed,
        color: Colors.white,
      ),
      title: "Posizione attuale",
      message: "Verrà visualizzata la posizione attuale",
      duration: Duration(
        seconds: 2,
      ),
    )..show(context);
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(widget.position.latitude, widget.position.longitude),
        zoom: _zoomCameraOnMe,
      ),
    ));
  }

  void _animateCameraOnNearestHydrant() async {
    double minDistance = double.maxFinite;
    double targetLat = widget.position.latitude;
    double targetLong = widget.position.longitude;
    Hydrant targetHydrant = null;
    for (Hydrant h in _approvedHydrants) {
      double distance = await Geolocator().distanceBetween(
          widget.position.latitude,
          widget.position.longitude,
          h.getLat(),
          h.getLong());

      if (distance < minDistance) {
        minDistance = distance;
        targetLat = h.getLat();
        targetLong = h.getLong();
        targetHydrant = h;
      }
    }
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(targetLat, targetLong),
        zoom: _zoomCameraOnMe,
      ),
    ));
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: ThemeProvider.themeOf(context).data.bottomAppBarColor,
      icon: Icon(
        Icons.explore,
        color: Colors.white,
      ),
      title: "L'idrante più vicino",
      message: "Verrà visualizzato l'idrante più vicino alla posizione attuale",
      duration: Duration(
        seconds: 2,
      ),
    )..show(context);
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RequestScreenRecap(
        hydrant: targetHydrant,
        buttonBar: Container(
          color: Colors.red[600],
          width: MediaQuery.of(context).size.width,
          child: FlatButton.icon(
            onPressed: () {
              MapUtils.openMap(
                targetHydrant.getLat(),
                targetHydrant.getLong(),
              );
            },
            icon: Icon(
              Icons.navigation,
              color: Colors.white,
            ),
            label: Text(
              "Ottieni indicazioni",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        isHydrant: true,
      );
    }));
  }

  @override
  void initState() {
    super.initState();
    this.setupPositionStream();
    _markerSet = List<Marker>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder<List<Hydrant>>(
            future: Provider.of<DbProvider>(context).getApprovedHydrants(),
            builder: (context, hydrants) {
              return _buildGoogleMap();
            },
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
                    HomePageButton(
                      heroTag: 'NEARESTHYDRANT',
                      icon: Icons.explore,
                      function: _animateCameraOnNearestHydrant,
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
