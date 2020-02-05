import '../../dbcontrollers/dbcontroller.dart';
import '../../models/department.dart';
import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../../models/user.dart';
import '../../models/values.dart';

abstract class ControllerFactory {
  DbController<User> getUsersController();
  DbController<Hydrant> getHydrantsController();
  DbController<Request> getRequestsController();
  DbController<Department> getDepartmentsController();
  DbController<Values> getValuesController();
}
