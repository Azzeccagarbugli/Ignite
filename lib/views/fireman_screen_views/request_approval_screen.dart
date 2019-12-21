import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/providers/auth_provider.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/widgets/button_decline_approve.dart';
import 'package:ignite/widgets/loading_shimmer.dart';
import 'package:ignite/widgets/remove_glow.dart';
import 'package:ignite/widgets/request_map.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

class RequestApprovalScreen extends StatefulWidget {
  final Request request;
  RequestApprovalScreen({
    @required this.request,
  });
  @override
  _RequestApprovalScreenState createState() => _RequestApprovalScreenState();
}

class _RequestApprovalScreenState extends State<RequestApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: ThemeProvider.themeOf(context).id == 'main'
          ? Colors.white
          : Colors.black,
      systemNavigationBarIconBrightness:
          ThemeProvider.themeOf(context).id == 'main'
              ? Brightness.dark
              : Brightness.light,
      systemNavigationBarDividerColor:
          ThemeProvider.themeOf(context).data.primaryColor,
    ));
    return Scaffold(
      body: FutureBuilder<Hydrant>(
        future: Provider.of<DbProvider>(context)
            .getHydrantByDocumentReference(widget.request.getHydrant()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new RequestLoading();
            case ConnectionState.active:
            case ConnectionState.waiting:
              return new RequestLoading();
            case ConnectionState.done:
              if (snapshot.hasError) return new RequestLoading();
              return new RequestScreenRecap(
                hydrant: snapshot.data,
                buttonBar: ButtonAppBarDeclineConfirm(
                  request: widget.request,
                ),
              );
          }
          return null;
        },
      ),
    );
  }
}

class RequestScreenRecap extends StatelessWidget {
  final Hydrant hydrant;
  final Widget buttonBar;
  final bool isHydrant;

  RequestScreenRecap({
    this.hydrant,
    this.buttonBar,
    this.isHydrant,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
        parallaxEnabled: true,
        parallaxOffset: .5,
        maxHeight: MediaQuery.of(context).size.height,
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Wrap(
                  children: <Widget>[
                    Center(
                      child: Text(
                        hydrant.getStreetNumber(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 24.0,
                          fontFamily: 'Nunito',
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _button(hydrant.getCity(), Icons.place),
                _button(hydrant.getCap(), Icons.map),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: ScrollConfiguration(
                  behavior: RemoveGlow(),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      RowBuilderHydrant(
                        tag: 'Latitudine',
                        value: hydrant.getLat().toString(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Longitudine',
                        value: hydrant.getLong().toString(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Dati spaziali',
                        value: hydrant.getPlace(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Note',
                        value: hydrant.getNotes(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Primo attacco',
                        value: hydrant.getFirstAttack(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Secondo attacco',
                        value: hydrant.getSecondAttack(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Pressione',
                        value: hydrant.getPressure(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Apertura',
                        value: hydrant.getVehicle(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Tipo',
                        value: hydrant.getType(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Colore',
                        value: hydrant.getColor(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Veicolo',
                        value: hydrant.getVehicle(),
                      ),
                      RowBuilderHydrant(
                        tag: 'Ultimo controllo',
                        value: hydrant.getLastCheck().toIso8601String(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonBarTheme(
                  data: ButtonBarThemeData(
                    alignment: MainAxisAlignment.center,
                  ),
                  child: buttonBar,
                ),
              ],
            ),
          ],
        ),
        body: RequestMap(
          latitude: hydrant.getLat(),
          longitude: hydrant.getLong(),
          isHydrant: isHydrant,
        ),
      ),
    );
  }

  Widget _button(String label, IconData icon) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Colors.red,
            size: 30,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Container(
          width: 72,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class ButtonAppBarDeclineConfirm extends StatelessWidget {
  final Request request;

  ButtonAppBarDeclineConfirm({
    @required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: <Widget>[
        ButtonDeclineConfirm(
          color: Colors.red,
          icon: Icon(
            Icons.thumb_down,
            color: Colors.white,
          ),
          text: "Declina",
          onPressed: () async {
            FirebaseUser user =
                await Provider.of<AuthProvider>(context).getUser();

            Provider.of<DbProvider>(context).denyRequest(this.request, user);
            Flushbar(
              flushbarStyle: FlushbarStyle.GROUNDED,
              flushbarPosition: FlushbarPosition.TOP,
              title: "Idrante non approvato",
              shouldIconPulse: true,
              message:
                  "La richiesta dell'idrante è stata eliminata con successo",
              icon: Icon(
                Icons.warning,
                size: 28.0,
                color: Colors.redAccent,
              ),
              duration: Duration(
                seconds: 4,
              ),
            )..show(context);
            Navigator.pop(context);
          },
        ),
        ButtonDeclineConfirm(
          color: Colors.green,
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          text: "Inserisci più valori",
          onPressed: () async {
            FirebaseUser user =
                await Provider.of<AuthProvider>(context).getUser();
            Provider.of<DbProvider>(context).approveRequest(
              this.request,
              user,
            );
          },
        ),
      ],
    );
  }
}

class RowBuilderHydrant extends StatelessWidget {
  final String value;
  final String tag;

  RowBuilderHydrant({
    @required this.value,
    @required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Chip(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.red),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6.0),
              bottomLeft: Radius.circular(6.0),
            ),
          ),
          label: Text(
            this.tag,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
            ),
          ),
        ),
        Chip(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.red),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(6.0),
              bottomRight: Radius.circular(6.0),
            ),
          ),
          label: Text(
            this.value,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
