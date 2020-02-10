import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/models/values.dart';

abstract class RepositoriesFactory {
  DbRepository<Department> getDepartmentsRepository();
  DbRepository<Hydrant> getHydrantsRepository();
  DbRepository<Request> getRequestsRepository();
  DbRepository<User> getUsersRepository();
  DbRepository<Values> getValuesRepository();
}
