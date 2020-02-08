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
        data['last_check'].toDate(),
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
  Future<Hydrant> insert(Hydrant hydrant) async {
    DocumentReference ref = await this.db.collection('hydrants').add({
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
    return this.get(ref.documentID);
  }

  @override
  Future<Hydrant> update(Hydrant hydrant) async {
    await this.db.collection('hydrants').document(hydrant.getId()).updateData({
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
    return this.get(hydrant.getId());
  }
}
