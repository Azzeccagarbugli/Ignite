import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';

import 'package:ignite/views/fireman_screen_views/request_approval_screen.dart';
import 'package:ignite/widgets/painter.dart';
import 'package:ignite/widgets/request_map.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    top: 24,
                  ),
                  child: Card(
                    elevation: 12,
                    color: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.white
                        : Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AutoSizeText(
                            "Richieste",
                            style: TextStyle(
                              fontSize: 62,
                              color: ThemeProvider.themeOf(context).id == "main"
                                  ? Colors.red[600]
                                  : Colors.white,
                              fontFamily: 'Nunito',
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AutoSizeText(
                            "Mediante la seguente schermata si potrà decidere di confermare o declinare una delle richieste inoltrate",
                            style: TextStyle(
                              fontSize: 24,
                              color: ThemeProvider.themeOf(context).id == "main"
                                  ? Colors.red[900]
                                  : Colors.grey[200],
                              fontFamily: 'Nunito',
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
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
                        return new Swiper(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data[index].getOpen()) {
                              return new RequestCard(
                                request: snapshot.data[index],
                              );
                            }
                          },
                          itemWidth: double.infinity,
                          layout: SwiperLayout.DEFAULT,
                        );
                    }
                    return null; // unreachable
                  },
                ),
              ),
            ],
          ),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RequestApprovalScreen(request: this.request);
        }));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 36.0,
        ),
        child: new Card(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          semanticContainer: false,
          elevation: 12.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(
                                16.0,
                              ),
                              topRight: Radius.circular(
                                16.0,
                              ),
                            ),
                            child: Container(
                              height: 250,
                              child: RequestMap(
                                latitude: snapshot.data.getLat(),
                                longitude: snapshot.data.getLong(),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.map,
                              size: 30,
                            ),
                            title: Text(
                              "${snapshot.data.getCity()}",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 22,
                              ),
                            ),
                            subtitle: Text(
                              "${snapshot.data.getStreetNumber()}",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ButtonBarTheme(
                            data: ButtonBarThemeData(
                              alignment: MainAxisAlignment.center,
                            ),
                            child: ButtonBar(
                              children: <Widget>[
                                ButtonDeclineConfirm(
                                  color: Colors.red,
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.white,
                                  ),
                                  text: "Vai alla seguente richiesta",
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return RequestApprovalScreen(
                                          request: this.request);
                                    }));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                  }
                },
              ),
              // FutureBuilder<User>(
              //   future: Provider.of<AppState>(context)
              //       .getUserByDocumentReference(request.getRequestedBy()),
              //   builder: (context, snapshot) {
              //     switch (snapshot.connectionState) {
              //       case ConnectionState.none:
              //         return new RequestCircularLoading();
              //       case ConnectionState.active:
              //       case ConnectionState.waiting:
              //         return new RequestCircularLoading();
              //       case ConnectionState.done:
              //         if (snapshot.hasError)
              //           return new Text("Errore nel recupero dei dati");
              //         return Column(
              //           children: <Widget>[
              //             Text(
              //               "Segnalato da ${snapshot.data.getMail()}",
              //               style: TextStyle(
              //                 fontStyle: FontStyle.italic,
              //               ),
              //             ),
              //           ],
              //         );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonDeclineConfirm extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function onPressed;
  final Color color;
  ButtonDeclineConfirm({
    @required this.text,
    @required this.icon,
    @required this.onPressed,
    @required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      color: this.color,
      onPressed: this.onPressed,
      icon: this.icon,
      label: Text(
        this.text,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Nunito',
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
    return PKCardPageSkeleton(
      totalLines: 5,
    );
  }
}
