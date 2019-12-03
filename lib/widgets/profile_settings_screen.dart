import "package:flutter/material.dart";
import 'package:ignite/models/app_state.dart';
import 'package:ignite/views/faq.dart';
import 'package:ignite/widgets/rounded_button_options.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String jsonFaq;
  ProfileSettingsScreen({@required this.jsonFaq});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String _userEmail;
  String _urlGravatarImage;

  @override
  void initState() {
    setGravatarEmailPic();
    super.initState();
  }

  void setGravatarEmailPic() {
    _userEmail = Provider.of<AppState>(context, listen: false).getUser().email;
    var gravatar = Gravatar(_userEmail);
    _urlGravatarImage = gravatar.imageUrl(
      size: 100,
      defaultImage: GravatarImage.retro,
      rating: GravatarRating.pg,
      fileExtension: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
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
              padding: const EdgeInsets.only(top: 30),
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
                  Text(_userEmail,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Nunito",
                      )),
                  SizedBox(
                    height: 40,
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
                    height: 20,
                  ),
                  RoundedButtonOptions(
                    context: context,
                    text: "Cambia password",
                    function: () {},
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RoundedButtonOptions(
                    context: context,
                    text: "Cambia immagine profilo",
                    function: () {},
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RoundedButtonOptions(
                    context: context,
                    text: "Disconnettiti",
                    function: () {
                      Provider.of<AppState>(context).logOut(context);
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
