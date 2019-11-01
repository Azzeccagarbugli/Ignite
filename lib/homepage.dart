import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart' show rootBundle;

class Homepage extends StatefulWidget {
  Homepage({@required this.position});
  LatLng position;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController _mapController;
  String _mapStyle;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/general/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: GoogleMap(
        indoorViewEnabled: true,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: _onMapCreated,
        compassEnabled: false,
        initialCameraPosition: CameraPosition(
          target: widget.position,
          zoom: 14.0,
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: 1,
        animationDuration: Duration(milliseconds: 500),
        buttonBackgroundColor: Colors.white,
        items: <Icon>[
          Icon(
            Icons.terrain,
            size: 35,
            color: Colors.red[800],
          ),
          Icon(
            Icons.add,
            size: 35,
            color: Colors.red[800],
          ),
          Icon(
            Icons.supervisor_account,
            size: 35,
            color: Colors.red[800],
          ),
        ],
        onTap: (index) {},
      ),
    );
  }
}
