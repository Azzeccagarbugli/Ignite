import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';

import 'package:ignite/views/fireman_screen_views/request_approval_screen.dart';
import 'package:ignite/widgets/painter.dart';
import 'package:ignite/widgets/remove_glow.dart';
import 'package:ignite/widgets/request_map.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
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
      extendBody: true,
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
          future: Provider.of<AppState>(context).getRequests(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new RequestCircularLoading();
              case ConnectionState.active:
              case ConnectionState.waiting:
                return new RequestCircularLoading();
              case ConnectionState.done:
                if (snapshot.hasError) return new RequestCircularLoading();
                return ScrollConfiguration(
                  behavior: RemoveGlow(),
                  child: AnimationLimiter(
                    child: new ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data[index].getOpen()) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(
                              milliseconds: 800,
                            ),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: new RequestCard(
                                  request: snapshot.data[index],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: FutureBuilder<Hydrant>(
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
                return new Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 124.0,
                        margin: EdgeInsets.only(left: 16.0, right: 8.0),
                        child: Card(
                          margin: const EdgeInsets.only(
                            left: 60.0,
                          ),
                          color: ThemeProvider.themeOf(context).id == "main"
                              ? Colors.white
                              : Colors.grey[700],
                          elevation: 6,
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: 46.0),
                            isThreeLine: true,
                            title: Text(
                              snapshot.data.getCity(),
                            ),
                            subtitle: Text(
                                "${snapshot.data.getStreetNumber()}\n${snapshot.data.getCap()}"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
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

class RequestCircularLoading extends StatelessWidget {
  const RequestCircularLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: PKCardPageSkeleton(
        totalLines: 5,
      ),
    );
  }
}
