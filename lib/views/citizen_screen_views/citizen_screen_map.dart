import 'dart:async';
import 'dart:typed_data';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ignite/helper/map_launcher.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/views/department_screen.dart';
import 'package:ignite/views/fireman_screen_views/request_approval_screen.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:ignite/widgets/homepage_button.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'dart:ui' as ui;

import '../../main.dart';

const double kStartupLat = 41.9038243;
const double kStartupLong = 12.4476838;

class CitizenScreenMap extends StatefulWidget {
  @override
  _CitizenScreenMapState createState() => _CitizenScreenMapState();
}

class _CitizenScreenMapState extends State<CitizenScreenMap> {
  StreamSubscription<Position> _positionStream;
  GoogleMapController _mapController;
  LatLng _curloc;
  String _mapStyle;
  List<Marker> _markerSet;
  List<Hydrant> _approvedHydrants;
  List<Department> _departments;
  bool _isSatellite;

  void setupPositionStream() {
    _positionStream = Geolocator()
        .getPositionStream(
      LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 500),
    )
        .listen((pos) {
      _curloc = LatLng(pos.latitude, pos.longitude);
    });
  }

  Future<void> getApprovedHydrants() async {
    _approvedHydrants = await DbProvider().getApprovedHydrants();
  }

  Future<void> getDepartments() async {
    _departments = await DbProvider().getDepartments();
  }

  Future<void> firstFutureInit() async {
    await Future.wait([
      this.getApprovedHydrants(),
      this.getDepartments(),
    ]);
    await Future.wait([
      this._buildHydrantMarkers(),
      this._buildDepartmentsMarkers(),
      this._loadJson(),
    ]);
  }

  Future<void> secondFutureInit() async {
    await Future.wait([
      this._getPosition(),
    ]);
    this.setupPositionStream();
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

  Future<void> _getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _curloc = LatLng(position.latitude, position.longitude);
  }

  Future<void> _loadJson() async {
    await rootBundle
        .loadString(
            'assets/general/${ThemeProvider.optionsOf<CustomOptions>(context).filename}.json')
        .then((string) {
      _mapStyle = string;
    });
  }

  Future<void> _buildHydrantMarkers() async {
    final Uint8List markerIconHydrant =
        await getBytesFromAsset('assets/images/marker_1.png', 130);
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
                        _curloc.latitude,
                        _curloc.longitude,
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
          markerId: MarkerId(h.getId()),
          position: LatLng(
            h.getLat(),
            h.getLong(),
          ),
          icon: BitmapDescriptor.fromBytes(markerIconHydrant),
        ),
      );
    }
  }

  Future<void> _buildDepartmentsMarkers() async {
    final Uint8List markerIconDepartment =
        await getBytesFromAsset('assets/images/marker_2.png', 130);
    for (Department d in _departments) {
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
                        _curloc.latitude,
                        _curloc.longitude,
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
          markerId: MarkerId(d.getId()),
          position: LatLng(
            d.getLat(),
            d.getLong(),
          ),
          icon: BitmapDescriptor.fromBytes(markerIconDepartment),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }

  GoogleMap _buildLoadingGoogleMap() {
    return GoogleMap(
      mapToolbarEnabled: false,
      indoorViewEnabled: true,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: _onMapCreated,
      mapType: _isSatellite ? MapType.satellite : MapType.normal,
      markers: _markerSet.toSet(),
      initialCameraPosition: CameraPosition(
        target: LatLng(kStartupLat, kStartupLong),
        zoom: 5.0,
      ),
    );
  }

  GoogleMap _buildLoadedGoogleMap() {
    this._animateCameraOnMe(true);
    return GoogleMap(
      mapToolbarEnabled: false,
      indoorViewEnabled: true,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: _isSatellite ? MapType.satellite : MapType.normal,
      onMapCreated: _onMapCreated,
      markers: _markerSet.toSet(),
      initialCameraPosition: CameraPosition(
        target: _curloc,
        zoom: 16.0,
      ),
    );
  }

  Widget _buildLoadingMap() {
    return Stack(
      children: <Widget>[
        this._buildLoadingGoogleMap(),
        Positioned(
          left: 16,
          top: 42,
          right: 16,
          child: Chip(
            elevation: 4,
            avatar: CircleAvatar(
              backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
              child: Transform.scale(
                scale: 0.7,
                child: FlareActor(
                  "assets/general/gps_rotation.flr",
                  animation: "rotate",
                ),
              ),
            ),
            label: Text(
              "Ricerca GPS in corso",
              style: TextStyle(fontSize: 15.0),
            ),
            backgroundColor: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            left: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  HomePageButton(
                    function: _setSatellite,
                    icon: Icons.filter_hdr,
                    heroTag: 'SATELLITE',
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildLoadedMap() {
    return Stack(
      children: <Widget>[
        this._buildLoadedGoogleMap(),
        Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            right: 15.0,
            left: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  HomePageButton(
                    function: _setSatellite,
                    icon: Icons.filter_hdr,
                    heroTag: 'SATELLITE',
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  HomePageButton(
                    function: () {
                      _animateCameraOnMe(false);
                    },
                    icon: Icons.gps_fixed,
                    heroTag: 'GPS',
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void _setSatellite() {
    setState(() {
      _isSatellite = !_isSatellite;
    });
  }

  void _animateCameraOnMe(bool isFirstLoad) {
    if (!isFirstLoad) {
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
    }
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(_curloc.latitude, _curloc.longitude),
        zoom: 16.0,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    _markerSet = List<Marker>();
    _curloc = LatLng(kStartupLat, kStartupLong);
    _isSatellite = false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firstFutureInit(),
      builder: (context, data) {
        switch (data.connectionState) {
          case ConnectionState.none:
            return new LoadingScreen(
              message: "Caricamento della mappa in corso",
              pathFlare: "assets/general/maps.flr",
              nameAnimation: "anim",
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return new LoadingScreen(
              message: "Caricamento della mappa in corso",
              pathFlare: "assets/general/maps.flr",
              nameAnimation: "anim",
            );
          case ConnectionState.done:
            return FutureBuilder(
              future: secondFutureInit(),
              builder: (context, data) {
                switch (data.connectionState) {
                  case ConnectionState.none:
                    return _buildLoadingMap();
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return _buildLoadingMap();
                  case ConnectionState.done:
                    return _buildLoadedMap();
                }
                return null;
              },
            );
        }
        return null;
      },
    );
  }
}
