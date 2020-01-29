import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignite/dbcontrollers/firebasecontroller.dart';
import 'package:ignite/models/request.dart';

class FirebaseRequestController extends FirebaseController<Request> {
  @override
  Future<void> delete(String id) async {
    await this.db.collection('requests').document(id).delete();
  }

  @override
  Future<void> deleteAll() async {
    this.db.collection('requests').getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<Request> get(String id) async {
    DocumentSnapshot ds =
        await this.db.collection('requests').document(id).get();
    Map<String, dynamic> data = ds.data;
    print("ID: $id");
    DocumentReference approvedBy = data['approved_by'];
    DocumentReference hydrant = data['hydrant'];
    DocumentReference requestedBy = data['requested_by'];
    return new Request.complete(
        id,
        data['approved'],
        data["open"],
        (data['approved_by'] == null) ? null : approvedBy.documentID,
        hydrant.documentID,
        requestedBy.documentID);
  }

  @override
  Future<List<Request>> getAll() async {
    QuerySnapshot qsRequests =
        await this.db.collection('requests').getDocuments();
    List<Request> requests = new List<Request>();
    for (DocumentSnapshot ds in qsRequests.documents) {
      Request r = await this.get(ds.documentID);
      requests.add(r);
    }
    return requests;
  }

  @override
  Future<Request> insert(object) async {
    DocumentReference userApBy =
        this.db.collection('users').document(object.getApprovedByUserId());
    DocumentReference userReqBy =
        this.db.collection('users').document(object.getRequestedByUserId());
    DocumentReference hydrant =
        this.db.collection('hydrants').document(object.getHydrantId());
    DocumentReference ref = await this.db.collection('requests').add({
      'approved': object.getApproved(),
      'approved_by': userApBy,
      'hydrant': hydrant,
      'open': object.isOpen(),
      'requested_by': userReqBy,
    });
    return this.get(ref.documentID);
  }

  @override
  Future<Request> update(object) async {
    DocumentReference userApBy =
        this.db.collection('users').document(object.getApprovedByUserId());
    DocumentReference userReqBy =
        this.db.collection('users').document(object.getRequestedByUserId());
    DocumentReference hydrant =
        this.db.collection('hydrants').document(object.getHydrantId());
    this.db.collection('requests').document(object.getId()).updateData({
      'approved': object.getApproved(),
      'approved_by': userApBy,
      'hydrant': hydrant,
      'open': object.isOpen(),
      'requested_by': userReqBy,
    });
    return this.get(object.getId());
  }
}
