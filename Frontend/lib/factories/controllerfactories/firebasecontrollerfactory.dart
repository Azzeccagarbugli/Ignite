import '../../dbcontrollers/dbcontroller.dart';
import '../../dbcontrollers/firebasedbcontrollers/departments_firebasecontroller.dart';
import '../../dbcontrollers/firebasedbcontrollers/hydrants_firebasecontroller.dart';
import '../../dbcontrollers/firebasedbcontrollers/requests_firebasecontroller.dart';
import '../../dbcontrollers/firebasedbcontrollers/users_firebasecontroller.dart';
import '../../dbcontrollers/firebasedbcontrollers/values_firebasecontroller.dart';
import '../../models/department.dart';
import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../../models/user.dart';
import '../../models/values.dart';
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
