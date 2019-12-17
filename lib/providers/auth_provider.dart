import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  final Firestore _db = Firestore.instance;

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

  Future<void> authMailPassword(String mail, String pass) async {
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      getUser().then((user) {
        print(user.email);
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> newMailPassword(String mail, String pass) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: pass);
      getUser().then((user) {
        this.updateUsersCollection(user.email, false);
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
      AuthResult result = await _auth.signInWithCredential(credential);
      getUser().then((user) {
        print(user.email);
      });
      getUser().then((user) {
        this.updateUsersCollection(user.email, false);
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

          AuthResult result = await _auth.signInWithCredential(credential);
          print(result.user.email);
          FirebaseUser user = await getUser();
          print(user.email);
          getUser().then((user) {
            this.updateUsersCollection(user.email, false);
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

  void logOut(BuildContext context) async {
    await this.accountsLogOut();
  }

  Future<void> accountsLogOut() async {
    getUser().then((currentUser) {
      print("L'utente si sta disconnettendo");
      print("Utente prima del logout: ${currentUser.email}");
    });
    await _auth.signOut();
    await googleSignIn.signOut();
    await facebookLogin.logOut();

    print("Utente disconnesso");
  }

  void updateUsersCollection(String mail, bool isFireman) {
    _db
        .collection('users')
        .where('email', isEqualTo: mail)
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.isEmpty) {
        _db.collection('users').add({
          'email': mail,
          'isFireman': isFireman,
          'isFirstAccess': true,
        });
      }
    });
    // notifyListeners();
  }
}
