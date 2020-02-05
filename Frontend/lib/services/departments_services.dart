import '../models/department.dart';

abstract class DepartmentsServices {
  Future<List<Department>> getDepartments();
}
