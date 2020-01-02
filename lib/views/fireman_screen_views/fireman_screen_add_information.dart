import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/widgets/clipping_class.dart';
import 'package:ignite/widgets/top_button_request.dart';
import 'package:theme_provider/theme_provider.dart';

import '../new_request_screen.dart';

class FiremanAddInformation extends StatefulWidget {
  final Hydrant hydrant;

  FiremanAddInformation({
    @required this.hydrant,
  });

  @override
  _FiremanAddInformationState createState() => _FiremanAddInformationState();
}

class _FiremanAddInformationState extends State<FiremanAddInformation> {
  @override
  Widget build(BuildContext context) {
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
                      title: widget.hydrant.getCity() +
                          ", " +
                          widget.hydrant.getCap(),
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      subtitle:
                          "Idrante in " + widget.hydrant.getStreetNumber(),
                      function: () {
                        Flushbar(
                          flushbarStyle: FlushbarStyle.GROUNDED,
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          title: "Idrante nella città di " +
                              widget.hydrant.getCity(),
                          shouldIconPulse: true,
                          message:
                              "È possibile modificare i campi mancanti e poi confermare con il pulsante arancione in alto sulla destra",
                          icon: Icon(
                            Icons.rate_review,
                            size: 28.0,
                            color: Colors.greenAccent,
                          ),
                          duration: Duration(
                            seconds: 5,
                          ),
                        )..show(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: RequestForm(
              lat: widget.hydrant.getLat(),
              long: widget.hydrant.getLong(),
            ),
          ),
        ],
      ),
    );
  }
}
