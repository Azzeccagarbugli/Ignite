import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/services/requests_services.dart';

class BackendRequestsServices implements RequestsServices {
  String _ip;
  BackendRequestsServices(String ip) {
    this._ip = ip;
  }

  @override
  Future<void> addRequest(Hydrant hydrant, bool isFireman, String userMail) {
    // TODO: implement addRequest
    throw UnimplementedError();
  }

  @override
  Future<void> approveRequest(
      Hydrant hydrant, Request request, String userMail) {
    // TODO: implement approveRequest
    throw UnimplementedError();
  }

  @override
  Future<void> denyRequest(Request request) {
    // TODO: implement denyRequest
    throw UnimplementedError();
  }

  @override
  Future<List<Request>> getApprovedRequests() {
    // TODO: implement getApprovedRequests
    throw UnimplementedError();
  }

  @override
  Future<List<Request>> getPendingRequestsByDistance(
      double latitude, double longitude) {
    // TODO: implement getPendingRequestsByDistance
    throw UnimplementedError();
  }

  @override
  Future<List<Request>> getRequests() {
    // TODO: implement getRequests
    throw UnimplementedError();
  }

  @override
  Future<List<Request>> getRequestsByDistance(
      double latitude, double longitude) {
    // TODO: implement getRequestsByDistance
    throw UnimplementedError();
  }
}
