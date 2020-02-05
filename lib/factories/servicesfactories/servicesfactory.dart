import 'package:ignite/services/departments_services.dart';
import 'package:ignite/services/hydrants_services.dart';
import 'package:ignite/services/requests_services.dart';
import 'package:ignite/services/users_services.dart';
import 'package:ignite/services/values_services.dart';

abstract class ServicesFactory {
  DepartmentsServices getDepartmentsServices();
  HydrantsServices getHydrantsServices();
  RequestsServices getRequestsServices();
  UsersServices getUsersServices();
  ValuesServices getValuesServices();
}
