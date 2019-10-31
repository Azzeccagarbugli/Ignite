import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ignite/homepage.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((loc) {
      print('latitudine ${loc.latitude} - longitudine ${loc.longitude}');
      Navigator.pushReplacement((context),
          MaterialPageRoute(builder: (context) {
        return Homepage(
          position: LatLng(loc.latitude, loc.longitude),
        );
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Coppola puzza',
          style: TextStyle(
            fontFamily: 'Product Sans',
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cop.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: null,
      ),
    );
  }
}
