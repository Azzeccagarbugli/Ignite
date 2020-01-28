import 'package:ignite/dbcontrollers/dbcontroller.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/models/values.dart';

abstract class DbFactory {
  DbController<User> getUsersController();
  DbController<Hydrant> getHydrantsController();
  DbController<Request> getRequestsController();
  DbController<Department> getDepartmentsController();
  DbController<Values> getValuesController();
}
