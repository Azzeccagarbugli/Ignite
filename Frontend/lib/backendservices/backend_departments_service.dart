import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:ignite/backendservices/basic_auth_config.dart';

class BackendDepartmentsServices {
  String _ip;
  String _baseUrl;

  BackendDepartmentsServices(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/department";
  }

//List<Department>
  Future<String> getDepartments() async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get("$_baseUrl/all", headers: header);
    return res.body;
  }
}
