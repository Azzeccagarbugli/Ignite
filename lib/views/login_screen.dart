import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/widgets/fab_first_screen.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _width = 0;
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    animationBuilder();
  }

  Future animationBuilder() async {
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      _width = 122;
      _opacity = _opacity == 0.0 ? 1.0 : 0.0;
    });
  }

  Future<String> _authUser(LoginData login) async {
    try {
      await Provider.of<AppState>(context)
          .authMailPassword(login.name, login.password);
    } catch (e) {
      switch (e.code) {
        case 'ERROR_USER_NOT_FOUND':
          return 'Email non corretta';
        case 'ERROR_WRONG_PASSWORD':
          return 'Password non corretta';
      }
    }
    return null;
  }

  Future<void> _authSignInGoogle() async {
    try {
      await Provider.of<AppState>(context).signInWithGoogle();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoadingScreen();
      }));
    } catch (e) {
      switch (e.code) {
        case 'ERROR_USER_NOT_FOUND':
          return 'Email non corretta';
        case 'ERROR_WRONG_PASSWORD':
          return 'Password non corretta';
      }
    }
    return null;
  }

  Future<String> _newUser(LoginData login) async {
    try {
      await Provider.of<AppState>(context)
          .newMailPassword(login.name, login.password);
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return 'Email non valida';
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return 'Email già utilizzata';
      }
    }
    return null;
  }

  Future<String> _recoverPassword(String currentEmail) async {
    try {
      Provider.of<AppState>(context).recoverPassword(currentEmail);
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return 'Email non valida';
        case 'ERROR_USER_NOT_FOUND':
          return 'Email inesistente';
      }
      return e.message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor:
          ThemeProvider.themeOf(context).data.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor:
          ThemeProvider.themeOf(context).data.primaryColor,
    ));

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          FlutterLogin(
            theme: LoginTheme(
              primaryColor: ThemeProvider.themeOf(context).data.primaryColor,
              accentColor: ThemeProvider.themeOf(context).data.accentColor,
              titleStyle: TextStyle(
                color: Colors.white,
              ),
              buttonTheme: LoginButtonTheme(
                splashColor: ThemeProvider.themeOf(context).data.accentColor,
              ),
            ),
            title: 'Ignite',
            logo: 'assets/images/logo_height.png',
            onRecoverPassword: _recoverPassword,
            messages: buildLoginMessages(),
            onLogin: _authUser,
            onSignup: _newUser,
            onSubmitAnimationCompleted: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return LoadingScreen();
              }));
            },
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: Duration(
                      milliseconds: 1200,
                    ),
                    opacity: _opacity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Altrimenti effettua l\'accesso con',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialChip(
                        label: 'Google',
                        icon: FontAwesomeIcons.google,
                        function: () {
                          _authSignInGoogle();
                        },
                        width: _width,
                        opacity: _opacity,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      SocialChip(
                        label: 'Facebook',
                        icon: FontAwesomeIcons.facebookF,
                        function: () {},
                        width: _width,
                        opacity: _opacity,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LoginMessages buildLoginMessages() {
    return LoginMessages(
      usernameHint: 'Email',
      passwordHint: 'Password',
      confirmPasswordHint: 'Conferma la password',
      loginButton: 'LOGIN',
      signupButton: 'REGISTRATI',
      forgotPasswordButton: 'Password dimenticata?',
      recoverPasswordButton: 'RECUPERA',
      goBackButton: 'INDIETRO',
      confirmPasswordError: 'Le due password inserite non corrispondono!',
      recoverPasswordDescription: 'Procedura per il recupero della password',
      recoverPasswordSuccess: 'Password recuperata con successo',
    );
  }
}

class SocialChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function function;
  final double width;
  final double opacity;

  SocialChip({
    @required this.label,
    @required this.icon,
    @required this.function,
    @required this.width,
    @required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 700,
      ),
      width: width,
      child: ActionChip(
        onPressed: function,
        backgroundColor: Colors.white,
        elevation: 12,
        labelPadding: EdgeInsets.all(
          6.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontFamily: 'Nunito',
        ),
        avatar: AnimatedOpacity(
          duration: Duration(
            milliseconds: 1900,
          ),
          opacity: opacity,
          child: Icon(
            icon,
            color: ThemeProvider.themeOf(context).data.primaryColor,
          ),
        ),
        label: AnimatedOpacity(
          duration: Duration(
            milliseconds: 1900,
          ),
          opacity: opacity,
          child: Text(
            label,
          ),
        ),
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  final Animation<double> animation;
  final Alignment align;
  ThemeButton({@required this.animation, @required this.align});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: FabLoginScreen(
        alignment: align,
        heroTag: 'button',
        icon: Icon(
          Icons.autorenew,
          color: ThemeProvider.themeOf(context).data.primaryColor,
        ),
        onPressed: () {
          ThemeProvider.controllerOf(context).nextTheme();
        },
      ),
    );
  }
}
