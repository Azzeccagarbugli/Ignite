import 'package:http/http.dart' as http;
import 'package:ignite/apicontrollers/basic_auth_config.dart';
import 'dart:async';
import 'dart:convert';
import 'package:ignite/models/hydrant.dart';

class RequestsApiController {
  String _ip;
  String _baseUrl;
  RequestsApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/request";
  }

//Request - body = "" -> null
  Future<String> addRequest(Hydrant newHydrant, String userId) async {
    Map<String, String> header = await BasicAuthConfig().getIgniteHeader();
    http.Response res = await http.post(Uri.encodeFull("$_baseUrl/new/$userId"),
        headers: header,
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
          "lastCheck": newHydrant.getLastCheck().toIso8601String(),
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
    Map<String, String> header = await BasicAuthConfig().getIgniteHeader();
    http.Response res =
        await http.post(Uri.encodeFull("$_baseUrl/approve/$requestId&$userId"),
            headers: header,
            body: json.encode({
              "id": hydrant.getId(),
              "attacks": [hydrant.getFirstAttack(), hydrant.getSecondAttack()],
              "bar": hydrant.getPressure(),
              "cap": hydrant.getCap(),
              "city": hydrant.getCity(),
              "color": hydrant.getColor(),
              "geopoint": {
                "latitude": hydrant.getLat(),
                "longitude": hydrant.getLong()
              },
              "lastCheck": hydrant.getLastCheck().toIso8601String(),
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
    Map<String, String> header = await BasicAuthConfig().getIgniteHeader();
    http.Response res = await http.post(
      Uri.encodeFull("$_baseUrl/deny/$requestId&$userId"),
      headers: header,
    );
    return res.body;
  }

  Future<String> getApprovedRequests() async {
    Map<String, String> header = await BasicAuthConfig().getIgniteHeader();
    http.Response res = await http.get(
      "$_baseUrl/approved",
      headers: header,
    );
    return res.body;
  }

//List<Request>
  Future<String> getPendingRequestsByDistance(
      double latitude, double longitude, double distance) async {
    Map<String, String> header = await BasicAuthConfig().getIgniteHeader();
    http.Response res = await http.get(
      "$_baseUrl/pending/$latitude&$longitude&$distance",
      headers: header,
    );
    return res.body;
  }

//List<Request>
  Future<String> getRequests() async {
    Map<String, String> header = await BasicAuthConfig().getIgniteHeader();
    http.Response res = await http.get(
      "$_baseUrl/all",
      headers: header,
    );
    return res.body;
  }

//List<Request>
  Future<String> getRequestsByDistance(
      double latitude, double longitude, double distance) async {
    Map<String, String> header = await BasicAuthConfig().getIgniteHeader();
    http.Response res = await http.get(
      "$_baseUrl/all/$latitude&$longitude&$distance",
      headers: header,
    );
    return res.body;
  }
}
