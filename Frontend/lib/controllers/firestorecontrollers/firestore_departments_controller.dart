import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/factories/repositoriesfactories/firestorerepositoriesfactory.dart';

import '../../models/department.dart';
import '../departments_controller.dart';

class FirestoreDepartmentsController implements DepartmentsController {
  DbRepository<Department> _departmentsServices =
      FirestoreRepositoriesFactory().getDepartmentsRepository();
  @override
  Future<List<Department>> getDepartments() async {
    return await _departmentsServices.getAll();
  }
}
