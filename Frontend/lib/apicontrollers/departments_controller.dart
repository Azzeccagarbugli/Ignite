import 'package:http/http.dart' as http;
import 'dart:async';

class DepartmentsApiController {
  String _ip;
  String _baseUrl;
  Map<String, String> _header;
  DepartmentsApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/department";
    _header = {
      "content-type": "application/json",
      "accept": "application/json"
    };
  }

  Future<String> getDepartments() async {
    http.Response res = await http.get("$_baseUrl/all", headers: _header);
    return res.body;
  }
}
