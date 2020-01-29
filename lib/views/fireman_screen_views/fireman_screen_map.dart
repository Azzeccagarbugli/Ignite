import 'dart:async';
import 'dart:typed_data';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ignite/helper/map_launcher.dart';
import 'package:ignite/main.dart';
import 'package:ignite/models/department.dart';
import 'package:provider/provider.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/providers/services_provider.dart';
import 'package:ignite/views/department_screen.dart';
import 'package:ignite/views/fireman_screen_views/request_approval_screen.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:ignite/widgets/custom_dialog_search.dart';

import 'package:ignite/widgets/homepage_button.dart';

import 'dart:ui' as ui;

import 'package:theme_provider/theme_provider.dart';

const double kStartupLat = 41.9038243;
const double kStartupLong = 12.4476838;

class FiremanScreenMap extends StatefulWidget {
  @override
  _FiremanScreenMapState createState() => _FiremanScreenMapState();
}

class _FiremanScreenMapState extends State<FiremanScreenMap> {
  StreamSubscription<Position> _positionStream;
  GoogleMapController _mapController;
  LatLng _curloc;
  String _mapStyle;
  List<Marker> _markerSet;
  List<Hydrant> _approvedHydrants;
  List<Department> _departments;
  List<String> _attackValues;
  List<String> _vehicleValues;
  List<String> _openingValues;
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
    _approvedHydrants =
        await ServicesProvider().getHydrantsServices().getApprovedHydrants();
  }

  Future<void> getDepartments() async {
    _departments =
        await ServicesProvider().getDepartmentsServices().getDepartments();
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
      this._buildValues(),
      this._getPosition(),
    ]);
    this.setupPositionStream();
  }

  Future<void> _buildValues() async {
    _attackValues = await ServicesProvider().getValuesServices().getAttacks();
    _vehicleValues = await ServicesProvider().getValuesServices().getVehicles();
    _openingValues = await ServicesProvider().getValuesServices().getOpenings();
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
                    function: () {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 40.0,
                            left: 15.0,
                          ),
                          child: Container(
                            height: 300,
                            width: 100,
                          ),
                        ),
                      );
                    },
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

  bool isVisible = false;

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
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      isVisible
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                child: Container(
                                  color: ThemeProvider.themeOf(context).id ==
                                          "main"
                                      ? Colors.grey[350]
                                      : Colors.grey[850],
                                  height: 140,
                                  width: 40,
                                ),
                              ),
                            )
                          : SizedBox(),
                      HomePageButton(
                        function: () {
                          isVisible = true;
                        },
                        icon: Icons.filter_hdr,
                        heroTag: 'SATELLITE',
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  HomePageButton(
                    function: () {
                      _animateCameraOnMe(false);
                    },
                    icon: Icons.gps_fixed,
                    heroTag: 'GPS',
                  ),
                  HomePageButton(
                    heroTag: 'NEARESTHYDRANT',
                    icon: Icons.not_listed_location,
                    function: _animateCameraOnNearestHydrant,
                  ),
                  HomePageButton(
                    heroTag: 'NEARESTHYDRANTFILTERED',
                    icon: Icons.filter_list,
                    function: _setFilterAndSearch,
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

  void _setFilterAndSearch() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          searchFunction: _animateCameraOnNearestHydrantUsingFilter,
          attacksList: _attackValues,
          vehiclesList: _vehicleValues,
          openingsList: _openingValues,
        );
      },
    );
  }

  List<Hydrant> _buildHydrantsFilteredForSearch(
      String attack, String vehicle, String opening) {
    print(attack);
    List<Hydrant> filteredHydrants = List.from(_approvedHydrants);
    for (Hydrant h in _approvedHydrants) {
      if (attack == "" && vehicle == "" && opening == "") {
      } else if ((attack != null &&
              attack != h.getFirstAttack() &&
              attack != h.getSecondAttack()) ||
          (vehicle != null && vehicle != h.getVehicle()) ||
          (opening != null && opening != h.getOpening())) {
        filteredHydrants.remove(h);
      }
    }
    return filteredHydrants;
  }

  void _animateCameraOnNearestHydrant() {
    _searchAndZoomOnNearestHydrant(_approvedHydrants);
  }

  void _animateCameraOnNearestHydrantUsingFilter(
      String attack, String vehicle, String opening) async {
    List<Hydrant> filteredHydrants =
        _buildHydrantsFilteredForSearch(attack, vehicle, opening);
    if (filteredHydrants.isEmpty) {
      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: ThemeProvider.themeOf(context).data.bottomAppBarColor,
        icon: Icon(
          Icons.explore,
          color: Colors.white,
        ),
        title: "Idrante non trovato",
        message:
            "Non esistono idranti con queste caratteristiche all'interno della mappa",
        duration: Duration(
          seconds: 2,
        ),
      )..show(context);
      return;
    }
    _searchAndZoomOnNearestHydrant(filteredHydrants);
  }

  void _searchAndZoomOnNearestHydrant(List<Hydrant> hydrants) async {
    double minDistance = double.maxFinite;
    double targetLat = _curloc.latitude;
    double targetLong = _curloc.longitude;
    Hydrant targetHydrant = null;
    for (Hydrant h in hydrants) {
      double distance = await Geolocator().distanceBetween(
          _curloc.latitude, _curloc.longitude, h.getLat(), h.getLong());

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
        zoom: 16.0,
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
            return LoadingScreen(
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
            if (data.hasError)
              return new LoadingScreen(
                message: "Errore",
                pathFlare: "assets/general/maps.flr",
                nameAnimation: "anim",
              );
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
