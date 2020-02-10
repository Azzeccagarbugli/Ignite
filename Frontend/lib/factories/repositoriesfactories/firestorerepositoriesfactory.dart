import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/dbrepositories/firestoredbcontrollers/firestoredb_departments_repository.dart';
import 'package:ignite/dbrepositories/firestoredbcontrollers/firestoredb_hydrants_repository.dart';
import 'package:ignite/dbrepositories/firestoredbcontrollers/firestoredb_requests_repository.dart';
import 'package:ignite/dbrepositories/firestoredbcontrollers/firestoredb_users_repository.dart';
import 'package:ignite/dbrepositories/firestoredbcontrollers/firestoredb_values_repository.dart';
import 'package:ignite/factories/repositoriesfactories/repositoriesfactory.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/models/values.dart';

class FirestoreRepositoriesFactory implements RepositoriesFactory {
  static final FirestoreRepositoriesFactory _singleton =
      FirestoreRepositoriesFactory._internal();

  factory FirestoreRepositoriesFactory() {
    return _singleton;
  }

  FirestoreRepositoriesFactory._internal();

  @override
  DbRepository<Department> getDepartmentsRepository() {
    return new FirestoreDbDepartmentsRepository();
  }

  @override
  DbRepository<Hydrant> getHydrantsRepository() {
    return new FirestoreDbHydrantsRepository();
  }

  @override
  DbRepository<Request> getRequestsRepository() {
    return new FirestoreDbRequestRepository();
  }

  @override
  DbRepository<User> getUsersRepository() {
    return new FirestoreDbUsersRepository();
  }

  @override
  DbRepository<Values> getValuesRepository() {
    return new FirestoreDbValuesRepository();
  }
}
