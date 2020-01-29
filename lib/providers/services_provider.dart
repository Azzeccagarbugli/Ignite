import 'package:flutter/material.dart';
import 'package:ignite/factories/servicesfactories/servicesfactory.dart';
import 'package:ignite/services/departments_services.dart';
import 'package:ignite/services/hydrants_services.dart';
import 'package:ignite/services/requests_services.dart';
import 'package:ignite/services/users_services.dart';
import 'package:ignite/services/values_services.dart';

class ServicesProvider extends ChangeNotifier {
  ServicesFactory _factory;
  DepartmentsServices _departmentsServices;
  HydrantsServices _hydrantsServices;
  RequestsServices _requestsServices;
  UsersServices _usersServices;
  ValuesServices _valuesServices;

  ServicesProvider(ServicesFactory newFactory) {
    this._factory = newFactory;
    this._departmentsServices = this._factory.getDepartmentsServices();
    this._hydrantsServices = this._factory.getHydrantsServices();
    this._requestsServices = this._factory.getRequestsServices();
    this._usersServices = this._factory.getUsersServices();
    this._valuesServices = this._factory.getValuesServices();
  }

  DepartmentsServices getDepartmentsServices() {
    return this._departmentsServices;
  }

  HydrantsServices getHydrantsServices() {
    return this._hydrantsServices;
  }

  RequestsServices getRequestsServices() {
    return this._requestsServices;
  }

  UsersServices getUsersServices() {
    return this._usersServices;
  }

  ValuesServices getValuesServices() {
    return this._valuesServices;
  }
}
