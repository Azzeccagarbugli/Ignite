import 'dart:convert';
import 'package:ignite/backendservices/backend_requests_services.dart';
import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../requests_controller.dart';

class RequestsApiController implements RequestsController {
  BackendRequestsServices _services;

  RequestsApiController(String ip) {
    _services = new BackendRequestsServices(ip);
  }

  @override
  Future<Request> addRequest(Hydrant hydrant, String userId) async {
    String controllerJson = await _services.addRequest(hydrant, userId);
    if (controllerJson == "") {
      return null;
    }
    var parsedJson = json.decode(controllerJson);
    parsedJson.keys.contains("approvedBy");
    String approvedBy = parsedJson.keys.contains("approvedBy")
        ? parsedJson["approvedBy"]
        : null;
    return new Request.complete(
        parsedJson["id"],
        parsedJson["approved"],
        parsedJson["open"],
        approvedBy,
        parsedJson["hydrant"],
        parsedJson["requestedBy"]);
  }

  @override
  Future<bool> approveRequest(
      Hydrant hydrant, String requestId, String userId) async {
    String controllerJson =
        await _services.approveRequest(hydrant, requestId, userId);
    return controllerJson == 'true';
  }

  @override
  Future<bool> denyRequest(String requestId, String userId) async {
    String controllerJson = await _services.denyRequest(requestId, userId);
    return controllerJson == 'true';
  }

  @override
  Future<List<Request>> getApprovedRequests() async {
    String controllerJson = await _services.getApprovedRequests();
    var parsedJson = json.decode(controllerJson);
    List<Request> requests = new List<Request>();
    for (var request in parsedJson) {
      requests.add(new Request.complete(
          request["id"],
          request["approved"],
          request["open"],
          request["approvedBy"],
          request["hydrant"],
          request["requestedBy"]));
    }
    return requests;
  }

  @override
  Future<List<Request>> getPendingRequestsByDistance(
      double latitude, double longitude, double distance) async {
    String controllerJson = await _services.getPendingRequestsByDistance(
        latitude, longitude, distance);
    var parsedJson = json.decode(controllerJson);
    List<Request> requests = new List<Request>();
    for (var request in parsedJson) {
      requests.add(new Request.complete(
        request["id"],
        request["approved"],
        request["open"],
        null,
        request["hydrant"],
        request["requestedBy"],
      ));
    }
    return requests;
  }

  @override
  Future<List<Request>> getRequests() async {
    String controllerJson = await _services.getRequests();
    var parsedJson = json.decode(controllerJson);
    List<Request> requests = new List<Request>();
    for (var request in parsedJson) {
      requests.add(new Request.complete(
          request["id"],
          request["approved"],
          request["open"],
          request["approvedBy"],
          request["hydrant"],
          request["requestedBy"]));
    }
    return requests;
  }

  @override
  Future<List<Request>> getRequestsByDistance(
      double latitude, double longitude, double distance) async {
    String controllerJson =
        await _services.getRequestsByDistance(latitude, longitude, distance);
    var parsedJson = json.decode(controllerJson);
    List<Request> requests = new List<Request>();
    for (var request in parsedJson) {
      requests.add(new Request.complete(
          request["id"],
          request["approved"],
          request["open"],
          request["approvedBy"],
          request["hydrant"],
          request["requestedBy"]));
    }
    return requests;
  }
}
