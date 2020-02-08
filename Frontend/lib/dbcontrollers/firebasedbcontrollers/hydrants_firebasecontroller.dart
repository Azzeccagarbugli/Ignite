import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/hydrant.dart';
import '../firebasecontroller.dart';

class FirebaseHydrantsController extends FirebaseController<Hydrant> {
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
        data['last_check'],
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
  Future<Hydrant> insert(Hydrant object) async {
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
  Future<Hydrant> update(Hydrant object) async {
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
