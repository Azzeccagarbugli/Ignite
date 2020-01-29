import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignite/dbcontrollers/firebasecontroller.dart';
import 'package:ignite/models/values.dart';

class FirebaseValuesController extends FirebaseController<Values> {
  @override
  Future<void> delete(String id) async {
    await this.db.collection('enums').document(id).delete();
  }

  @override
  Future<void> deleteAll() async {
    this.db.collection('enums').getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<Values> get(String id) async {
    DocumentSnapshot ds = await this.db.collection('enums').document(id).get();
    Map<String, dynamic> data = ds.data;
    List<String> values = List<String>();
    for (String val in data['values']) {
      values.add(val);
    }
    return new Values(id, data['name'], values);
  }

  @override
  Future<List<Values>> getAll() async {
    QuerySnapshot qsValues = await this.db.collection('enums').getDocuments();
    List<Values> users = new List<Values>();
    for (DocumentSnapshot ds in qsValues.documents) {
      Values v = await this.get(ds.documentID);
      users.add(v);
    }
    return users;
  }

  @override
  Future<Values> insert(Values object) async {
    DocumentReference ref = await this.db.collection('enums').add({
      'name': object.getName(),
      'values': object.getValues(),
    });
    return this.get(ref.documentID);
  }

  @override
  Future<Values> update(Values object) async {
    await this.db.collection('hydrants').document(object.getId()).updateData({
      'name': object.getName(),
      'values': object.getValues(),
    });
    return this.get(object.getId());
  }
}
