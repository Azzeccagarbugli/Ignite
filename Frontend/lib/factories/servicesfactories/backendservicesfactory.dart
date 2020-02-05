import '../../services/backendservices.dart/backend_departments_services.dart';
import '../../services/backendservices.dart/backend_hydrants_services.dart';
import '../../services/backendservices.dart/backend_requests_services.dart';
import '../../services/backendservices.dart/backend_users_services.dart';
import '../../services/backendservices.dart/backend_values_services.dart';
import '../../services/departments_services.dart';
import '../../services/hydrants_services.dart';
import '../../services/requests_services.dart';
import '../../services/users_services.dart';
import '../../services/values_services.dart';
import 'servicesfactory.dart';

class BackendServicesFactory implements ServicesFactory {
  static final BackendServicesFactory _singleton =
      BackendServicesFactory._internal();
  String _ip;
  factory BackendServicesFactory() {
    return _singleton;
  }

  BackendServicesFactory._internal();

  //To call before using this factory
  void setIpAddress(String ip) {
    this._ip = ip;
  }

  @override
  DepartmentsServices getDepartmentsServices() {
    return new BackendDepartmentsServices(this._ip);
  }

  @override
  HydrantsServices getHydrantsServices() {
    return new BackendHydrantsServices(this._ip);
  }

  @override
  RequestsServices getRequestsServices() {
    return new BackendRequestsServices(this._ip);
  }

  @override
  UsersServices getUsersServices() {
    return new BackendUsersServices(this._ip);
  }

  @override
  ValuesServices getValuesServices() {
    return new BackendValuesServices(this._ip);
  }
}
