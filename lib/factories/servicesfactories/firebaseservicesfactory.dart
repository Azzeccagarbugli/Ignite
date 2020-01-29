import 'package:ignite/factories/servicesfactories/servicesfactory.dart';
import 'package:ignite/services/departments_services.dart';
import 'package:ignite/services/firebaseservices.dart/firebase_departments_services.dart';
import 'package:ignite/services/firebaseservices.dart/firebase_hydrants_services.dart';
import 'package:ignite/services/firebaseservices.dart/firebase_requests_services.dart';
import 'package:ignite/services/firebaseservices.dart/firebase_users_services.dart';
import 'package:ignite/services/firebaseservices.dart/firebase_values_services.dart';
import 'package:ignite/services/hydrants_services.dart';
import 'package:ignite/services/requests_services.dart';
import 'package:ignite/services/users_services.dart';
import 'package:ignite/services/values_services.dart';

class FirebaseServicesFactory implements ServicesFactory {
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
