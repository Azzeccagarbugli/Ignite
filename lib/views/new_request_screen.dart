import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ignite/widgets/clipping_class.dart';
import 'package:ignite/widgets/top_button_request.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:ignite/widgets/request_form.dart';

class NewRequestScreen extends StatefulWidget {
  LatLng position;
  NewRequestScreen({
    @required this.position,
  });
  @override
  _NewRequestScreenState createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      extendBody: true,
      backgroundColor: ThemeProvider.themeOf(context).id == "main"
          ? Colors.red[900]
          : Colors.grey[700],
      body: Column(
        children: <Widget>[
          ClipPath(
            clipper: ClippingClass(),
            child: Container(
              color: Colors.grey[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 42,
                    ),
                    child: TopButtonRequest(
                      context: context,
                      title: "Utilizza la posizione corrente",
                      subtitle: "Ottieni le informazioni automaticamente",
                      icon: Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                      function: () async {
                        Position position =
                            await Geolocator().getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high,
                        );
                        setState(() {
                          widget.position = LatLng(
                            position.latitude,
                            position.longitude,
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: RequestForm(
              isNewRequest: true,
              lat: widget.position.latitude,
              long: widget.position.longitude,
            ),
          ),
        ],
      ),
    );
  }
}
