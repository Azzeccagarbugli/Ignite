import 'package:geolocator/geolocator.dart';
import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/factories/repositoriesfactories/firestorerepositoriesfactory.dart';
import 'package:ignite/factories/servicesfactories/firestoreservicesfactory.dart';

import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../../models/user.dart';
import '../requests_services.dart';

class FirestoreRequestsServices implements RequestsServices {
  DbRepository<Request> _requestsController =
      FirestoreRepositoriesFactory().getRequestsRepository();
  @override
  Future<Request> addRequest(Hydrant hydrant, String userId) async {
    Hydrant addedHydrant = await FirestoreServicesFactory()
        .getHydrantsServices()
        .addHydrant(hydrant);
    User requestedBy =
        await FirestoreServicesFactory().getUsersServices().getUserById(userId);
    Request newRequest = new Request(requestedBy.isFireman(),
        !requestedBy.isFireman(), addedHydrant.getId(), requestedBy.getId());
    if (requestedBy.isFireman()) {
      newRequest.setApprovedByUserId(requestedBy.getId());
    }
    return await _requestsController.insert(newRequest);
  }

  @override
  Future<bool> approveRequest(
      Hydrant hydrant, String requestId, String userId) async {
    await FirestoreServicesFactory()
        .getHydrantsServices()
        .updateHydrant(hydrant);
    User approvedBy =
        await FirestoreServicesFactory().getUsersServices().getUserById(userId);
    Request toApprove = await _requestsController.get(requestId);
    if (toApprove == null ||
        approvedBy == null ||
        !(hydrant.getId() == toApprove.getHydrantId()) ||
        !approvedBy.isFireman()) {
      return false;
    }
    toApprove.setApproved(true);
    toApprove.setOpen(false);
    toApprove.setApprovedByUserId(approvedBy.getId());
    await _requestsController.update(toApprove);
    return true;
  }

  @override
  Future<bool> denyRequest(String requestId, String userId) async {
    User approvedBy =
        await FirestoreServicesFactory().getUsersServices().getUserById(userId);
    if (approvedBy == null || !approvedBy.isFireman()) {
      return false;
    }
    Request toDeny = await _requestsController.get(requestId);
    if (toDeny == null) {
      return false;
    }
    Hydrant hydrantToDeny = await FirestoreServicesFactory()
        .getHydrantsServices()
        .getHydrantById(toDeny.getHydrantId());
    if (hydrantToDeny == null) {
      return false;
    }

    await FirestoreServicesFactory()
        .getHydrantsServices()
        .deleteHydrant(toDeny.getHydrantId());
    await _requestsController.delete(toDeny.getId());
    return true;
  }

  @override
  Future<List<Request>> getApprovedRequests() async {
    List<Request> allRequests = await this.getRequests();
    List<Request> approvedRequests = new List<Request>();
    for (Request request in allRequests) {
      if (!request.isOpen() && request.getApproved()) {
        approvedRequests.add(request);
      }
    }
    return approvedRequests;
  }

  @override
  Future<List<Request>> getPendingRequestsByDistance(
      double latitude, double longitude, double distance) async {
    List<Request> allRequests =
        await this.getRequestsByDistance(latitude, longitude, distance);
    List<Request> pendingRequests = new List<Request>();
    for (Request request in allRequests) {
      if (request.isOpen() && !request.getApproved())
        pendingRequests.add(request);
    }
    return pendingRequests;
  }

  @override
  Future<List<Request>> getRequests() async {
    return await _requestsController.getAll();
  }

  @override
  Future<List<Request>> getRequestsByDistance(
      double latitude, double longitude, double distance) async {
    List<Request> allRequests = await _requestsController.getAll();
    List<Request> filteredRequests = new List<Request>();

    for (Request request in allRequests) {
      Hydrant hydrant = await FirestoreServicesFactory()
          .getHydrantsServices()
          .getHydrantById(request.getHydrantId());
      double distanceBetween = await Geolocator().distanceBetween(
          latitude, longitude, hydrant.getLat(), hydrant.getLong());
      if (distanceBetween < distance) filteredRequests.add(request);
    }
    return filteredRequests;
  }
}
