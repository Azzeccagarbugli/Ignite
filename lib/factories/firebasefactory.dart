import 'package:ignite/dbcontrollers/dbcontroller.dart';
import 'package:ignite/dbcontrollers/hydrants_firebasecontroller.dart';
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
    // TODO: implement getDepartmentsController
    throw UnimplementedError();
  }

  @override
  DbController getEnumsController() {
    // TODO: implement getEnumsController
    throw UnimplementedError();
  }

  @override
  DbController<Hydrant> getHydrantsController() {
    return new HydrantsFirebaseController();
  }

  @override
  DbController<Request> getRequestsController() {
    // TODO: implement getRequestsController
    throw UnimplementedError();
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
