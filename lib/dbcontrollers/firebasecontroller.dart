import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignite/dbcontrollers/dbcontroller.dart';

abstract class FirebaseController<T> implements DbController {
  Firestore db = Firestore.instance;
}
