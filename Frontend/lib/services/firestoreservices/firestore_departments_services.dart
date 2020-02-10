import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/factories/repositoriesfactories/firestorerepositoriesfactory.dart';

import '../../models/department.dart';
import '../departments_services.dart';

class FirestoreDepartmentsServices implements DepartmentsServices {
  DbRepository<Department> _departmentsController =
      FirestoreRepositoriesFactory().getDepartmentsRepository();
  @override
  Future<List<Department>> getDepartments() async {
    return await _departmentsController.getAll();
  }
}
