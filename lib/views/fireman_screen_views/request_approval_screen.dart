import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
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
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 22.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  hydrant.getStreetNumber(),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 36.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _button("Events", Icons.event, Colors.blue),
                _button("Events", Icons.event, Colors.red),
                _button("Events", Icons.event, Colors.amber),
                _button("Events", Icons.event, Colors.green),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[],
              ),
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

  Widget _button(String label, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 8.0,
            )
          ]),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(label),
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
