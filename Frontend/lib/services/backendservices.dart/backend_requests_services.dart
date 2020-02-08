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
  Future<void> addRequest(
      Hydrant hydrant, bool isFireman, String userMail) async {
    await _controller.addRequest(hydrant, isFireman, userMail);
  }

  @override
  Future<void> approveRequest(
      Hydrant hydrant, Request request, String userMail) async {
    await _controller.approveRequest(hydrant, request, userMail);
  }

  @override
  Future<void> denyRequest(Request request) async {
    await _controller.denyRequest(request);
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
