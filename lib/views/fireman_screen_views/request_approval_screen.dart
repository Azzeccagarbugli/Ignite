import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/views/fireman_screen_views/fireman_screen_requests.dart';
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
      statusBarColor: Colors.transparent,
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
                request: widget.request,
                hydrant: snapshot.data,
              );
          }
          return null;
        },
      ),
    );
  }
}

class RequestScreenRecap extends StatelessWidget {
  final Request request;
  final Hydrant hydrant;
  RequestScreenRecap({
    @required this.hydrant,
    @required this.request,
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
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 16.0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _button(hydrant.getCity(), Icons.place),
                _button(hydrant.getCap(), Icons.map),
                _button(
                    hydrant.getPlace().isEmpty
                        ? 'Nessun riferimento fornito'
                        : hydrant.getPlace(),
                    Icons.location_city),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    tag: 'Note',
                    value: hydrant.getNotes(),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonBarTheme(
                  data: ButtonBarThemeData(
                    alignment: MainAxisAlignment.center,
                  ),
                  child: ButtonBar(
                    children: <Widget>[
                      ButtonDeclineConfirm(
                        color: Colors.red,
                        icon: Icon(
                          Icons.thumb_down,
                          color: Colors.white,
                        ),
                        text: "Declina",
                        onPressed: () {
                          Provider.of<AppState>(context)
                              .denyRequest(this.request);
                          Navigator.pop(context);
                        },
                      ),
                      ButtonDeclineConfirm(
                        color: Colors.green,
                        icon: Icon(
                          Icons.thumb_up,
                          color: Colors.white,
                        ),
                        text: "Approva",
                        onPressed: () {
                          Provider.of<AppState>(context)
                              .approveRequest(this.request);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: RequestMap(
          latitude: hydrant.getLat(),
          longitude: hydrant.getLong(),
        ),
      ),
      // Container(
      //   color: ThemeProvider.themeOf(context).data.accentColor,
      //   child: Center(
      //     child: Column(
      //       children: <Widget>[
      //         Text(
      //             "L'idrante si trova a ${hydrant.getCity()}, ${hydrant.getStreetNumber()} (${hydrant.getCap()})"),
      //         RequestMap(
      //           latitude: hydrant.getLat(),
      //           longitude: hydrant.getLong(),
      //         ),
      //         Text("${hydrant.getLat()}° N, ${hydrant.getLong()}° E"),
      //         Text(
      //             "Data dell'ultimo controllo: ${hydrant.getLastCheck().day}/${hydrant.getLastCheck().month}/${hydrant.getLastCheck().year}"),
      //         Text(
      //             "Primo attacco: ${hydrant.getFirstAttack() == "" ? "Valore non fornito" : hydrant.getFirstAttack()}"),
      //         Text(
      //             "Secondo attacco: ${hydrant.getSecondAttack() == "" ? "Valore non fornito" : hydrant.getSecondAttack()}"),
      //         Text(
      //             "Note: ${hydrant.getNotes() == "" ? "Valore non fornito" : hydrant.getNotes()}"),
      //         Text(
      //             "Apertura: ${hydrant.getOpening() == "" ? "Valore non fornito" : hydrant.getOpening()}"),
      //         Text(
      //             "Riferimenti spaziali: ${hydrant.getPlace() == "" ? "Valore non fornito" : hydrant.getPlace()}"),
      //         Text(
      //             "Pressione: ${hydrant.getPressure() == "" ? "Valore non fornito" : hydrant.getPressure()}"),
      //         Text(
      //             "Tipo: ${hydrant.getType() == "" ? "Valore non fornito" : hydrant.getType()}"),
      //         Text(
      //             "Veicolo: ${hydrant.getVehicle() == "" ? "Valore non fornito" : hydrant.getVehicle()}"),
      //         SizedBox(
      //           height: 10.0,
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             FlatButton(
      //               color: ThemeProvider.themeOf(context).data.primaryColor,
      //               child: Text("Approva richiesta"),
      //               onPressed: () {
      //                 Provider.of<AppState>(context).approveRequest(request);
      //                 Navigator.pop(context);
      //               },
      //             ),
      //             SizedBox(
      //               width: 10.0,
      //             ),
      //             FlatButton(
      //               color: ThemeProvider.themeOf(context).data.primaryColor,
      //               child: Text("Declina richiesta"),
      //               onPressed: () {
      //                 Provider.of<AppState>(context).denyRequest(request);
      //                 Navigator.pop(context);
      //               },
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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

class RequestCircularLoading extends StatelessWidget {
  const RequestCircularLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(
        ThemeProvider.themeOf(context).data.primaryColor,
      ),
    ));
  }
}
