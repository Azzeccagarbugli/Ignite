import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';

class RequestsApiController {
  String _ip;
  String _baseUrl;
  Map<String, String> _header;
  RequestsApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/request";
    _header = {
      "content-type": "application/json",
      "accept": "application/json"
    };
  }

//Request - body = "" -> null
  Future<String> addRequest(Hydrant newHydrant, String userId) async {
    http.Response res = await http.post(Uri.encodeFull("$_baseUrl/new/$userId"),
        headers: _header,
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
        }));
    return res.body;
  }

//bool
  Future<String> approveRequest(
      Hydrant hydrant, String requestId, String userId) async {
    http.Response res =
        await http.post(Uri.encodeFull("$_baseUrl/approve/$requestId&$userId"),
            headers: _header,
            body: json.encode({
              "attacks": [hydrant.getFirstAttack(), hydrant.getSecondAttack()],
              "bar": hydrant.getPressure(),
              "cap": hydrant.getCap(),
              "city": hydrant.getCity(),
              "color": hydrant.getColor(),
              "geopoint": {
                "latitude": hydrant.getLat(),
                "longitude": hydrant.getLong()
              },
              "lastCheck": hydrant.getLastCheck(),
              "notes": hydrant.getNotes(),
              "streetNumber": hydrant.getNumber(),
              "opening": hydrant.getOpening(),
              "streetName": hydrant.getStreet(),
              "type": hydrant.getType(),
              "vehicle": hydrant.getVehicle(),
            }));
    return res.body;
  }

//bool
  Future<String> denyRequest(String requestId, String userId) async {
    http.Response res = await http.post(
      Uri.encodeFull("$_baseUrl/deny/$requestId&$userId"),
      headers: _header,
    );
    return res.body;
  }

  Future<String> getApprovedRequests() async {
    http.Response res = await http.get(
      "$_baseUrl/approved",
      headers: _header,
    );
    return res.body;
  }

//List<Request>
  Future<String> getPendingRequestsByDistance(
      double latitude, double longitude) async {
    http.Response res = await http.get(
      "$_baseUrl/pending/$latitude&$longitude&10000.0",
      headers: _header,
    );
    return res.body;
  }

//List<Request>
  Future<String> getRequests() async {
    http.Response res = await http.get(
      "$_baseUrl/all",
      headers: _header,
    );
    return res.body;
  }

//List<Request>
  Future<String> getRequestsByDistance(
      double latitude, double longitude) async {
    http.Response res = await http.get(
      "$_baseUrl/all/$latitude&$longitude&10000.0",
      headers: _header,
    );
    return res.body;
  }
}
