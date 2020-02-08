import '../../dbcontrollers/firebasedbcontrollers/departments_firebasecontroller.dart';
import '../../models/department.dart';
import '../departments_services.dart';

class FirebaseDepartmentsServices implements DepartmentsServices {
  FirebaseDepartmentsController _departmentsController =
      new FirebaseDepartmentsController();
  @override
  Future<List<Department>> getDepartments() async {
    return await _departmentsController.getAll();
  }
}
