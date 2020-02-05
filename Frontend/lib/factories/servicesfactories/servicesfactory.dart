import '../../services/departments_services.dart';
import '../../services/hydrants_services.dart';
import '../../services/requests_services.dart';
import '../../services/users_services.dart';
import '../../services/values_services.dart';

abstract class ServicesFactory {
  DepartmentsServices getDepartmentsServices();
  HydrantsServices getHydrantsServices();
  RequestsServices getRequestsServices();
  UsersServices getUsersServices();
  ValuesServices getValuesServices();
}
