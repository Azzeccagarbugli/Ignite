import "package:flutter/material.dart";
import 'package:ignite/views/faq.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:ignite/widgets/rounded_button_options.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:ignite/models/app_state.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String jsonFaq;
  final String userEmail;
  ProfileSettingsScreen({@required this.userEmail, @required this.jsonFaq});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String _urlGravatarImage;

  @override
  void initState() {
    super.initState();
  }

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

    return MaterialApp(
      home: Scaffold(
        backgroundColor: ThemeProvider.themeOf(context).data.accentColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
          title: Text(
            "Impostazioni utente",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
        body: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      _urlGravatarImage,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(widget.userEmail,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 60,
                  ),
                  RoundedButtonOptions(
                      context: context,
                      text: "FAQ",
                      function: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FaqScreen(jsonPath: widget.jsonFaq);
                        }));
                      }),
                  SizedBox(
                    height: 25,
                  ),
                  RoundedButtonOptions(
                    context: context,
                    text: "Cambia password",
                    function: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                                title: Text(
                                  "Le verrà inviata un'email in cui potrà cambiare password e verrà disconnesso dal sistema. Procedere?",
                                  style: TextStyle(),
                                ),
                                actions: <Widget>[
                                  ButtonTheme(
                                    buttonColor: Colors.green,
                                    child: RaisedButton(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      child: Text("Conferma",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        Provider.of<AppState>(context)
                                            .recoverPassword(widget.userEmail);
                                        Provider.of<AppState>(context)
                                            .logOut(context);
                                      },
                                    ),
                                  ),
                                  ButtonTheme(
                                    buttonColor: Colors.red,
                                    child: RaisedButton(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      child: Text(
                                        "Annulla",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                    ),
                                  )
                                ],
                              ));
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RoundedButtonOptions(
                    context: context,
                    text: "Cambia tema",
                    function: () {
                      ThemeProvider.controllerOf(context).nextTheme();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return LoadingScreen();
                      }));
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RoundedButtonOptions(
                    context: context,
                    text: "Disconnettiti",
                    function: () {
                      Provider.of<AppState>(context).logOut(context);
                    },
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
