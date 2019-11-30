import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/views/login_screen.dart';

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
      //   notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> newMailPassword(String mail, String pass) async {
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: pass);
      this.updateUsersCollection(mail, false);
      //  notifyListeners();
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
      //   notifyListeners();
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
      //  notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> recoverPassword(String currentEmail) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: currentEmail,
      );
      //   notifyListeners();
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
    // notifyListeners();
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
    await _auth.signOut().then((_) async {
      googleSignIn.signOut();
      facebookLogin.logOut();
      currentUser = await _auth.currentUser();
    });
    // notifyListeners();

    print("Utente disconnesso");
  }

  FirebaseUser getUser() {
    return currentUser;
  }

  Future<List<Request>> getRequests() async {
    QuerySnapshot qsRequests = await _db.collection('requests').getDocuments();
    List<Request> requests = new List<Request>();

    for (DocumentSnapshot ds in qsRequests.documents) {
      DocumentReference approvedBy = ds.data['approved_by'];
      DocumentReference hydrant = ds.data['hydrant'];
      DocumentReference requestedBy = ds.data['requested_by'];
      requests.add(Request(ds.documentID, ds.data['approved'], ds.data['open'],
          approvedBy.documentID, hydrant.documentID, requestedBy.documentID));
    }
    return requests;
  }

  Future<Request> getRequestByDocumentReference(String ref) async {
    DocumentSnapshot ds = await _db.collection('requests').document(ref).get();
    Map<String, dynamic> data = ds.data;
    return new Request(ref, data['approved'], data["open"], data['approvedBy'],
        data['hydrant'], data['requestedBy']);
  }

  Future<Hydrant> getHydrantByDocumentReference(String ref) async {
    DocumentSnapshot ds = await _db.collection('hydrants').document(ref).get();
    Map<String, dynamic> data = ds.data;
    Timestamp time = data['last_check'];
    GeoPoint geo = data['geopoint'];
    return new Hydrant(
        ds.documentID,
        data['attack'][0],
        data['attack'][1],
        data['bar'],
        data['cap'],
        data['city'],
        geo.latitude,
        geo.longitude,
        data['color'],
        time.toDate(),
        data['notes'],
        data['opening'],
        data['place'],
        data['street_number'],
        data['type'],
        data['vehicle']);
  }

  Future<User> getUserByDocumentReference(String ref) async {
    DocumentSnapshot ds = await _db.collection('users').document(ref).get();
    Map<String, dynamic> data = ds.data;
    Timestamp time = data['birthday'];
    if (ds.data['isFireman'] == 'true') {
      return new User(
          ds.documentID,
          data['email'],
          time.toDate(),
          data['name'],
          data['surname'],
          data['residence_street_number'],
          data['cap'],
          data['department']);
    } else {
      return new User.onlyMail(data['email']);
    }
  }

  void approveRequest(Request request) async {
    QuerySnapshot qsApprove = await _db
        .collection('users')
        .where('email', isEqualTo: currentUser.email)
        .getDocuments();
    DocumentReference refApprove = qsApprove.documents[0].reference;
    await _db
        .collection('requests')
        .document(request.getDBReference())
        .updateData(
            {'approved': true, 'open': false, 'approved_by': refApprove});
  }

  void denyRequest(Request request) async {
    QuerySnapshot qsApprove = await _db
        .collection('users')
        .where('email', isEqualTo: currentUser.email)
        .getDocuments();
    DocumentReference refApprove = qsApprove.documents[0].reference;
    await _db
        .collection('requests')
        .document(request.getDBReference())
        .updateData(
            {'approved': false, 'open': false, 'approved_by': refApprove});
  }
}
