import 'package:ignite/controllers/departments_controller.dart';
import 'package:ignite/controllers/firestorecontrollers/firestore_departments_controller.dart';
import 'package:ignite/controllers/firestorecontrollers/firestore_hydrants_controller.dart';
import 'package:ignite/controllers/firestorecontrollers/firestore_requests_controller.dart';
import 'package:ignite/controllers/firestorecontrollers/firestore_users_controller.dart';
import 'package:ignite/controllers/firestorecontrollers/firestore_values_controller.dart';
import 'package:ignite/controllers/hydrants_controller.dart';
import 'package:ignite/controllers/requests_controller.dart';
import 'package:ignite/controllers/users_controller.dart';
import 'package:ignite/controllers/values_controller.dart';
import 'controllersfactory.dart';

class FirestoreControllersFactory extends ControllersFactory {
  static final FirestoreControllersFactory _singleton =
      FirestoreControllersFactory._internal();

  factory FirestoreControllersFactory() {
    return _singleton;
  }

  FirestoreControllersFactory._internal();

  @override
  DepartmentsController getDepartmentsController() {
    return new FirestoreDepartmentsController();
  }

  @override
  HydrantsController getHydrantsController() {
    return new FirestoreHydrantsController();
  }

  @override
  RequestsController getRequestsController() {
    return new FirestoreRequestsController();
  }

  @override
  UsersController getUsersController() {
    return new FirestoreUsersController();
  }

  @override
  ValuesController getValuesController() {
    return new FirestoreValuesController();
  }
}
