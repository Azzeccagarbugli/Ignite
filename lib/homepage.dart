import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:flutter/services.dart' show rootBundle;

class Homepage extends StatefulWidget {
  Homepage({@required this.position});
  final LatLng position;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController _mapController;
  String _mapStyle;
  Set<Marker> _markerSet = Set();

  Marker resultMarker = Marker(
      markerId: MarkerId(
        "Primo idrante",
      ),
      position: LatLng(0, 0),
      onTap: () {
        // Show slimy card
      });

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/general/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  void _addMarker() {
    setState(() {
      _markerSet.add(resultMarker);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
    this._addMarker();
  }

  void _animateCameraOnMe() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(widget.position.latitude, widget.position.longitude),
        zoom: 15.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(children: <Widget>[
        GoogleMap(
          indoorViewEnabled: true,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: _onMapCreated,
          markers: _markerSet,
          compassEnabled: true,
          initialCameraPosition: CameraPosition(
            target: widget.position,
            zoom: 15.0,
          ),
        ),
      ]),
      floatingActionButton: Container(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 150.0),
          child: FloatingActionButton.extended(
            onPressed: _animateCameraOnMe,
            elevation: 30,
            shape: new CircleBorder(),
            backgroundColor: Colors.red[800],
            label: Icon(Icons.gps_fixed),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
