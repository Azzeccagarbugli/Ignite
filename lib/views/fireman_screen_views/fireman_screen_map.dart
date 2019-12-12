import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/views/department_screen.dart';
import 'package:ignite/views/hydrant_screen.dart';
import 'package:ignite/widgets/homepage_button.dart';
import 'package:provider/provider.dart';
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
  Set<Marker> _markerSet;
  double _zoomCameraOnMe = 18.0;

  void setupPositionStream() {
    _positionStream = Geolocator()
        .getPositionStream(
      LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 1000),
    )
        .listen((pos) {
      widget.position = LatLng(pos.latitude, pos.longitude);
    });
  }

  void _buildHydrantMarkers(List<Hydrant> hydrants) async {
    /* List<Hydrant> hydrants =
        await Provider.of<DbProvider>(context).getApprovedHydrants();*/
    for (Hydrant h in hydrants) {
      _markerSet.add(
        new Marker(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HydrantScreen(
                hydrant: h,
              );
            }));
          },
          markerId: MarkerId(h.getDBReference()),
          position: LatLng(h.getLat(), h.getLong()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        ),
      );
    }
  }

  void _buildDepartmentsMarkers(List<Department> deps) async {
    /* List<Department> deps =
        await Provider.of<DbProvider>(context).getDepartments();*/
    for (Department d in deps) {
      _markerSet.add(
        new Marker(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DepartmentScreen(
                department: d,
              );
            }));
          },
          markerId: MarkerId(d.getDBReference()),
          position: LatLng(d.getLat(), d.getLong()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  GoogleMap _buildGoogleMap(List<Department> deps, List<Hydrant> hydrants) {
    /*this._buildDepartmentsMarkers(deps);
    this._buildHydrantMarkers(hydrants);*/
    return GoogleMap(
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
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _mapController.setMapStyle(widget.jsonStyle);
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
    _markerSet = Set<Marker>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder<List<Hydrant>>(
            future: Provider.of<DbProvider>(context).getApprovedHydrants(),
            builder: (context, hydrants) {
              switch (hydrants.connectionState) {
                case ConnectionState.none:
                  return new RequestCircularLoading();
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return new RequestCircularLoading();
                case ConnectionState.done:
                  if (hydrants.hasError) return new RequestCircularLoading();
                  return FutureBuilder<List<Department>>(
                    future: Provider.of<DbProvider>(context).getDepartments(),
                    builder: (context, departments) {
                      switch (departments.connectionState) {
                        case ConnectionState.none:
                          return new RequestCircularLoading();
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return new RequestCircularLoading();
                        case ConnectionState.done:
                          if (departments.hasError)
                            return new RequestCircularLoading();
                          return _buildGoogleMap(
                              departments.data, hydrants.data);
                      }
                    },
                  );
              }
            },
          ),
          /* GoogleMap(
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
          ),*/
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
                      icon: FontAwesomeIcons.tint,
                      function: () {
                        print("sas");
                      },
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

class RequestCircularLoading extends StatelessWidget {
  const RequestCircularLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(
        ThemeProvider.themeOf(context).data.primaryColor,
      ),
    ));
  }
}
