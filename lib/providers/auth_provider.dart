import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final facebookLogin = FacebookLogin();
  final Firestore _db = Firestore.instance;
  bool authMail = false;
  bool authGoogle = false;
  bool authFB = false;

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
    print("Tentativo per ${mail} e ${pass}");
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: mail, password: pass);
    } catch (e) {
      throw e;
    }
    getUser().then((user) {
      print("${user.email} ha effettuato il login con mail e password");
    });
    authMail = true;
  }

  Future<void> newMailPassword(String mail, String pass) async {
    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: mail,
        password: pass,
      ))
          .user;
      this.updateUsersCollection(user.email, false);
      getUser().then((user) {
        print("${user.email} ha effettuato il login con mail e password");
      });
      authMail = true;
      /*AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: pass);
      getUser().then((user) {
        this.updateUsersCollection(user.email, false);
      });*/
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
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      this.updateUsersCollection(user.email, false);
      await _auth.signInWithCredential(credential);
      getUser().then((user) {
        print("${user.email} ha effettuato il login con Google");
      });
      authGoogle = true;
      /*AuthResult result = await _auth.signInWithCredential(credential);
      getUser().then((user) {
        print(user.email);
      });
      getUser().then((user) {
        this.updateUsersCollection(user.email, false);
      });*/
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
          final FirebaseUser user =
              (await _auth.signInWithCredential(credential)).user;
          this.updateUsersCollection(user.email, false);
          await _auth.signInWithCredential(credential);
          getUser().then((user) {
            print("${user.email} ha effettuato il login con Facebook");
          });
          authFB = true;
          /*AuthResult result = await _auth.signInWithCredential(credential);
          print(result.user.email);
          FirebaseUser user = await getUser();
          print(user.email);
          getUser().then((user) {
            this.updateUsersCollection(user.email, false);
          });*/

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
    authMail = false;
    await googleSignIn.signOut();
    authGoogle = false;
    await facebookLogin.logOut();
    authFB = false;
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
