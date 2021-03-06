import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignite/dbrepositories/dbrepository.dart';

abstract class FirestoreDbRepository<T> implements DbRepository<T> {
  Firestore db = Firestore.instance;
}
