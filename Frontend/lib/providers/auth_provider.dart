import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import '../factories/servicesfactories/servicesfactory.dart';
import '../models/user.dart';
import '../services/users_services.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final facebookLogin = FacebookLogin();

  ServicesFactory _factory;
  UsersServices _usersServices;

  void setFactory(ServicesFactory factory) {
    this._factory = factory;
    this._usersServices = this._factory.getUsersServices();
  }

  static final AuthProvider _singleton = AuthProvider._internal();

  factory AuthProvider() {
    return _singleton;
  }

  AuthProvider._internal();

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  Future<String> getUserMail() async {
    FirebaseUser user = await this.getUser();
    if (user == null) {
      return 'null';
    } else {
      String mail = user.email;
      return mail;
    }
  }

  Future<String> getUserImage() async {
    FirebaseUser user = await this.getUser();
    if (user == null) {
      return 'null';
    } else {
      String image = user.photoUrl;
      return image;
    }
  }

  Future<void> authMailPassword(String mail, String pass) async {
    try {
      await _auth.signInWithEmailAndPassword(email: mail, password: pass);
    } catch (e) {
      throw e;
    }
    getUser().then((user) {
      print("${user.email} ha effettuato il login con mail e password");
    });
  }

  Future<void> newMailPassword(String mail, String pass) async {
    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: mail,
        password: pass,
      ))
          .user;
      await this.updateUsersCollection(user.email, false, false, false);
      getUser().then((user) {
        print("${user.email} ha effettuato il login con mail e password");
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      AuthResult res = await _auth.signInWithCredential(credential);
      final FirebaseUser user = res.user;
      await Future.wait(
          [this.updateUsersCollection(user.email, false, true, false)]);
      // await _auth.signInWithCredential(credential);
      getUser().then((user) {
        print("${user.email} ha effettuato il login con Google");
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> signInWithFacebook() async {
    final fbResult = await facebookLogin.logIn(['email']);
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeOnly;
    try {
      switch (fbResult.status) {
        case FacebookLoginStatus.loggedIn:
          FacebookAccessToken myToken = fbResult.accessToken;
          AuthCredential credential =
              FacebookAuthProvider.getCredential(accessToken: myToken.token);
          AuthResult res = await _auth.signInWithCredential(credential);
          final FirebaseUser user = res.user;
          await Future.wait(
              [this.updateUsersCollection(user.email, false, false, true)]);

          // await _auth.signInWithCredential(credential);
          getUser().then((user) {
            print("${user.email} ha effettuato il login con Facebook");
          });

          break;
        case FacebookLoginStatus.cancelledByUser:
          throw new AuthException(
              'CANCELLED_BY_USER', 'Login cancellato dall\'utente');
          break;
        case FacebookLoginStatus.error:
          throw new AuthException(
              'ERROR',
              'Something went wrong with the login process.\n'
                  'Here\'s the error Facebook gave us: ${fbResult.errorMessage}');
          break;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> recoverPassword(String currentEmail) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: currentEmail,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> logOut(BuildContext context) async {
    getUser().then((currentUser) {
      print("L'utente si sta disconnettendo");
      print("Utente prima del logout: ${currentUser.email}");
    });
    await _auth.signOut();
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    print("Utente disconnesso");
  }

  Future updateUsersCollection(
      String mail, bool isFireman, bool isGoogle, bool isFacebook) async {
    User dbUser = await _usersServices.getUserByMail(mail);
    if (dbUser == null) {
      await _usersServices
          .addUser(new User.citizen("", mail, true, isGoogle, isFacebook));
    } else {
      await _usersServices.updateUser(new User.citizen(
          dbUser.getId(), dbUser.getMail(), false, isGoogle, isFacebook));
    }
  }
}
