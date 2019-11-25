import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:ignite/widgets/social_chip.dart';
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
    sasso();
    animationBuilder();
  }

  Future<void> sasso() async {
    await Provider.of<AppState>(context).accountsLogOut();
  }

  Future animationBuilder() async {
    await Future.delayed(Duration(
      milliseconds: 800,
    ));
    setState(() {
      _width = _width == 0.0 ? 122.0 : 0.0;
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

  Future<String> _authSignInGoogle() async {
    try {
      await Provider.of<AppState>(context).signInWithGoogle();
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_CREDENTIAL':
          return 'Errore nelle credenziali';
        case 'ERROR_USER_DISABLED':
          return 'Utente disabilitato';
        case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          return 'L\'account esiste gia con diverse credenziali';
        case 'ERROR_OPERATION_NOT_ALLOWED':
          return 'Operazione non consentita';
        case 'ERROR_INVALID_ACTION_CODE':
          return 'Action code non valido';
      }
    }
    return null;
  }

  Future<void> _googleLogin() async {
    String result = await _authSignInGoogle();
    if (result == null) {
      this._loadingScreen();
    } else {
      showLoginDialog(result);
    }
  }

  Future<String> _authSignInFacebook() async {
    try {
      await Provider.of<AppState>(context).signInWithFacebook();
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_CREDENTIAL':
          return 'Errore nelle credenziali';
        case 'ERROR_USER_DISABLED':
          return 'Utente disabilitato';
        case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          return 'L\'account esiste gia con diverse credenziali';
        case 'ERROR_OPERATION_NOT_ALLOWED':
          return 'Operazione non consentita';
        case 'ERROR_INVALID_ACTION_CODE':
          return 'Action code non valido';
        case 'CANCELLED_BY_USER':
          return e.message;
        case 'ERROR':
          return e.message;
      }
    }
    await Provider.of<AppState>(context).signInWithFacebook();
  }

  Future<void> _fbLogin() async {
    String result = await _authSignInFacebook();
    if (result == null) {
      this._loadingScreen();
    } else {
      showLoginDialog(result);
    }
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

  Future showLoginDialog(String result) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Errore nell\'autenticazione'),
            content: Text(result),
            actions: <Widget>[
              new FlatButton(
                child: Text('Chiudi'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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
            emailValidator: (value) {
              return value.isEmpty ? 'Email inserita non valida' : null;
            },
            passwordValidator: (value) {
              return value.isEmpty ? 'Password inserita non valida' : null;
            },
            onLogin: _authUser,
            onSignup: _newUser,
            onSubmitAnimationCompleted: () {
              this._loadingScreen();
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
                    curve: Curves.easeInOutCubic,
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
                          _googleLogin();
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
                        function: () {
                          _fbLogin();
                        },
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

  void _loadingScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoadingScreen();
    }));
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
