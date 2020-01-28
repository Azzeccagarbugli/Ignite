import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignite/dbcontrollers/firebasecontroller.dart';
import 'package:ignite/models/user.dart';

class UsersFirebaseController extends FirebaseController<User> {
  @override
  Future<void> delete(String id) async {
    await this.db.collection('users').document(id).delete();
  }

  @override
  Future<void> deleteAll() async {
    this.db.collection('users').getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<User> get(String id) async {
    DocumentSnapshot ds = await this.db.collection('users').document(id).get();
    Map<String, dynamic> data = ds.data;
    if (data['isFireman'] == 'true') {
      DocumentReference department = data['department'];
      return new User(
        id,
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
      );
    } else {
      return new User.citizen(
        id,
        data['email'],
        data['isFirstAccess'],
        data['isGoogle'],
        data['isFacebook'],
      );
    }
  }

  @override
  Future<List<User>> getAll() async {
    QuerySnapshot qsUsers = await this.db.collection('users').getDocuments();
    List<User> users = new List<User>();
    for (DocumentSnapshot ds in qsUsers.documents) {
      User u = await this.get(ds.documentID);
      users.add(u);
    }
    return users;
  }

  @override
  Future<User> insert(User object) async {
    DocumentReference ref = await this.db.collection('users').add({
      'birthday': object.getBirthday(),
      'cap': object.getCap(),
      'department': object.getDepartmentId(),
      'email': object.getMail(),
      'isFacebook': object.isFacebook(),
      'isFireman': object.isFireman(),
      'isFirstAccess': object.isFirstAccess(),
      'isGoogle': object.isGoogle(),
      'name': object.getName(),
      'residence_street_number': object.getStreetNumber(),
      'surname': object.getSurname(),
    });
    return this.get(ref.documentID);
  }

  @override
  Future<User> update(User object) async {
    await this.db.collection('hydrants').document(object.getId()).updateData({
      'birthday': object.getBirthday(),
      'cap': object.getCap(),
      'department': object.getDepartmentId(),
      'email': object.getMail(),
      'isFacebook': object.isFacebook(),
      'isFireman': object.isFireman(),
      'isFirstAccess': object.isFirstAccess(),
      'isGoogle': object.isGoogle(),
      'name': object.getName(),
      'residence_street_number': object.getStreetNumber(),
      'surname': object.getSurname(),
    });
    return this.get(object.getId());
  }
}
