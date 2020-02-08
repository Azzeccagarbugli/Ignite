import 'package:ignite/apicontrollers/departments_controller.dart';
import 'dart:convert';

import '../../models/department.dart';
import '../departments_services.dart';

class BackendDepartmentsServices implements DepartmentsServices {
  DepartmentsApiController _controller;

  BackendDepartmentsServices(String ip) {
    _controller = new DepartmentsApiController(ip);
  }

  @override
  Future<List<Department>> getDepartments() async {
    String controllerJson = await _controller.getDepartments();
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
