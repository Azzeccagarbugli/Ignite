import 'dart:ui';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:ignite/providers/auth_provider.dart';
import 'package:ignite/views/faq.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:ignite/widgets/settings_button.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'login_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String jsonFaq;
  final String userEmail;
  ProfileSettingsScreen({
    @required this.userEmail,
    @required this.jsonFaq,
  });

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String _urlGravatarImage;

  void setGravatarEmailPic() {
    var gravatar = Gravatar(widget.userEmail);
    _urlGravatarImage = gravatar.imageUrl(
      size: 100,
      defaultImage: GravatarImage.retro,
      rating: GravatarRating.pg,
      fileExtension: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    setGravatarEmailPic();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(_urlGravatarImage),
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
                      borderRadius: BorderRadius.circular(Consts.padding),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.userEmail,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            color: ThemeProvider.themeOf(context).id == "main"
                                ? Colors.grey[800]
                                : Colors.white,
                          ),
                        ),
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
                              color: ThemeProvider.themeOf(context).id == "main"
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
                          subtitlte: "Se hai dei dubbi, questo fa al caso tuo!",
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
                          title: ThemeProvider.themeOf(context).id == "main"
                              ? "Dark mode"
                              : "Light mode",
                          subtitlte: ThemeProvider.themeOf(context).id == "main"
                              ? "Salva i tuoi occhi e la batteria del tuo device!"
                              : "Ripristina la modalità di visualizzazione",
                          onTap: () {
                            ThemeProvider.controllerOf(context).nextTheme();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return LoadingScreen();
                            }));
                          },
                        ),
                        SettingsButton(
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
                                  backgroundColor:
                                      ThemeProvider.themeOf(context).id ==
                                              "main"
                                          ? Colors.white
                                          : Colors.grey[800],
                                  title: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      "Le verrà inviata una mail in cui potrà cambiare password e verrà disconnesso dal sistema.\n\nVuole procedere?",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "main"
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
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
                                        ),
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: Colors.white,
                                        ),
                                        label: Text("Conferma",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          Provider.of<AuthProvider>(context)
                                              .recoverPassword(
                                                  widget.userEmail);
                                          Provider.of<AuthProvider>(context)
                                              .logOut(context);
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
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
                                          borderRadius:
                                              new BorderRadius.circular(
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
                        ),
                        SettingsButton(
                          icon: Icon(
                            Icons.device_unknown,
                            color: Colors.white,
                          ),
                          title: "Logout",
                          subtitlte: "Effettua il logout, ma torna presto eh!",
                          onTap: () async {
                            Provider.of<AuthProvider>(context).logOut(context);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_urlGravatarImage),
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
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
