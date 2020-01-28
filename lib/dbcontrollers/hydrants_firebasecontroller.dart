import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignite/dbcontrollers/firebasecontroller.dart';
import 'package:ignite/models/hydrant.dart';

class HydrantsFirebaseController extends FirebaseController<Hydrant> {
  @override
  Future<void> delete(String id) async {
    await this.db.collection('hydrants').document(id).delete();
  }

  @override
  Future<void> deleteAll() async {
    this.db.collection('hydrants').getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<Hydrant> get(String id) async {
    DocumentSnapshot ds =
        await this.db.collection('hydrants').document(id).get();
    Map<String, dynamic> data = ds.data;
    Timestamp time = data['last_check'];
    GeoPoint geo = data['geopoint'];
    return new Hydrant(
        id,
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

  @override
  Future<List<Hydrant>> getAll() async {
    QuerySnapshot qsHydrants =
        await this.db.collection('hydrants').getDocuments();
    List<Hydrant> hydrants = new List<Hydrant>();
    for (DocumentSnapshot ds in qsHydrants.documents) {
      Hydrant h = await this.get(ds.documentID);
      hydrants.add(h);
    }
    return hydrants;
  }

  @override
  Future<Hydrant> insert(object) async {
    DocumentReference ref = await this.db.collection('hydrants').add({
      'attack': [object.getFirstAttack(), object.getSecondAttack()],
      'bar': object.getPressure(),
      'cap': object.getCap(),
      'city': object.getCity(),
      'color': object.getColor(),
      'geopoint': GeoPoint(object.getLat(), object.getLong()),
      'last_check': object.getLastCheck(),
      'notes': object.getNotes(),
      'opening': object.getOpening(),
      'street': object.getStreet(),
      'number': object.getNumber(),
      'type': object.getType(),
      'vehicle': object.getVehicle(),
    });
    return this.get(ref.documentID);
  }

  @override
  Future<Hydrant> update(object) async {
    await this.db.collection('hydrants').document(object.getId()).updateData({
      'attack': [object.getFirstAttack(), object.getSecondAttack()],
      'bar': object.getPressure(),
      'cap': object.getCap(),
      'city': object.getCity(),
      'color': object.getColor(),
      'geopoint': GeoPoint(object.getLat(), object.getLong()),
      'last_check': object.getLastCheck(),
      'notes': object.getNotes(),
      'opening': object.getOpening(),
      'street': object.getStreet(),
      'number': object.getNumber(),
      'type': object.getType(),
      'vehicle': object.getVehicle(),
    });
    return this.get(object.getId());
  }
}
