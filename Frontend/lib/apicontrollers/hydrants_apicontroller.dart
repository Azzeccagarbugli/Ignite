import 'package:http/http.dart' as http;
import 'dart:async';

class HydrantsApiController {
  String _ip;
  String _baseUrl;
  Map<String, String> _header;
  HydrantsApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/hydrant";
    _header = {
      "content-type": "application/json",
      "accept": "application/json"
    };
  }

//List<Hydrant>
  Future<String> getApprovedHydrants() async {
    http.Response res = await http.get(
      "$_baseUrl/approved",
      headers: _header,
    );
    return res.body;
  }

//Hydrant - body = "" -> null
  Future<String> getHydrantById(String id) async {
    http.Response res = await http.get(
      "$_baseUrl/id/$id",
      headers: _header,
    );
    return res.body;
  }
}
