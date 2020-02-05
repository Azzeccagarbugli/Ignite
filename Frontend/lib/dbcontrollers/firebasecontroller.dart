import 'package:cloud_firestore/cloud_firestore.dart';

import 'dbcontroller.dart';

abstract class FirebaseController<T> implements DbController<T> {
  Firestore db = Firestore.instance;
}
