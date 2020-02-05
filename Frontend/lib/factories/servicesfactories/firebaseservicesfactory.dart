

import '../../services/departments_services.dart';
import '../../services/firebaseservices.dart/firebase_departments_services.dart';
import '../../services/firebaseservices.dart/firebase_hydrants_services.dart';
import '../../services/firebaseservices.dart/firebase_requests_services.dart';
import '../../services/firebaseservices.dart/firebase_users_services.dart';
import '../../services/firebaseservices.dart/firebase_values_services.dart';
import '../../services/hydrants_services.dart';
import '../../services/requests_services.dart';
import '../../services/users_services.dart';
import '../../services/values_services.dart';
import 'servicesfactory.dart';

class FirebaseServicesFactory extends ServicesFactory {
  static final FirebaseServicesFactory _singleton =
      FirebaseServicesFactory._internal();

  factory FirebaseServicesFactory() {
    return _singleton;
  }

  FirebaseServicesFactory._internal();

  @override
  DepartmentsServices getDepartmentsServices() {
    return new FirebaseDepartmentsServices();
  }

  @override
  HydrantsServices getHydrantsServices() {
    return new FirebaseHydrantsServices();
  }

  @override
  RequestsServices getRequestsServices() {
    return new FirebaseRequestsServices();
  }

  @override
  UsersServices getUsersServices() {
    return new FirebaseUsersServices();
  }

  @override
  ValuesServices getValuesServices() {
    return new FirebaseValuesServices();
  }
}
