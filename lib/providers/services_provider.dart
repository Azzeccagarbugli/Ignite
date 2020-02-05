import 'package:flutter/material.dart';
import 'package:ignite/factories/servicesfactories/servicesfactory.dart';
import 'package:ignite/services/departments_services.dart';
import 'package:ignite/services/hydrants_services.dart';
import 'package:ignite/services/requests_services.dart';
import 'package:ignite/services/users_services.dart';
import 'package:ignite/services/values_services.dart';

class ServicesProvider extends ChangeNotifier {
  ServicesFactory _factory;

  static final ServicesProvider _singleton = ServicesProvider._internal();

  factory ServicesProvider() {
    return _singleton;
  }

  ServicesProvider._internal();

  void setFactory(ServicesFactory newFactory) {
    this._factory = newFactory;
  }

  DepartmentsServices getDepartmentsServices() {
    return this._factory.getDepartmentsServices();
  }

  HydrantsServices getHydrantsServices() {
    return this._factory.getHydrantsServices();
  }

  RequestsServices getRequestsServices() {
    return this._factory.getRequestsServices();
  }

  UsersServices getUsersServices() {
    return this._factory.getUsersServices();
  }

  ValuesServices getValuesServices() {
    return this._factory.getValuesServices();
  }
}
