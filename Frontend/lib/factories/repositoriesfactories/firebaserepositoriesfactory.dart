import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/dbrepositories/firebasedbcontrollers/firebasedb_departments_repository.dart';
import 'package:ignite/dbrepositories/firebasedbcontrollers/firebasedb_hydrants_repository.dart';
import 'package:ignite/dbrepositories/firebasedbcontrollers/firebasedb_requests_repository.dart';
import 'package:ignite/dbrepositories/firebasedbcontrollers/firebasedb_users_repository.dart';
import 'package:ignite/dbrepositories/firebasedbcontrollers/firebasedb_values_repository.dart';
import 'package:ignite/factories/repositoriesfactories/repositoriesfactory.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/models/values.dart';

class FirebaseRepositoriesFactory implements RepositoriesFactory {
  static final FirebaseRepositoriesFactory _singleton =
      FirebaseRepositoriesFactory._internal();

  factory FirebaseRepositoriesFactory() {
    return _singleton;
  }

  FirebaseRepositoriesFactory._internal();

  @override
  DbRepository<Department> getDepartmentsRepository() {
    return new FirebaseDbDepartmentsRepository();
  }

  @override
  DbRepository<Hydrant> getHydrantsRepository() {
    return new FirebaseDbHydrantsRepository();
  }

  @override
  DbRepository<Request> getRequestsRepository() {
    return new FirebaseDbRequestRepository();
  }

  @override
  DbRepository<User> getUsersRepository() {
    return new FirebaseDbUsersRepository();
  }

  @override
  DbRepository<Values> getValuesRepository() {
    return new FirebaseDbValuesRepository();
  }
}
