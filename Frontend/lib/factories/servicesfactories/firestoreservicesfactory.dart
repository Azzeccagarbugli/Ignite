import 'package:ignite/services/firestoreservices/firestore_departments_services.dart';
import 'package:ignite/services/firestoreservices/firestore_hydrants_services.dart';
import 'package:ignite/services/firestoreservices/firestore_requests_services.dart';
import 'package:ignite/services/firestoreservices/firestore_users_services.dart';
import 'package:ignite/services/firestoreservices/firestore_values_services.dart';

import '../../services/departments_services.dart';
import '../../services/hydrants_services.dart';
import '../../services/requests_services.dart';
import '../../services/users_services.dart';
import '../../services/values_services.dart';
import 'servicesfactory.dart';

class FirestoreServicesFactory extends ServicesFactory {
  static final FirestoreServicesFactory _singleton =
      FirestoreServicesFactory._internal();

  factory FirestoreServicesFactory() {
    return _singleton;
  }

  FirestoreServicesFactory._internal();

  @override
  DepartmentsServices getDepartmentsServices() {
    return new FirestoreDepartmentsServices();
  }

  @override
  HydrantsServices getHydrantsServices() {
    return new FirestoreHydrantsServices();
  }

  @override
  RequestsServices getRequestsServices() {
    return new FirestoreRequestsServices();
  }

  @override
  UsersServices getUsersServices() {
    return new FirestoreUsersServices();
  }

  @override
  ValuesServices getValuesServices() {
    return new FirestoreValuesServices();
  }
}
