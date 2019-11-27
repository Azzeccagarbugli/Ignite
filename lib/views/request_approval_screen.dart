import 'package:flutter/material.dart';
import 'dart:async';
import 'package:theme_provider/theme_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  final double geoPointLat = 43.472838;

  final double geoPointLong = 13.489164;

  final DateTime lastChecked = DateTime.parse("1999-01-08");

  final String notes = "Nessuna nota";

  final String opening = "Apertura";

  final String place = "Vicino casa de mi cuggino";

  final String pressure = "BAR";

  final String streetAndNumber = "Via Fausto Coppi 30";

  final String type = "Un tipo";

  final String vehicle = "Un veicolo";
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);
  String attackOneValue() {
    return (attack1 == null) ? "Non fornito" : attack1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: ThemeProvider.themeOf(context).data.accentColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Riepilogo",
                  style: TextStyle(fontSize: 50.0, color: Colors.white),
                ),
                SizedBox(height: 10.0),
                Text(
                  "L'idrante si trova a $city, $streetAndNumber ($cap)",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                SizedBox(height: 10.0),
                Container(
                  color: Colors.white,
                  height: 100.0,
                ),
                Text(
                  "Data dell'ultimo controllo: ${lastChecked.day}/${lastChecked.month}/${lastChecked.year}",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Primo attacco: ${(attack1 == null) ? "Non fornito" : attack1}",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      Text(
                        "Secondo attacco: ${(attack2 == null) ? "Non fornito" : attack2}",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
