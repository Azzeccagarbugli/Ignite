import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/views/fireman_screen_views/request_approval_screen.dart';
import 'package:ignite/widgets/loading_shimmer.dart';
import 'package:ignite/widgets/painter.dart';
import 'package:ignite/widgets/remove_glow.dart';
import 'package:ignite/widgets/request_map.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

class FiremanScreenRequests extends StatefulWidget {
  @override
  _FiremanScreenRequestsState createState() => _FiremanScreenRequestsState();
}

class _FiremanScreenRequestsState extends State<FiremanScreenRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: CustomPaint(
        painter: Painter(
          first: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.grey[850],
          second: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[400]
              : Colors.grey[900],
          background: ThemeProvider.themeOf(context).id == "main"
              ? Colors.white
              : Colors.grey[700],
        ),
        child: FutureBuilder<List<Request>>(
          future: Provider.of<DbProvider>(context).getRequests(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new RequestLoading();
              case ConnectionState.active:
              case ConnectionState.waiting:
                return new RequestLoading();
              case ConnectionState.done:
                if (snapshot.hasError) return new RequestLoading();
                return ScrollConfiguration(
                  behavior: RemoveGlow(),
                  child: new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data[index].getOpen()) {
                        return new RequestCard(
                          request: snapshot.data[index],
                        );
                      }
                    },
                  ),
                );
            }
            return null; // unreachable
          },
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final Request request;

  RequestCard({
    @required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return RequestApprovalScreen(
                request: this.request,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: FutureBuilder<Hydrant>(
          future: Provider.of<DbProvider>(context)
              .getHydrantByDocumentReference(request.getHydrant()),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new RequestLoading();
              case ConnectionState.active:
              case ConnectionState.waiting:
                return new RequestLoading();
              case ConnectionState.done:
                if (snapshot.hasError)
                  return new Text("Errore nel recupero dei dati");
                return new Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 124.0,
                        margin: EdgeInsets.only(left: 16.0, right: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          margin: const EdgeInsets.only(
                            left: 60.0,
                          ),
                          color: ThemeProvider.themeOf(context).id == "main"
                              ? Colors.white
                              : Colors.grey[900],
                          elevation: 10,
                          child: Center(
                            child: ListTile(
                              contentPadding: EdgeInsets.only(left: 46.0),
                              isThreeLine: true,
                              title: Text(
                                snapshot.data.getCity(),
                                style: TextStyle(
                                  fontSize: 28,
                                  color: ThemeProvider.themeOf(context).id ==
                                          "main"
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                "${snapshot.data.getStreetNumber()}\n${snapshot.data.getCap()}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ThemeProvider.themeOf(context).id ==
                                          "main"
                                      ? Colors.grey[600]
                                      : Colors.grey[100],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Container(
                          margin: new EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          alignment: FractionalOffset.centerLeft,
                          height: 92.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(64),
                            ),
                            child: Container(
                              alignment: FractionalOffset.centerLeft,
                              height: 92,
                              width: 92,
                              child: RequestMap(
                                latitude: snapshot.data.getLat(),
                                longitude: snapshot.data.getLong(),
                                isHydrant: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              default:
                return Text("data");
            }
          },
        ),
      ),
    );
  }
}
