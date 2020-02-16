
import 'dart:convert';
import 'package:ignite/backendservices/backend_departments_service.dart';
import '../../models/department.dart';
import '../departments_controller.dart';

class DepartmentsApiController implements DepartmentsController {
  BackendDepartmentsServices _services;

  DepartmentsApiController(String ip) {
    _services = new BackendDepartmentsServices(ip);
  }

  @override
  Future<List<Department>> getDepartments() async {
    String controllerJson = await _services.getDepartments();
    var parsedJson = json.decode(controllerJson);
    List<Department> departments = new List<Department>();
    for (var department in parsedJson) {
      departments.add(new Department(
        department['id'],
        department['cap'],
        department['city'],
        department['geopoint']['latitude'],
        department['geopoint']['longitude'],
        department['mail'],
        department['phoneNumber'],
        department['streetName'],
        department['streetNumber'],
      ));
    }
    return departments;
  }
}
