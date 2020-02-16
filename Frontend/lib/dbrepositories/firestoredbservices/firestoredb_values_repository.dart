import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignite/dbrepositories/firestoredbrepository.dart';

import '../../models/values.dart';

class FirestoreDbValuesRepository extends FirestoreDbRepository<Values> {
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
    if (ds == null) {
      return null;
    }
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
    List<Values> values = new List<Values>();
    for (DocumentSnapshot ds in qsValues.documents) {
      Values v = await this.get(ds.documentID);
      values.add(v);
    }
    return values;
  }

  @override
  Future<Values> insert(Values object) async {
    if (object == null) {
      return null;
    }
    DocumentReference ref = await this.db.collection('enums').add({
      'name': object.getName(),
      'values': object.getValues(),
    });
    return this.get(ref.documentID);
  }

  @override
  Future<Values> update(Values object) async {
    if (object == null) {
      return null;
    }
    await this.db.collection('enums').document(object.getId()).updateData({
      'name': object.getName(),
      'values': object.getValues(),
    });
    return this.get(object.getId());
  }

  @override
  Future<bool> exists(String id) async {
    DocumentSnapshot ds = await this.db.collection('enums').document(id).get();
    return (ds == null) ? false : true;
  }
}
