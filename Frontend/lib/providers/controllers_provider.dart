import 'package:flutter/material.dart';
import 'package:ignite/controllers/departments_controller.dart';
import 'package:ignite/controllers/hydrants_controller.dart';
import 'package:ignite/controllers/requests_controller.dart';
import 'package:ignite/controllers/users_controller.dart';
import 'package:ignite/controllers/values_controller.dart';
import 'package:ignite/factories/controllersfactories/controllersfactory.dart';

class ControllersProvider extends ChangeNotifier {
  ControllersFactory _factory;

  static final ControllersProvider _singleton = ControllersProvider._internal();

  factory ControllersProvider() {
    return _singleton;
  }

  ControllersProvider._internal();

  void setFactory(ControllersFactory newFactory) {
    this._factory = newFactory;
  }

  DepartmentsController getDepartmentsController() {
    return this._factory.getDepartmentsController();
  }

  HydrantsController getHydrantsController() {
    return this._factory.getHydrantsController();
  }

  RequestsController getRequestsController() {
    return this._factory.getRequestsController();
  }

  UsersController getUsersController() {
    return this._factory.getUsersController();
  }

  ValuesController getValuesController() {
    return this._factory.getValuesController();
  }
}
