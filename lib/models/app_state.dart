import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

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
    } catch (e) {
      throw e;
    }
    _db.collection('users').add({
      'email': mail,
      'isFireman': false,
    });
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      result = await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e;
    }

    _db
        .collection('users')
        .where('email', isEqualTo: '${result.user.email}')
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.isEmpty) {
        _db.collection('users').add({
          'email': result.user.email,
          'isFireman': false,
        });
      } //else {
      // TODO inserire blocco login screen
      // }
    });
  }

  Future<void> signInWithFacebook() async {
    final result = await facebookLogin.logIn(['email']);

    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$accessToken');
        final profile = json.decode(graphResponse.body);
        print(profile);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
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
}
