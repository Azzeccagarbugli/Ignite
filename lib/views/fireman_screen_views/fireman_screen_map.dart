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
import 'package:ignite/views/fireman_screen_views/fireman_screen.dart';
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

  List<String> _attackValues;
  List<String> _vehicleValues;
  List<String> _openingValues;

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

  Future<void> _buildValues() async {
    _attackValues = await Provider.of<DbProvider>(context).getAttacks();
    _vehicleValues = await Provider.of<DbProvider>(context).getVehicles();
    _openingValues = await Provider.of<DbProvider>(context).getOpenings();
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
                        widget.position.latitude,
                        widget.position.longitude,
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
                          widget.position.latitude,
                          widget.position.longitude,
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

  void _setFilter() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            searchFunction: _animateCameraOnNearestHydrant,
            attacksList: _attackValues,
            vehiclesList: _vehicleValues,
            openingsList: _openingValues,
          );
        });
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

  void _animateCameraOnNearestHydrant(
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
    } else {
      double minDistance = double.maxFinite;
      double targetLat = widget.position.latitude;
      double targetLong = widget.position.longitude;
      Hydrant targetHydrant = null;
      for (Hydrant h in filteredHydrants) {
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
        message:
            "Verrà visualizzato l'idrante più vicino alla posizione attuale",
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
                  widget.position.latitude,
                  widget.position.longitude,
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
              return FutureBuilder(
                future: _buildValues(),
                builder: (context, result) {
                  return _buildGoogleMap();
                },
              );
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
                      function: _setFilter,
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

class CustomDialog extends StatefulWidget {
  CustomDialog(
      {@required this.searchFunction,
      @required this.attacksList,
      @required this.vehiclesList,
      @required this.openingsList});

  final Function searchFunction;
  final List<String> attacksList;
  final List<String> vehiclesList;
  final List<String> openingsList;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String _attackFilter;
  String _vehicleFilter;
  String _openingFilter;

  bool _attackSwitch = false;
  bool _vehicleSwitch = false;
  bool _openingSwitch = false;

  List<DropdownMenuItem<String>> _attacksListDropdown = [];
  List<DropdownMenuItem<String>> _vehiclesListDropdown = [];
  List<DropdownMenuItem<String>> _openingsListDropdown = [];

  bool notNull(Object o) => o != null;

  void setDropdownMenuItems() {
    for (String value in widget.attacksList) {
      _attacksListDropdown.add(DropdownMenuItem(
        value: value,
        child: Text(value),
      ));
    }
    for (String value in widget.vehiclesList) {
      _vehiclesListDropdown.add(DropdownMenuItem(
        value: value,
        child: Text(value),
      ));
    }
    for (String value in widget.openingsList) {
      _openingsListDropdown.add(DropdownMenuItem(
        value: value,
        child: Text(value),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    setDropdownMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeProvider.themeOf(context).data.backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text(
        "Trova l'idrante più vicino",
        style: TextStyle(
          fontFamily: "Nunito",
          fontWeight: FontWeight.bold,
          fontSize: 21,
        ),
      ),
      content: Container(
        height: 360,
        width: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Imposta filtro:",
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Chip(
                  elevation: 4,
                  backgroundColor: ThemeProvider.themeOf(context).id == "main"
                      ? Colors.red
                      : Colors.grey[700],
                  label: Text(
                    "Attacco",
                    style: TextStyle(
                        fontFamily: "Nunito",
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
                Spacer(),
                Switch(
                  value: _attackSwitch,
                  onChanged: (value) {
                    setState(() {
                      _attackSwitch = value;
                    });
                  },
                  activeColor: ThemeProvider.themeOf(context).id == "main"
                      ? Colors.red
                      : Colors.grey[700],
                ),
              ],
            ),
            _attackSwitch
                ? Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                    child: DropdownButton<String>(
                      hint: Text(
                        "Nessun attacco selezionato",
                        style: TextStyle(),
                      ),
                      value: _attackFilter,
                      isDense: true,
                      onChanged: (value) {
                        setState(() {
                          _attackFilter = value;
                        });
                      },
                      items: _attacksListDropdown,
                    ),
                  )
                : null,
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Chip(
                  elevation: 4,
                  backgroundColor: ThemeProvider.themeOf(context).id == "main"
                      ? Colors.red
                      : Colors.grey[700],
                  label: Text(
                    "Veicolo",
                    style: TextStyle(
                        fontFamily: "Nunito",
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
                Spacer(),
                Switch(
                  value: _vehicleSwitch,
                  onChanged: (value) {
                    setState(() {
                      _vehicleSwitch = value;
                    });
                  },
                  activeColor: ThemeProvider.themeOf(context).id == "main"
                      ? Colors.red
                      : Colors.grey[700],
                ),
              ],
            ),
            _vehicleSwitch
                ? Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                    child: DropdownButton<String>(
                      hint: Text(
                        "Nessun veicolo selezionato",
                        style: TextStyle(),
                      ),
                      value: _vehicleFilter,
                      isDense: true,
                      onChanged: (value) {
                        setState(() {
                          _vehicleFilter = value;
                        });
                      },
                      items: _vehiclesListDropdown,
                    ),
                  )
                : null,
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Chip(
                  elevation: 4,
                  backgroundColor: ThemeProvider.themeOf(context).id == "main"
                      ? Colors.red
                      : Colors.grey[700],
                  label: Text(
                    "Apertura",
                    style: TextStyle(
                        fontFamily: "Nunito",
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
                Spacer(),
                Switch(
                  value: _openingSwitch,
                  onChanged: (value) {
                    setState(() {
                      _openingSwitch = value;
                    });
                  },
                  activeColor: ThemeProvider.themeOf(context).id == "main"
                      ? Colors.red
                      : Colors.grey[700],
                ),
              ],
            ),
            _openingSwitch
                ? Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                    child: DropdownButton<String>(
                      hint: Text(
                        "Nessuna apertura selezionata",
                        style: TextStyle(),
                      ),
                      value: _openingFilter,
                      isDense: true,
                      onChanged: (value) {
                        setState(() {
                          _openingFilter = value;
                        });
                      },
                      items: _openingsListDropdown,
                    ),
                  )
                : null,
          ].where(notNull).toList(),
        ),
      ),
      actions: <Widget>[
        ButtonBar(
          children: <Widget>[
            ButtonDeclineConfirm(
              color: Colors.red,
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              text: "Annulla",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ButtonDeclineConfirm(
                color: Colors.green,
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                text: "Cerca",
                onPressed: () {
                  Navigator.pop(context);
                  widget.searchFunction(
                      _attackFilter, _vehicleFilter, _openingFilter);
                }),
          ],
        ),
      ],
    );
  }
}
