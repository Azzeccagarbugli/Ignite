import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:ignite/apicontrollers/basic_auth_config.dart';

class ValuesApiController {
  String _ip;
  String _baseUrl;

  ValuesApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/values";
  }

  Future<String> getAttacks() async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/attacks",
      headers: header,
    );
    return res.body;
  }

  Future<String> getColors() async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/colors",
      headers: header,
    );
    return res.body;
  }

  Future<String> getOpenings() async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/openings",
      headers: header,
    );
    return res.body;
  }

  Future<String> getPressures() async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/pressures",
      headers: header,
    );
    return res.body;
  }

  Future<String> getTypes() async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/types",
      headers: header,
    );
    return res.body;
  }

  Future<String> getVehicles() async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/vehicles",
      headers: header,
    );
    return res.body;
  }
}
