import '../models/hydrant.dart';
import '../models/request.dart';

abstract class RequestsServices {
  Future<List<Request>> getRequests();
  Future<List<Request>> getRequestsByDistance(
      double latitude, double longitude, double distance);
  Future<List<Request>> getPendingRequestsByDistance(
      double latitude, double longitude, double distance);
  Future<List<Request>> getApprovedRequests();
  Future<bool> approveRequest(Hydrant hydrant, String requestId, String userId);
  Future<bool> denyRequest(String requestId, String userId);
  Future<Request> addRequest(Hydrant hydrant, String userId);
}
