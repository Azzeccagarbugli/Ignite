

import 'package:ignite/controllers/departments_controller.dart';
import 'package:ignite/controllers/hydrants_controller.dart';
import 'package:ignite/controllers/requests_controller.dart';
import 'package:ignite/controllers/users_controller.dart';
import 'package:ignite/controllers/values_controller.dart';

abstract class ControllersFactory {
  DepartmentsController getDepartmentsController();
  HydrantsController getHydrantsController();
  RequestsController getRequestsController();
  UsersController getUsersController();
  ValuesController getValuesController();
}
