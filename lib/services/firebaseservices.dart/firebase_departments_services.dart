import 'package:ignite/dbcontrollers/firebasedbcontrollers/departments_firebasecontroller.dart';
import 'package:ignite/factories/controllerfactories/firebasecontrollerfactory.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/services/departments_services.dart';

class FirebaseDepartmentsServices implements DepartmentsServices {
  FirebaseDepartmentsController _departmentsController =
      FirebaseControllerFactory().getDepartmentsController();
  @override
  Future<List<Department>> getDepartments() async {
    return await _departmentsController.getAll();
  }
}
