import 'package:flutter/material.dart';
import 'package:ignite/models/app_state.dart';
import 'dart:async';
import 'package:theme_provider/theme_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

class RequestApprovalScreen extends StatefulWidget {
  @override
  _RequestApprovalScreenState createState() => _RequestApprovalScreenState();
}

class _RequestApprovalScreenState extends State<RequestApprovalScreen> {
  final String attack1 = "1x1";
  final String attack2 = "2x2";
  final String cap = "60027";
  final String city = "Osimo";
  final String color = "Rosso";
  static final double geoPointLat = 43.472838;
  static final double geoPointLong = 13.489164;
  final DateTime lastChecked = DateTime.parse("1999-01-08");
  final String notes = "Nessuna nota";
  final String opening = "Grossa";
  final String place = "Vicino casa de mi cuggino";
  final String pressure = "BAR";
  final String streetAndNumber = "Via Fausto Coppi 30";
  final String type = "Un tipo";
  final String vehicle = "Un veicolo";
  TextStyle mainStyle = TextStyle(fontSize: 30.0, color: Colors.white);
  TextStyle secondStyle = TextStyle(fontSize: 20.0, color: Colors.white);
  TextStyle thirdStyle = TextStyle(fontSize: 15.0, color: Colors.white);

  Completer<GoogleMapController> _mapsController = Completer();
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('Hydrant'),
      position: _target,
      icon: BitmapDescriptor.defaultMarker,
    ),
  };
  static LatLng _target = LatLng(geoPointLat, geoPointLong);

  void _onMapCreated(GoogleMapController controller) {
    _mapsController.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
      body: SafeArea(
        child: Container(
          color: ThemeProvider.themeOf(context).data.primaryColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: ThemeProvider.themeOf(context).data.accentColor,
                  ),
                  child: AutoSizeText(
                    "Riepilogo",
                    style: mainStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: ThemeProvider.themeOf(context).data.accentColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        AutoSizeText(
                          "L'idrante si trova a $city, $streetAndNumber ($cap)",
                          style: secondStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          color: Colors.white,
                          height: 150.0,
                          child: GoogleMap(
                            rotateGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            markers: _markers,
                            mapType: MapType.satellite,
                            onMapCreated: _onMapCreated,
                            initialCameraPosition:
                                CameraPosition(target: _target, zoom: 18.0),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        AutoSizeText(
                          "($geoPointLat, $geoPointLong)",
                          style: secondStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        AutoSizeText(
                          "Data dell'ultimo controllo: ${lastChecked.day}/${lastChecked.month}/${lastChecked.year}",
                          style: secondStyle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: ThemeProvider.themeOf(context).data.accentColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        AutoSizeText(
                          "Primo attacco: ${(attack1 == null) ? "Valore non fornito" : attack1}",
                          style: thirdStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        AutoSizeText(
                          "Secondo attacco: ${(attack2 == null) ? "Valore non fornito" : attack2}",
                          style: thirdStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        AutoSizeText(
                          "Note: ${(notes == null) ? "Valore non fornito" : notes}",
                          textAlign: TextAlign.center,
                          style: thirdStyle,
                        ),
                        SizedBox(height: 10.0),
                        AutoSizeText(
                          "Apertura: ${(opening == null) ? "Valore non fornito" : opening}",
                          textAlign: TextAlign.center,
                          style: thirdStyle,
                        ),
                        SizedBox(height: 10.0),
                        AutoSizeText(
                          "Riferimenti spaziali: ${(place == null) ? "Valore non fornito" : place}",
                          textAlign: TextAlign.center,
                          style: thirdStyle,
                        ),
                        SizedBox(height: 10.0),
                        AutoSizeText(
                          "Pressione: ${(pressure == null) ? "Valore non fornito" : pressure}",
                          textAlign: TextAlign.center,
                          style: thirdStyle,
                        ),
                        SizedBox(height: 10.0),
                        AutoSizeText(
                          "Tipo: ${(type == null) ? "Valore non fornito" : type}",
                          textAlign: TextAlign.center,
                          style: thirdStyle,
                        ),
                        SizedBox(height: 10.0),
                        AutoSizeText(
                          "Veicolo: ${(vehicle == null) ? "Valore non fornito" : vehicle}",
                          textAlign: TextAlign.center,
                          style: thirdStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<AppState>(context)
                        .approveRequest(geoPointLat, geoPointLong);
                  },
                  child: Container(
                    height: 50.0,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
