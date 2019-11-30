import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'dart:async';
import 'package:theme_provider/theme_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

class RequestApprovalScreen extends StatefulWidget {
  RequestApprovalScreen({@required this.request});
  final Request request;
  @override
  _RequestApprovalScreenState createState() => _RequestApprovalScreenState();
}

class _RequestApprovalScreenState extends State<RequestApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
      body: SafeArea(
        child: FutureBuilder<Hydrant>(
          future: Provider.of<AppState>(context)
              .getHydrantByDocumentReference(widget.request.getHydrant()),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new RequestCircularLoading();
              case ConnectionState.active:
              case ConnectionState.waiting:
                return new RequestCircularLoading();
              case ConnectionState.done:
                if (snapshot.hasError) return new RequestCircularLoading();
                return new RequestScreenRecap(
                    request: widget.request, hydrant: snapshot.data);
            }
            return null;
          },
        ),
      ),
    );
  }
}

class RequestScreenRecap extends StatelessWidget {
  RequestScreenRecap({@required this.hydrant, @required this.request});
  Request request;
  Hydrant hydrant;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
        title: Text(
          "Riepilogo",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Container(
        color: ThemeProvider.themeOf(context).data.accentColor,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                  "L'idrante si trova a ${hydrant.getCity()}, ${hydrant.getStreetNumber()} (${hydrant.getCap()})"),
              RequestMap(
                latitude: hydrant.getLat(),
                longitude: hydrant.getLong(),
              ),
              Text("${hydrant.getLat()}° N, ${hydrant.getLong()}° E"),
              Text(
                  "Data dell'ultimo controllo: ${hydrant.getLastCheck().day}/${hydrant.getLastCheck().month}/${hydrant.getLastCheck().year}"),
              Text(
                  "Primo attacco: ${hydrant.getFirstAttack() == "" ? "Valore non fornito" : hydrant.getFirstAttack()}"),
              Text(
                  "Secondo attacco: ${hydrant.getSecondAttack() == "" ? "Valore non fornito" : hydrant.getSecondAttack()}"),
              Text(
                  "Note: ${hydrant.getNotes() == "" ? "Valore non fornito" : hydrant.getNotes()}"),
              Text(
                  "Apertura: ${hydrant.getOpening() == "" ? "Valore non fornito" : hydrant.getOpening()}"),
              Text(
                  "Riferimenti spaziali: ${hydrant.getPlace() == "" ? "Valore non fornito" : hydrant.getPlace()}"),
              Text(
                  "Pressione: ${hydrant.getPressure() == "" ? "Valore non fornito" : hydrant.getPressure()}"),
              Text(
                  "Tipo: ${hydrant.getType() == "" ? "Valore non fornito" : hydrant.getType()}"),
              Text(
                  "Veicolo: ${hydrant.getVehicle() == "" ? "Valore non fornito" : hydrant.getVehicle()}"),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    color: ThemeProvider.themeOf(context).data.primaryColor,
                    child: Text("Approva richiesta"),
                    onPressed: () {
                      Provider.of<AppState>(context).approveRequest(request);
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  FlatButton(
                    color: ThemeProvider.themeOf(context).data.primaryColor,
                    child: Text("Declina richiesta"),
                    onPressed: () {
                      Provider.of<AppState>(context).denyRequest(request);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RequestMap extends StatelessWidget {
  RequestMap({@required this.latitude, @required this.longitude});
  Completer<GoogleMapController> _mapsController = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _mapsController.complete(controller);
  }

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 150.0,
      child: GoogleMap(
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
        markers: {
          Marker(
            markerId: MarkerId('Hydrant'),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarker,
          ),
        },
        mapType: MapType.satellite,
        onMapCreated: _onMapCreated,
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 18.0),
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
