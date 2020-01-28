import 'package:ignite/dbcontrollers/dbcontroller.dart';
import 'package:ignite/dbcontrollers/departments_firebasecontroller.dart';
import 'package:ignite/dbcontrollers/hydrants_firebasecontroller.dart';
import 'package:ignite/dbcontrollers/requests_firebasecontroller.dart';
import 'package:ignite/dbcontrollers/users_firebasecontroller.dart';
import 'package:ignite/dbcontrollers/values_firebasecontroller.dart';
import 'package:ignite/factories/dbfactory.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/models/values.dart';

class FirebaseFactory extends DbFactory {
  static final FirebaseFactory _singleton = FirebaseFactory._internal();

  factory FirebaseFactory() {
    return _singleton;
  }

  FirebaseFactory._internal();

  @override
  DbController<Department> getDepartmentsController() {
    return new DepartmentsFirebaseController();
  }

  @override
  DbController<Hydrant> getHydrantsController() {
    return new HydrantsFirebaseController();
  }

  @override
  DbController<Request> getRequestsController() {
    return new RequestFirebaseController();
  }

  @override
  DbController<User> getUsersController() {
    return new UsersFirebaseController();
  }

  @override
  DbController<Values> getValuesController() {
    return new ValuesFirebaseController();
  }
}
