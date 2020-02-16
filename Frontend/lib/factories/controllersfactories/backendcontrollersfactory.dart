import 'package:ignite/controllers/apicontrollers/departments_apicontroller.dart';
import 'package:ignite/controllers/apicontrollers/hydrants_apicontroller.dart';
import 'package:ignite/controllers/apicontrollers/requests_apicontroller.dart';
import 'package:ignite/controllers/apicontrollers/users_apicontroller.dart';
import 'package:ignite/controllers/apicontrollers/values_apicontroller.dart';
import 'package:ignite/controllers/departments_controller.dart';
import 'package:ignite/controllers/hydrants_controller.dart';
import 'package:ignite/controllers/requests_controller.dart';
import 'package:ignite/controllers/users_controller.dart';
import 'package:ignite/controllers/values_controller.dart';
import 'controllersfactory.dart';

class BackendControllersFactory implements ControllersFactory {
  static final BackendControllersFactory _singleton =
      BackendControllersFactory._internal();
  String _ip;
  factory BackendControllersFactory(String ip) {
    _singleton._ip = ip;
    return _singleton;
  }

  BackendControllersFactory._internal();

  @override
  DepartmentsController getDepartmentsController() {
    return new DepartmentsApiController(this._ip);
  }

  @override
  HydrantsController getHydrantsController() {
    return new HydrantsApiController(this._ip);
  }

  @override
  RequestsController getRequestsController() {
    return new RequestsApiController(this._ip);
  }

  @override
  UsersController getUsersController() {
    return new UsersApiController(this._ip);
  }

  @override
  ValuesController getValuesController() {
    return new ValuesApiController(this._ip);
  }
}
