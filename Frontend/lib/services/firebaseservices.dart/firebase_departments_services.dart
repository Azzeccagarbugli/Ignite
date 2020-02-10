import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/factories/repositoriesfactories/firebaserepositoriesfactory.dart';

import '../../models/department.dart';
import '../departments_services.dart';

class FirebaseDepartmentsServices implements DepartmentsServices {
  DbRepository<Department> _departmentsController =
      FirebaseRepositoriesFactory().getDepartmentsRepository();
  @override
  Future<List<Department>> getDepartments() async {
    return await _departmentsController.getAll();
  }
}
