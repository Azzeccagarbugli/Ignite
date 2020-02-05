import '../../dbcontrollers/firebasedbcontrollers/departments_firebasecontroller.dart';
import '../../factories/controllerfactories/firebasecontrollerfactory.dart';
import '../../models/department.dart';
import '../departments_services.dart';

class FirebaseDepartmentsServices implements DepartmentsServices {
  FirebaseDepartmentsController _departmentsController =
      FirebaseControllerFactory().getDepartmentsController();
  @override
  Future<List<Department>> getDepartments() async {
    return await _departmentsController.getAll();
  }
}
