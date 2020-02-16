import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ignite/backendservices/basic_auth_config.dart';
import 'dart:async';

import 'package:ignite/models/hydrant.dart';

class BackendHydrantsServices {
  String _ip;
  String _baseUrl;
  BackendHydrantsServices(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/hydrant";
  }

//List<Hydrant>
  Future<String> getApprovedHydrants() async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/approved",
      headers: header,
    );
    return res.body;
  }

//Hydrant - body = "" -> null
  Future<String> getHydrantById(String id) async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/id/$id",
      headers: header,
    );
    return res.body;
  }

//Hydrant - body = "" -> null
  Future<String> addHydrant(Hydrant newHydrant) async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
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
        headers: header);
    return res.body;
  }

//bool
  Future<String> deleteHydrant(String id) async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.delete(
      "$_baseUrl/delete/$id",
      headers: header,
    );
    return res.body;
  }

//Hydrant - body = "" -> null
  Future<String> updateHydrant(Hydrant updatedHydrant) async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
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
        headers: header);
    return res.body;
  }
}
