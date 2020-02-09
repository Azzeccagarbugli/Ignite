import 'dart:convert';
import '../../apicontrollers/requests_apicontroller.dart';
import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../requests_services.dart';

class BackendRequestsServices implements RequestsServices {
  RequestsApiController _controller;

  BackendRequestsServices(String ip) {
    _controller = new RequestsApiController(ip);
  }

  @override
  Future<Request> addRequest(Hydrant hydrant, String userId) async {
    String controllerJson = await _controller.addRequest(hydrant, userId);
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
        await _controller.approveRequest(hydrant, requestId, userId);
    return controllerJson == 'true';
  }

  @override
  Future<bool> denyRequest(String requestId, String userId) async {
    String controllerJson = await _controller.denyRequest(requestId, userId);
    return controllerJson == 'true';
  }

  @override
  Future<List<Request>> getApprovedRequests() async {
    String controllerJson = await _controller.getApprovedRequests();
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
      double latitude, double longitude) async {
    String controllerJson =
        await _controller.getPendingRequestsByDistance(latitude, longitude);
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
    String controllerJson = await _controller.getRequests();
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
      double latitude, double longitude) async {
    String controllerJson =
        await _controller.getRequestsByDistance(latitude, longitude);
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
