import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ignite/widgets/loading_screen.dart';

import 'package:theme_provider/theme_provider.dart';

import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../../providers/services_provider.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/painter.dart';
import '../../widgets/remove_glow.dart';
import 'request_approval_screen.dart';

const double kSearchDistance = 20000;

class FiremanScreenRequests extends StatefulWidget {
  @override
  _FiremanScreenRequestsState createState() => _FiremanScreenRequestsState();
}

class _FiremanScreenRequestsState extends State<FiremanScreenRequests> {
  List<Request> _requests;
  LatLng _curloc;

  Future<void> _getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _curloc = LatLng(position.latitude, position.longitude);
  }

  Future _getRequests() async {
    _requests = await ServicesProvider()
        .getRequestsServices()
        .getPendingRequestsByDistance(
            _curloc.latitude, _curloc.longitude, kSearchDistance);
  }

  Future initFuture() async {
    await Future.wait([this._getPosition()]);
    await Future.wait([this._getRequests()]);
  }

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
        child: FutureBuilder(
          future: initFuture(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new LoadingScreen(
                  message: "In attesa del GPS",
                  pathFlare: "assets/general/gps_rotation.flr",
                  nameAnimation: "rotate",
                );
              case ConnectionState.active:
              case ConnectionState.waiting:
                return new LoadingScreen(
                  message: "In attesa del GPS",
                  pathFlare: "assets/general/gps_rotation.flr",
                  nameAnimation: "rotate",
                );
              case ConnectionState.done:
                if (snapshot.hasError)
                  return new LoadingScreen(
                    message: "Errore",
                    pathFlare: "assets/general/gps_rotation.flr",
                    nameAnimation: "rotate",
                  );
                if (_requests.isEmpty) {
                  return new Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildImage(
                            'not_found',
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Card(
                            color: ThemeProvider.themeOf(context).id == "main"
                                ? Colors.white
                                : Colors.grey[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            elevation: 8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.white,
                                    ),
                                  ),
                                  isThreeLine: true,
                                  title: Text(
                                    'Nessuna richiesta presente',
                                    style: TextStyle(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  "main"
                                              ? Colors.grey[850]
                                              : Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Al momento non è presente alcuna richiesta all\'interno di Ignite',
                                    style: TextStyle(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  "main"
                                              ? Colors.grey[650]
                                              : Colors.grey[100],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return ScrollConfiguration(
                    behavior: RemoveGlow(),
                    child: new ListView.builder(
                      itemCount: _requests.length,
                      itemBuilder: (context, index) {
                        return new RequestCard(
                          request: _requests[index],
                        );
                      },
                    ),
                  );
                }
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: SvgPicture.asset(
        'assets/images/$assetName.svg',
        placeholderBuilder: (BuildContext context) => new Container(
          padding: const EdgeInsets.all(30.0),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          ),
        ),
        width: 250.0,
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}

class RequestCard extends StatefulWidget {
  final Request request;

  RequestCard({
    @required this.request,
  });

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return RequestApprovalScreen(
                request: this.widget.request,
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
          future: ServicesProvider()
              .getHydrantsServices()
              .getHydrantById(widget.request.getHydrantId()),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new LoadingShimmer();
              case ConnectionState.active:
              case ConnectionState.waiting:
                return new LoadingShimmer();
              case ConnectionState.done:
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
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: ThemeProvider.themeOf(context).id ==
                                          "main"
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                "${snapshot.data.getStreet()}, ${snapshot.data.getNumber()}\n${snapshot.data.getCap()}",
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
                        padding: const EdgeInsets.only(left: 4.0),
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
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor:
                                    ThemeProvider.themeOf(context).id == "main"
                                        ? Colors.red
                                        : Colors.grey[800],
                                child: Text(
                                  snapshot.data
                                      .getCity()
                                      .substring(0, 2)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                  ),
                                ),
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
