import 'package:ignite/models/department.dart';
import 'package:ignite/services/departments_services.dart';

class BackendDepartmentsServices implements DepartmentsServices {
  String _ip;
  BackendDepartmentsServices(String ip) {
    this._ip = ip;
  }

  @override
  Future<List<Department>> getDepartments() {
    // TODO: implement getDepartments
    throw UnimplementedError();
  }
}