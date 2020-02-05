import '../models/hydrant.dart';
import '../models/request.dart';

abstract class RequestsServices {
  Future<List<Request>> getRequests();
  Future<List<Request>> getRequestsByDistance(
      double latitude, double longitude);
  Future<List<Request>> getPendingRequestsByDistance(
      double latitude, double longitude);
  Future<List<Request>> getApprovedRequests();
  Future<void> approveRequest(
      Hydrant hydrant, Request request, String userMail);
  Future<void> denyRequest(Request request);
  Future<void> addRequest(Hydrant hydrant, bool isFireman, String userMail);
}
