import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';

class DbProvider extends ChangeNotifier {
  final Firestore _db = Firestore.instance;

  Future<bool> isCurrentUserFireman(FirebaseUser curUser) async {
    QuerySnapshot querySnap = await _db
        .collection('users')
        .where('email', isEqualTo: "${curUser.email}")
        .getDocuments();
    return querySnap.documents[0]["isFireman"];
  }

  Future<bool> isFirstAccess(FirebaseUser curUser) async {
    QuerySnapshot querySnap = await _db
        .collection('users')
        .where('email', isEqualTo: "${curUser.email}")
        .getDocuments();
    return querySnap.documents[0]["isFirstAccess"];
  }

  void setFirstAccessToFalse(FirebaseUser curUser) async {
    QuerySnapshot querySnap = await _db
        .collection('users')
        .where('email', isEqualTo: "${curUser.email}")
        .getDocuments();
    querySnap.documents[0].documentID;
    await _db
        .collection('users')
        .document(querySnap.documents[0].documentID)
        .updateData({'isFirstAccess': false});
  }

  Future<List<Request>> getRequests() async {
    QuerySnapshot qsRequests = await _db.collection('requests').getDocuments();
    List<Request> requests = new List<Request>();

    for (DocumentSnapshot ds in qsRequests.documents) {
      DocumentReference approvedBy = ds.data['approved_by'];
      DocumentReference hydrant = ds.data['hydrant'];
      DocumentReference requestedBy = ds.data['requested_by'];
      Request newRequest = Request(
        ds.documentID,
        ds.data['approved'],
        ds.data['open'],
        (approvedBy == null) ? null : approvedBy.documentID,
        hydrant.documentID,
        requestedBy.documentID,
      );
      requests.add(newRequest);
    }
    return requests;
  }

  Future<List<Request>> getRequestsByDistance(LatLng position) async {
    QuerySnapshot qsRequests = await _db.collection('requests').getDocuments();
    List<Request> requests = new List<Request>();

    for (DocumentSnapshot ds in qsRequests.documents) {
      DocumentReference approvedBy = ds.data['approved_by'];
      DocumentReference hydrant = ds.data['hydrant'];
      DocumentReference requestedBy = ds.data['requested_by'];
      Request newRequest = Request(
        ds.documentID,
        ds.data['approved'],
        ds.data['open'],
        (approvedBy == null) ? null : approvedBy.documentID,
        hydrant.documentID,
        requestedBy.documentID,
      );
      Hydrant newHydrant =
          await getHydrantByDocumentReference(newRequest.getHydrantId());
      double distance = await Geolocator().distanceBetween(position.latitude,
          position.longitude, newHydrant.getLat(), newHydrant.getLong());
      if (distance < 20000) {
        requests.add(newRequest);
      }
    }
    return requests;
  }

  Future<List<Request>> getPendingRequestsByDistance(LatLng position) async {
    List<Request> requests = await this.getRequestsByDistance(position);
    List<Request> pending = new List<Request>();
    for (Request re in requests) {
      if (re.isOpen() && !re.getApproved()) {
        pending.add(re);
      }
    }
    return pending;
  }

  Future<List<Request>> getApprovedRequests() async {
    List<Request> requests = await this.getRequests();
    List<Request> approved = new List<Request>();
    for (Request re in requests) {
      if (!re.isOpen() && re.getApproved()) {
        approved.add(re);
      }
    }
    return approved;
  }

  Future<List<Hydrant>> getApprovedHydrants() async {
    List<Hydrant> hydrants = new List<Hydrant>();
    List<Request> requests = await getApprovedRequests();
    for (Request r in requests) {
      Hydrant newHydrant =
          await getHydrantByDocumentReference(r.getHydrantId());
      hydrants.add(newHydrant);
    }
    return hydrants;
  }

  Future<List<Department>> getDepartments() async {
    List<Department> deps = new List<Department>();
    QuerySnapshot qsDepartments =
        await _db.collection('departments').getDocuments();
    for (DocumentSnapshot ds in qsDepartments.documents) {
      GeoPoint geo = ds.data['geopoint'];
      deps.add(Department(
        ds.documentID,
        ds.data['cap'],
        ds.data['city'],
        geo.latitude,
        geo.longitude,
        ds.data['mail'],
        ds.data['phone_number'],
        ds.data['street'],
        ds.data['number'],
      ));
    }
    return deps;
  }

  Future<List<String>> _getEnumByName(String name) async {
    List<String> attacks = new List<String>();
    QuerySnapshot qs = await _db
        .collection('enums')
        .where('name', isEqualTo: name)
        .getDocuments();
    DocumentSnapshot document = qs.documents[0];
    for (String value in document['values']) {
      attacks.add(value);
    }
    return attacks;
  }

  Future<List<String>> getColors() async {
    return _getEnumByName('color');
  }

  Future<List<String>> getAttacks() async {
    return _getEnumByName('attack');
  }

  Future<List<String>> getOpenings() async {
    return _getEnumByName('opening');
  }

  Future<List<String>> getVehicles() async {
    return _getEnumByName('vehicle');
  }

  Future<List<String>> getTypes() async {
    return _getEnumByName('type');
  }

  Future<List<String>> getPressures() async {
    return _getEnumByName('pressure');
  }

  Future<Request> getRequestByDocumentReference(String ref) async {
    DocumentSnapshot ds = await _db.collection('requests').document(ref).get();
    Map<String, dynamic> data = ds.data;
    DocumentReference approvedBy = data['approved_by'];
    DocumentReference hydrant = data['hydrant'];
    DocumentReference requestedBy = data['requested_by'];
    return new Request(ref, data['approved'], data["open"],
        approvedBy.documentID, hydrant.documentID, requestedBy.documentID);
  }

  Future<Hydrant> getHydrantByDocumentReference(String ref) async {
    DocumentSnapshot ds = await _db.collection('hydrants').document(ref).get();
    Map<String, dynamic> data = ds.data;
    Timestamp time = data['last_check'];
    GeoPoint geo = data['geopoint'];
    return new Hydrant(
        ref,
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
        data['street'],
        data['number'],
        data['type'],
        data['vehicle']);
  }

  Future<User> getUserByDocumentReference(String ref) async {
    DocumentSnapshot ds = await _db.collection('users').document(ref).get();
    Map<String, dynamic> data = ds.data;
    if (ds.data['isFireman'] == 'true') {
      DocumentReference department = data['department'];

      return new User(
          ref,
          data['email'],
          data['birthday'],
          data['name'],
          data['surname'],
          data['residence_street_number'],
          data['cap'],
          department.documentID,
          data['isFirstAccess'],
          data['isGoogle'],
          data['isFacebook'],
          data['isFireman']);
    } else {
      return new User(
          ref,
          data['email'],
          null,
          null,
          null,
          null,
          null,
          null,
          data['isFirstAccess'],
          data['isGoogle'],
          data['isFacebook'],
          data['isFireman']);
    }
  }

  Future<User> getUserByMail(String mail) async {
    QuerySnapshot qsReq = await _db
        .collection('users')
        .where('email', isEqualTo: mail)
        .getDocuments();
    DocumentSnapshot user = qsReq.documents[0];
    DocumentReference ref = user.reference;
    Map<String, dynamic> data = user.data;
    if (user.data['isFireman'] == 'true') {
      DocumentReference department = data['department'];
      return new User(
          ref.documentID,
          data['email'],
          data['birthday'],
          data['name'],
          data['surname'],
          data['residence_street_number'],
          data['cap'],
          department.documentID,
          data['isFirstAccess'],
          data['isGoogle'],
          data['isFacebook'],
          data['isFireman']);
    } else {
      return new User(
          ref.documentID,
          data['email'],
          null,
          null,
          null,
          null,
          null,
          null,
          data['isFirstAccess'],
          data['isGoogle'],
          data['isFacebook'],
          data['isFireman']);
    }
  }

  void approveRequest(
      Hydrant hydrant, Request request, FirebaseUser curUser) async {
    await _db.collection('hydrants').document(hydrant.getId()).updateData({
      'attack': [hydrant.getFirstAttack(), hydrant.getSecondAttack()],
      'bar': hydrant.getPressure(),
      'cap': hydrant.getCap(),
      'city': hydrant.getCity(),
      'color': hydrant.getColor(),
      'geopoint': GeoPoint(hydrant.getLat(), hydrant.getLong()),
      'last_check': hydrant.getLastCheck(),
      'notes': hydrant.getNotes(),
      'opening': hydrant.getOpening(),
      'street': hydrant.getStreet(),
      'number': hydrant.getNumber(),
      'type': hydrant.getType(),
      'vehicle': hydrant.getVehicle(),
    });

    QuerySnapshot qsApprove = await _db
        .collection('users')
        .where('email', isEqualTo: curUser.email)
        .getDocuments();

    DocumentReference refApprove = qsApprove.documents[0].reference;
    await _db.collection('requests').document(request.getId()).updateData(
        {'approved': true, 'open': false, 'approved_by': refApprove});
  }

  void denyRequest(Request request) async {
    await _db.collection('hydrants').document(request.getHydrantId()).delete();
    await _db.collection('requests').document(request.getId()).delete();
  }

  void addRequest(Hydrant hydrant, bool isFireman, FirebaseUser curUser) async {
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
      'street': hydrant.getStreet(),
      'number': hydrant.getNumber(),
      'type': hydrant.getType(),
      'vehicle': hydrant.getVehicle(),
    });

    QuerySnapshot qsReq = await _db
        .collection('users')
        .where('email', isEqualTo: curUser.email)
        .getDocuments();
    DocumentReference reqBy = qsReq.documents[0].reference;
    DocumentReference newRequest = await _db.collection('requests').add({
      'approved': isFireman,
      'hydrant': newHydrant,
      'open': !isFireman,
      'requested_by': reqBy,
    });
    if (isFireman) {
      await _db
          .collection('requests')
          .document(newRequest.documentID)
          .updateData({'approved_by': reqBy});
    }
  }
}
