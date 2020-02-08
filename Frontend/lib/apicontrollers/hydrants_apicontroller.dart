import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:ignite/models/hydrant.dart';

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

  Future<String> getApprovedHydrants() async {
    http.Response res = await http.get(
      "$_baseUrl/approved",
      headers: _header,
    );
    return res.body;
  }

  Future<String> getHydrantById(String id) async {
    http.Response res = await http.get(
      "$_baseUrl/id/$id",
      headers: _header,
    );
    return res.body;
  }

  Future<String> addHydrant(Hydrant newHydrant) async {
    http.Response res = await http.post(Uri.encodeFull("$_baseUrl/new"),
        body: json.encode({
          "attacks": [
            newHydrant.getFirstAttack(),
            newHydrant.getSecondAttack()
          ],
          "bar": newHydrant.getPressure(),
          "cap": newHydrant.getCap(),
          "city": newHydrant.getCity(),
          "color": newHydrant.getColor(),
          "geopoint": {
            "latitude": newHydrant.getLat(),
            "longitude": newHydrant.getLong()
          },
          "lastCheck": newHydrant.getLastCheck(),
          "notes": newHydrant.getNotes(),
          "streetNumber": newHydrant.getNumber(),
          "opening": newHydrant.getOpening(),
          "streetName": newHydrant.getStreet(),
          "type": newHydrant.getType(),
          "vehicle": newHydrant.getVehicle(),
        }),
        headers: _header);
    return res.body;
  }

  Future<String> deleteHydrant(String id) async {
    http.Response res = await http.delete(
      "$_baseUrl/delete/$id",
      headers: _header,
    );
    return res.body;
  }

  Future<String> updateHydrant(Hydrant updatedHydrant) async {
    http.Response res = await http.post(Uri.encodeFull("$_baseUrl/update"),
        body: json.encode({
          "attacks": [
            updatedHydrant.getFirstAttack(),
            updatedHydrant.getSecondAttack()
          ],
          "bar": updatedHydrant.getPressure(),
          "cap": updatedHydrant.getCap(),
          "city": updatedHydrant.getCity(),
          "color": updatedHydrant.getColor(),
          "geopoint": {
            "latitude": updatedHydrant.getLat(),
            "longitude": updatedHydrant.getLong()
          },
          "lastCheck": updatedHydrant.getLastCheck(),
          "notes": updatedHydrant.getNotes(),
          "streetNumber": updatedHydrant.getNumber(),
          "opening": updatedHydrant.getOpening(),
          "streetName": updatedHydrant.getStreet(),
          "type": updatedHydrant.getType(),
          "vehicle": updatedHydrant.getVehicle(),
        }),
        headers: _header);
    return res.body;
  }
}
