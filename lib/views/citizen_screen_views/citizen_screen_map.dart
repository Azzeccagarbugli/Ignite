import 'dart:async';
import 'dart:typed_data';
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
  List<Marker> _markerSet;
  double _zoomCameraOnMe = 16.0;
  LatLng _curloc;
  String _mapStyle;
  bool _isSatellite;
  List<Hydrant> _approvedHydrants;
  List<Department> _departments;

  void setupPositionStream() {
    _positionStream = Geolocator()
        .getPositionStream(
      LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 1000),
    )
        .listen((pos) {
      _curloc = LatLng(pos.latitude, pos.longitude);
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

  Future<void> getApprovedHydrants() async {
    _approvedHydrants =
        await Provider.of<DbProvider>(context).getApprovedHydrants();
  }

  Future<void> getDepartments() async {
    _departments = await Provider.of<DbProvider>(context).getDepartments();
  }

  Future _buildHydrantMarkers() async {
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
          markerId: MarkerId(h.getDBReference()),
          position: LatLng(h.getLat(), h.getLong()),
          icon: BitmapDescriptor.fromBytes(markerIconHydrant),
        ),
      );
    }
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

  Future<void> _getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _curloc = LatLng(position.latitude, position.longitude);
  }

  Future _buildDepartmentsMarkers() async {
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
          markerId: MarkerId(d.getDBReference()),
          position: LatLng(d.getLat(), d.getLong()),
          icon: BitmapDescriptor.fromBytes(markerIconDepartment),
        ),
      );
    }
  }

  void _setSatellite() {
    setState(() {
      _isSatellite = !_isSatellite;
    });
  }

  GoogleMap _buildLoadingGoogleMap() {
    return GoogleMap(
      mapToolbarEnabled: false,
      indoorViewEnabled: true,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      mapType: _isSatellite ? MapType.satellite : MapType.normal,
      myLocationButtonEnabled: false,
      onMapCreated: _onMapCreated,
      markers: _markerSet.toSet(),
      initialCameraPosition: CameraPosition(
        target: LatLng(kStartupLat, kStartupLong),
        zoom: 5.0,
      ),
    );
  }

  GoogleMap _buildLoadedGoogleMap() {
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
        zoom: _zoomCameraOnMe,
      ),
    );
  }

  Widget _buildLoadingMap() {
    return Stack(
      children: <Widget>[
        this._buildLoadingGoogleMap(),
        Padding(
          padding: const EdgeInsets.only(top: 500.0),
          child: Center(
            child: Chip(
              label: Text(
                "Ricerca GPS in corso",
                style: TextStyle(fontSize: 15.0),
              ),
              backgroundColor: Colors.white,
            ),
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
    this._animateCameraOnMe();
    return Stack(
      children: <Widget>[
        this._buildLoadedGoogleMap(),
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
                    function: _setSatellite,
                    icon: Icons.filter_hdr,
                    heroTag: 'SATELLITE',
                  ),
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
    );
  }

  Future<void> _loadJson() async {
    await rootBundle
        .loadString(
            'assets/general/${ThemeProvider.optionsOf<CustomOptions>(context).filename}.json')
        .then((string) {
      _mapStyle = string;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }

  void _animateCameraOnMe() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(_curloc.latitude, _curloc.longitude),
        zoom: _zoomCameraOnMe,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    _markerSet = List<Marker>();
    _curloc = LatLng(kStartupLat, kStartupLong);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firstFutureInit(),
      builder: (context, data) {
        switch (data.connectionState) {
          case ConnectionState.none:
            return new LoadingScreen(
                message: "Caricamento della mappa in corso");
          case ConnectionState.active:
          case ConnectionState.waiting:
            return new LoadingScreen(
                message: "Caricamento della mappa in corso");
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
