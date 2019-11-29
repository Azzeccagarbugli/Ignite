import 'package:flutter/material.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/views/fireman_screen_views/request_approval_screen.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

class FiremanScreenRequests extends StatefulWidget {
  @override
  _FiremanScreenRequestsState createState() => _FiremanScreenRequestsState();
}

class _FiremanScreenRequestsState extends State<FiremanScreenRequests> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
        title: Text(
          "Richieste in attesa di approvazione",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      backgroundColor: ThemeProvider.themeOf(context).data.accentColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: ThemeProvider.themeOf(context).data.accentColor,
                child: FutureBuilder<List<Request>>(
                  future: Provider.of<AppState>(context).getRequests(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return new RequestCircularLoading();
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return new RequestCircularLoading();
                      case ConnectionState.done:
                        if (snapshot.hasError)
                          return new RequestCircularLoading();
                        return new ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data[index].getOpen()) {
                              return new RequestCard(
                                  request: snapshot.data[index]);
                            }
                          },
                        );
                    }
                    return null; // unreachable
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  RequestCard({@required this.request});
  final Request request;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RequestApprovalScreen(request: this.request);
        }));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: new Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                FutureBuilder<Hydrant>(
                  future: Provider.of<AppState>(context)
                      .getHydrantByDocumentReference(request.getHydrant()),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return new RequestCircularLoading();
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return new RequestCircularLoading();
                      case ConnectionState.done:
                        if (snapshot.hasError)
                          return new Text("Errore nel recupero dei dati");
                        return Column(
                          children: <Widget>[
                            Text(
                                "${snapshot.data.getCity()}, ${snapshot.data.getStreetNumber()} \(${snapshot.data.getCap()}\)"),
                            Text(
                                "${snapshot.data.getGeoPoint().latitude}° N, ${snapshot.data.getGeoPoint().longitude}° E"),
                          ],
                        );
                    }
                  },
                ),
                FutureBuilder<User>(
                  future: Provider.of<AppState>(context)
                      .getUserByDocumentReference(request.getRequestedBy()),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return new RequestCircularLoading();
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return new RequestCircularLoading();
                      case ConnectionState.done:
                        if (snapshot.hasError)
                          return new Text("Errore nel recupero dei dati");
                        return Column(
                          children: <Widget>[
                            Text(
                              "Segnalato da ${snapshot.data.getMail()}",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
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
