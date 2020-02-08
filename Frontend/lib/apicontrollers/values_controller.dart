import 'package:ignite/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ValuesApiController {
  String _ip;
  String _baseUrl;
  Map<String, String> _header;

  ValuesApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/values";
    _header = {
      "content-type": "application/json",
      "accept": "application/json"
    };
  }

  Future<String> getAttacks() async {
    http.Response res = await http.get(
      "$_baseUrl/attacks",
      headers: _header,
    );
    return res.body;
  }

  Future<String> getColors() async {
    http.Response res = await http.get(
      "$_baseUrl/colors",
      headers: _header,
    );
    return res.body;
  }

  Future<String> getOpenings() async {
    http.Response res = await http.get(
      "$_baseUrl/openings",
      headers: _header,
    );
    return res.body;
  }

  Future<String> getPressures() async {
    http.Response res = await http.get(
      "$_baseUrl/pressures",
      headers: _header,
    );
    return res.body;
  }

  Future<String> getTypes() async {
    http.Response res = await http.get(
      "$_baseUrl/types",
      headers: _header,
    );
    return res.body;
  }

  Future<String> getVehicles() async {
    http.Response res = await http.get(
      "$_baseUrl/vehicles",
      headers: _header,
    );
    return res.body;
  }
}
