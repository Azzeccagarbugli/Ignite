import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:theme_provider/theme_provider.dart';

class NewRequestScreen extends StatefulWidget {
  @override
  _NewRequestScreenState createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  LatLng _position;
  StreamSubscription<Position> _positionStream;
  List<Placemark> _placemark;
  void setupPositionStream() {
    _positionStream = Geolocator()
        .getPositionStream(
      LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 1000),
    )
        .listen((pos) {
      _position = LatLng(pos.latitude, pos.longitude);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setupPositionStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
        title: Text("Aggiunta idrante"),
        centerTitle: true,
      ),
      backgroundColor: ThemeProvider.themeOf(context).data.accentColor,
      body: FutureBuilder<List<Placemark>>(
        future: Geolocator()
            .placemarkFromCoordinates(_position.latitude, _position.longitude),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new RequestCircularLoading();
            case ConnectionState.active:
            case ConnectionState.waiting:
              return new RequestCircularLoading();
            case ConnectionState.done:
              if (snapshot.hasError) return new RequestCircularLoading();
              return Center(
                child: new Column(
                  children: <Widget>[
                    Text(snapshot.data[0].administrativeArea),
                    Text(snapshot.data[0].country),
                    Text(snapshot.data[0].isoCountryCode),
                    Text(snapshot.data[0].locality),
                    Text(snapshot.data[0].name),
                    Text(snapshot.data[0].postalCode),
                    Text(snapshot.data[0].subLocality),
                    Text(snapshot.data[0].subAdministrativeArea),
                    Text(snapshot.data[0].subThoroughfare),
                    Text(snapshot.data[0].thoroughfare),
                  ],
                ),
              );
          }
          return null;
        },
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
          ThemeProvider.themeOf(context).data.primaryColor),
    ));
  }
}
