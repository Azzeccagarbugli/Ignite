import 'package:ignite/dbcontrollers/dbcontroller.dart';
import 'package:ignite/dbcontrollers/firebasedbcontrollers/departments_firebasecontroller.dart';
import 'package:ignite/dbcontrollers/firebasedbcontrollers/hydrants_firebasecontroller.dart';
import 'package:ignite/dbcontrollers/firebasedbcontrollers/requests_firebasecontroller.dart';
import 'package:ignite/dbcontrollers/firebasedbcontrollers/users_firebasecontroller.dart';
import 'package:ignite/dbcontrollers/firebasedbcontrollers/values_firebasecontroller.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/models/values.dart';

import 'controllerfactory.dart';

class FirebaseControllerFactory implements ControllerFactory {
  static final FirebaseControllerFactory _singleton =
      FirebaseControllerFactory._internal();

  factory FirebaseControllerFactory() {
    return _singleton;
  }

  FirebaseControllerFactory._internal();

  @override
  DbController<Department> getDepartmentsController() {
    return new FirebaseDepartmentsController();
  }

  @override
  DbController<Hydrant> getHydrantsController() {
    return new FirebaseHydrantsController();
  }

  @override
  DbController<Request> getRequestsController() {
    return new FirebaseRequestController();
  }

  @override
  DbController<User> getUsersController() {
    return new FirebaseUsersController();
  }

  @override
  DbController<Values> getValuesController() {
    return new FirebaseValuesController();
  }
}
