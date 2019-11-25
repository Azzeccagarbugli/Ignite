import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:ignite/views/login_screen.dart';
import 'dart:developer' as dev;

class AppState extends ChangeNotifier {
  AuthResult result;
  FirebaseUser currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();

  Future<void> authMailPassword(String mail, String pass) async {
    try {
      result =
          await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      this.currentUser = result.user;
    } catch (e) {
      throw e;
    }
  }

  Future<void> newMailPassword(String mail, String pass) async {
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: pass);
      this.updateUsersCollection(mail, false);
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
      result = await _auth.signInWithCredential(credential);
      currentUser = result.user;
      this.updateUsersCollection(currentUser.email, false);
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

          result = await _auth.signInWithCredential(credential);
          currentUser = result.user;
          this.updateUsersCollection(currentUser.email, false);

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

  Future<bool> isCurrentUserFireman() async {
    if (currentUser != null) {
      QuerySnapshot querySnap = await _db
          .collection('users')
          .where('email', isEqualTo: "${currentUser.email}")
          .getDocuments();
      return querySnap.documents[0]["isFireman"];
    } else {
      return false;
    }
  }

  void updateUsersCollection(String mail, bool isFireman) {
    _db
        .collection('users')
        .where('email', isEqualTo: '${mail}')
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.isEmpty) {
        _db.collection('users').add({
          'email': mail,
          'isFireman': isFireman,
        });
      }
    });
  }

  ThemeData mainTheme() {
    return ThemeData(
      primaryColor: Colors.red[600],
      accentColor: Colors.grey[500],
      bottomAppBarColor: Colors.red[600],
      buttonColor: Colors.white,
      fontFamily: 'Nunito',
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      primaryColor: Colors.grey[900],
      accentColor: Colors.grey[700],
      bottomAppBarColor: Colors.grey[900],
      buttonColor: Colors.white,
      fontFamily: 'Nunito',
    );
  }

  void logOut(BuildContext context) async {
    await this.accountsLogOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }

  Future<void> accountsLogOut() async {
    print("L'utente si sta disconnettendo");
    print("Utente prima del logout: ${currentUser.email}");
    await _auth.signOut();
    print("Fire logout");
    await googleSignIn.signOut();
    print("Google logout");
    await facebookLogin.logOut();
    currentUser = await _auth.currentUser();

    print("Utente disconnesso");
  }

  FirebaseUser getUser() {
    return currentUser;
  }
}
