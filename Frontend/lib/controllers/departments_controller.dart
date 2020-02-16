import '../models/department.dart';

abstract class DepartmentsController {
  Future<List<Department>> getDepartments();
}
