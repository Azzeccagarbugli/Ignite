import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:ignite/views/login_screen.dart';
import 'package:theme_provider/theme_provider.dart';

class AppState extends ChangeNotifier {
  AuthResult result;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();

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
      result =
          await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      getUser().then((user) {
        print(user.email);
      });
      //notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> newMailPassword(String mail, String pass) async {
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: pass);
      getUser().then((user) {
        this.updateUsersCollection(user.email, false);
      });
      notifyListeners();
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
      getUser().then((user) {
        this.updateUsersCollection(user.email, false);
      });

      notifyListeners();
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
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> recoverPassword(String currentEmail) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: currentEmail,
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> isCurrentUserFireman() async {
    FirebaseUser user = await this.getUser();
    QuerySnapshot querySnap = await _db
        .collection('users')
        .where('email', isEqualTo: "${user.email}")
        .getDocuments();
    return querySnap.documents[0]["isFireman"];
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
        });
      }
    });
    // notifyListeners();
  }

  ThemeData mainTheme() {
    return ThemeData(
      primaryColor: Colors.red[600],
      accentColor: Colors.grey[200],
      backgroundColor: Colors.white,
      bottomAppBarColor: Colors.red[600],
      buttonColor: Colors.white,
      fontFamily: 'Nunito',
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      primaryColor: Colors.black,
      accentColor: Colors.grey[700],
      backgroundColor: Colors.grey[400],
      bottomAppBarColor: Colors.black,
      buttonColor: Colors.white,
      fontFamily: 'Nunito',
    );
  }

  void toggleTheme(BuildContext context) {
    ThemeProvider.controllerOf(context).nextTheme();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoadingScreen();
    }));
  }

  void logOut(BuildContext context) async {
    await this.accountsLogOut();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }

  Future<void> accountsLogOut() async {
    getUser().then((currentUser) {
      print("L'utente si sta disconnettendo");
      print("Utente prima del logout: ${currentUser.email}");
    });
    await _auth.signOut();
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    notifyListeners();

    print("Utente disconnesso");
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
    getUser().then((currentUser) async {
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
    });
  }

  void denyRequest(Request request) async {
    getUser().then((currentUser) async {
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
    });
  }

  void addRequest(Hydrant hydrant, bool isFireman) async {
    DocumentReference newHydrant = await _db.collection('hydrants').add({
      'attack': [hydrant.getFirstAttack(), hydrant.getSecondAttack()],
      'bar': hydrant.getPressure(),
      'cap': hydrant.getCap(),
      'city': hydrant.getCity(),
      'color': hydrant.getColor(),
      'geopoint': GeoPoint(hydrant.getLat(), hydrant.getLong()),
      'last_check': hydrant.getLastCheck(),
      'notes': hydrant.getNotes(),
      'opening': hydrant.getOpening(),
      'place': hydrant.getPlace(),
      'street_number': hydrant.getStreetNumber(),
      'type': hydrant.getType(),
      'vehicle': hydrant.getVehicle(),
    });
    getUser().then((currentUser) async {
      QuerySnapshot qsReq = await _db
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .getDocuments();
      DocumentReference reqBy = qsReq.documents[0].reference;
      QuerySnapshot qsApp = await _db
          .collection('users')
          .where('email', isEqualTo: 'placeholder')
          .getDocuments();
      DocumentReference appBy = qsApp.documents[0].reference;
      DocumentReference newRequest = await _db.collection('requests').add({
        'approved': isFireman,
        'approved_by': appBy,
        'hydrant': newHydrant,
        'open': !isFireman,
        'requested_by': reqBy,
      });
    });
  }
}
