import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/providers/auth_provider.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/views/faq.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:ignite/views/loading_view.dart';
import 'package:ignite/widgets/remove_glow.dart';
import 'package:ignite/widgets/settings_button.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'login_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String jsonFaq;
  ProfileSettingsScreen({
    @required this.jsonFaq,
  });

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String _urlImage;
  User _user;
  FirebaseUser _fireUser;

  Future<void> getFireUser() async {
    this._fireUser = await Provider.of<AuthProvider>(context).getUser();
  }

  Future<void> getDBUser() async {
    this._user = await DbProvider().getUserByMail(this._fireUser.email);
  }

  Future<void> setImageURL() async {
    print("Utente ${_user.isFacebook()}");
    if (_user.isFacebook() || _user.isGoogle()) {
      _urlImage = _fireUser.photoUrl;
    } else {
      var gravatar = Gravatar(this._fireUser.email);
      _urlImage = gravatar.imageUrl(
        size: 100,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true,
      );
    }
  }

  Future initFuture() async {
    await Future.wait([this.getFireUser()]);
    await Future.wait([this.getDBUser()]);
    await Future.wait([this.setImageURL()]);
  }

  Widget getChip() {
    return Chip(
      elevation: 4,
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image(
          image: (_user.isFacebook() || _user.isGoogle())
              ? (_user.isFacebook()
                  ? AssetImage("assets/images/profile_facebook.png")
                  : AssetImage("assets/images/profile_google.png"))
              : AssetImage("assets/images/profile_ignite.png"),
        ),
      ),
      label: Text(
        (_user.isFacebook() || _user.isGoogle())
            ? (_user.isFacebook() ? "Account Facebook" : "Account Google")
            : "Account Ignite",
        style: TextStyle(fontSize: 15.0),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget getResetButton() {
    if (!_user.isFacebook() && !_user.isGoogle()) {
      return SettingsButton(
        icon: Icon(
          Icons.security,
          color: Colors.white,
        ),
        title: "Cambia password",
        subtitlte: "Non ti piace la tua password? Clicca qui",
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: ThemeProvider.themeOf(context).id == "main"
                    ? Colors.white
                    : Colors.grey[800],
                title: Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    "Le verrà inviata una mail in cui potrà cambiare password e verrà disconnesso dal sistema.\n\nVuole procedere?",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeProvider.themeOf(context).id == "main"
                          ? Colors.grey[800]
                          : Colors.white,
                    ),
                  ),
                ),
                actions: <Widget>[
                  ButtonTheme(
                    buttonColor: Colors.green,
                    child: RaisedButton.icon(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      icon: Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                      ),
                      label: Text("Conferma",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Provider.of<AuthProvider>(context)
                            .recoverPassword(this._fireUser.email);
                        Provider.of<AuthProvider>(context).logOut(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                    ),
                  ),
                  ButtonTheme(
                    buttonColor: Colors.red,
                    child: RaisedButton.icon(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(
                          18.0,
                        ),
                      ),
                      icon: Icon(
                        Icons.thumb_down,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Annulla",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop();
                      },
                    ),
                  )
                ],
              );
            },
          );
        },
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    return FutureBuilder(
      future: initFuture(),
      builder: (context, data) {
        switch (data.connectionState) {
          case ConnectionState.none:
            return new LoadingScreen(
              message: "Recupero le informazioni",
              pathFlare: "assets/general/user.flr",
              nameAnimation: "smile",
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return new LoadingScreen(
              message: "Recupero le informazioni",
              pathFlare: "assets/general/user.flr",
              nameAnimation: "smile",
            );
          case ConnectionState.done:
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_urlImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: SafeArea(
                      bottom: false,
                      minimum: EdgeInsets.only(
                        top: 62,
                      ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.only(
                              top: Consts.avatarRadius + Consts.padding,
                            ),
                            margin: EdgeInsets.only(top: Consts.avatarRadius),
                            decoration: new BoxDecoration(
                              color: ThemeProvider.themeOf(context).id == "main"
                                  ? Colors.white
                                  : Colors.grey[900],
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.circular(Consts.padding),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 10.0),
                                ),
                              ],
                            ),
                            child: ScrollConfiguration(
                              behavior: RemoveGlow(),
                              child: ListView(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      this._fireUser.email,
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "main"
                                                ? Colors.grey[800]
                                                : Colors.white,
                                      ),
                                    ),
                                  ),
                                  this.getChip(),
                                  SizedBox(height: 16.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: Text(
                                      "Di seguito potrai accedere alle impostazioni messe a disposizione da Ignite",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "main"
                                                ? Colors.grey[700]
                                                : Colors.grey[200],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  SettingsButton(
                                    icon: Icon(
                                      Icons.device_unknown,
                                      color: Colors.white,
                                    ),
                                    title: "F.A.Q",
                                    subtitlte:
                                        "Se hai dei dubbi, questo fa al caso tuo!",
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return FaqScreen(
                                          jsonPath: widget.jsonFaq,
                                        );
                                      }));
                                    },
                                  ),
                                  SettingsButton(
                                    icon: Icon(
                                      Icons.brightness_4,
                                      color: Colors.white,
                                    ),
                                    title: ThemeProvider.themeOf(context).id ==
                                            "main"
                                        ? "Dark mode"
                                        : "Light mode",
                                    subtitlte: ThemeProvider.themeOf(context)
                                                .id ==
                                            "main"
                                        ? "Salva i tuoi occhi e la batteria del tuo device!"
                                        : "Ripristina la modalità di visualizzazione",
                                    onTap: () {
                                      ThemeProvider.controllerOf(context)
                                          .nextTheme();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return LoadingView();
                                      }));
                                    },
                                  ),
                                  getResetButton(),
                                  SettingsButton(
                                    icon: Icon(
                                      Icons.exit_to_app,
                                      color: Colors.white,
                                    ),
                                    title: "Logout",
                                    subtitlte:
                                        "Effettua il logout, ma torna presto eh!",
                                    onTap: () async {
                                      Provider.of<AuthProvider>(context)
                                          .logOut(context);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return LoginScreen();
                                      }));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(_urlImage),
                              radius: Consts.avatarRadius,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
        }
        return null;
      },
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
