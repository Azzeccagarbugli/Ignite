import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/widgets/top_flushbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../../providers/auth_provider.dart';
import '../../providers/services_provider.dart';
import '../../widgets/button_decline_approve.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/remove_glow.dart';
import '../../widgets/request_map.dart';
import '../../widgets/row_marker_details.dart';
import 'fireman_screen_add_information.dart';

class RequestApprovalScreen extends StatefulWidget {
  final Request request;
  RequestApprovalScreen({
    @required this.request,
  });
  @override
  _RequestApprovalScreenState createState() => _RequestApprovalScreenState();
}

class _RequestApprovalScreenState extends State<RequestApprovalScreen> {
  Hydrant _hydrant;
  String _userMail;
  User _user;

  Future initFuture() async {
    await Future.wait([_getUserMail()]);
    await Future.wait([_getUser(), _getHydrant()]);
  }

  Future _getUserMail() async {
    _userMail = await AuthProvider().getUserMail();
  }

  Future _getUser() async {
    _user =
        await ServicesProvider().getUsersServices().getUserByMail(_userMail);
  }

  Future _getHydrant() async {
    _hydrant = await ServicesProvider()
        .getHydrantsServices()
        .getHydrantById(widget.request.getHydrantId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        child: FutureBuilder(
          future: this.initFuture(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new LoadingShimmer();
              case ConnectionState.active:
              case ConnectionState.waiting:
                return new LoadingShimmer();
              case ConnectionState.done:
                if (snapshot.hasError) return new LoadingShimmer();
                return new RequestScreenRecap(
                  hydrant: this._hydrant,
                  buttonBar: ButtonAppBarDeclineConfirm(
                    user: this._user,
                    request: widget.request,
                    hydrant: this._hydrant,
                  ),
                );
            }
            return null;
          },
        ),
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
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
        parallaxEnabled: true,
        parallaxOffset: .5,
        color: ThemeProvider.themeOf(context).id == "main"
            ? Colors.white
            : Colors.black,
        maxHeight: hydrant.getFirstAttack().isNotEmpty
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height / 1.3,
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
                        hydrant.getStreet() + ", " + hydrant.getNumber(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 24.0,
                          fontFamily: 'Nunito',
                          color: ThemeProvider.themeOf(context).id == "main"
                              ? Colors.grey[800]
                              : Colors.white,
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
                _button(hydrant.getCity(), Icons.place, context),
                _button(hydrant.getCap(), Icons.map, context),
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
                      RowMarkerDetails(
                        tag: 'Latitudine',
                        value: hydrant.getLat().toString(),
                      ),
                      RowMarkerDetails(
                        tag: 'Longitudine',
                        value: hydrant.getLong().toString(),
                      ),
                      RowMarkerDetails(
                        tag: 'Note',
                        value: hydrant.getNotes(),
                      ),
                      hydrant.getFirstAttack().isNotEmpty
                          ? RowMarkerDetails(
                              tag: 'Primo attacco',
                              value: hydrant.getFirstAttack(),
                            )
                          : SizedBox(),
                      hydrant.getSecondAttack().isNotEmpty
                          ? RowMarkerDetails(
                              tag: 'Secondo attacco',
                              value: hydrant.getSecondAttack(),
                            )
                          : SizedBox(),
                      hydrant.getPressure().isNotEmpty
                          ? RowMarkerDetails(
                              tag: 'Pressione',
                              value: hydrant.getPressure(),
                            )
                          : SizedBox(),
                      hydrant.getOpening().isNotEmpty
                          ? RowMarkerDetails(
                              tag: 'Apertura',
                              value: hydrant.getOpening(),
                            )
                          : SizedBox(),
                      hydrant.getType().isNotEmpty
                          ? RowMarkerDetails(
                              tag: 'Tipo',
                              value: hydrant.getType(),
                            )
                          : SizedBox(),
                      hydrant.getColor().isNotEmpty
                          ? RowMarkerDetails(
                              tag: 'Colore',
                              value: hydrant.getColor(),
                            )
                          : SizedBox(),
                      hydrant.getVehicle().isNotEmpty
                          ? RowMarkerDetails(
                              tag: 'Veicolo',
                              value: hydrant.getVehicle(),
                            )
                          : SizedBox(),
                      RowMarkerDetails(
                        tag: 'Ultimo controllo',
                        value: hydrant.getLastCheck().toString(),
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

  Widget _button(String label, IconData icon, BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red
                : Colors.white,
            size: 30,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.red
                  : Colors.white,
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
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.grey[800]
                  : Colors.white,
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
  final Hydrant hydrant;
  final User user;
  ButtonAppBarDeclineConfirm({
    @required this.request,
    @required this.user,
    @required this.hydrant,
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
            await AuthProvider().getUser();
            ServicesProvider()
                .getRequestsServices()
                .denyRequest(this.request.getId(), this.user.getId())
                .then((status) {
              if (status) {
                new TopFlushbar(
                        "Idrante non approvato",
                        "La richiesta dell'idrante è stata eliminata con successo",
                        true)
                    .show(context);
              } else {
                new TopFlushbar("Errore", "Errore nella richiesta", false)
                    .show(context);
              }
            });
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return FiremanAddInformation(
                    hydrant: hydrant,
                    request: request,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
