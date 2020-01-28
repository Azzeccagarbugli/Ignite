import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ignite/dbcontrollers/dbcontroller.dart';
import 'package:ignite/factories/dbfactory.dart';
import 'package:ignite/models/department.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/models/values.dart';

class DbProvider {
  static final DbProvider _singleton = DbProvider._internal();

  factory DbProvider() {
    return _singleton;
  }

  DbProvider._internal();

  DbFactory _dbFactory;
  DbController<Hydrant> _hydrantsController;
  DbController<Department> _departmentsController;
  DbController<User> _usersController;
  DbController<Request> _requestsController;
  DbController<Values> _valuesController;

  void setFactory(DbFactory factory) {
    this._dbFactory = factory;
    this._hydrantsController = _dbFactory.getHydrantsController();
    this._departmentsController = _dbFactory.getDepartmentsController();
    this._usersController = _dbFactory.getUsersController();
    this._requestsController = _dbFactory.getRequestsController();
    this._valuesController = _dbFactory.getValuesController();
  }

  Future<bool> isCurrentUserFireman(FirebaseUser curUser) async {
    List<User> users = await this._usersController.getAll();
    for (User user in users) {
      if (user.getMail() == curUser.email) return user.isFireman();
    }
    return false;
  }

  Future<bool> isFirstAccess(FirebaseUser curUser) async {
    List<User> users = await this._usersController.getAll();
    for (User user in users) {
      if (user.getMail() == curUser.email) return user.isFirstAccess();
    }
    return false;
  }

  void setFirstAccessToFalse(FirebaseUser curUser) async {
    List<User> users = await this._usersController.getAll();
    for (User user in users) {
      if (user.getMail() == curUser.email) {
        user.setFirstAccess(false);
        this._usersController.update(user);
      }
    }
  }

  Future<List<Request>> getRequests() async {
    return await _requestsController.getAll();
  }

  Future<List<Request>> getRequestsByDistance(LatLng position) async {
    List<Request> allRequests = await _requestsController.getAll();
    List<Request> filteredRequests = new List<Request>();

    for (Request request in allRequests) {
      Hydrant hydrant = await getHydrantById(request.getHydrantId());
      double distance = await Geolocator().distanceBetween(position.latitude,
          position.longitude, hydrant.getLat(), hydrant.getLong());
      if (distance < 20000) filteredRequests.add(request);
    }
    return filteredRequests;
  }

  Future<List<Request>> getPendingRequestsByDistance(LatLng position) async {
    List<Request> allRequests = await this.getRequestsByDistance(position);
    List<Request> pendingRequests = new List<Request>();
    for (Request request in allRequests) {
      if (request.isOpen() && !request.getApproved())
        pendingRequests.add(request);
    }
    return pendingRequests;
  }

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

  Future<List<Hydrant>> getApprovedHydrants() async {
    List<Hydrant> approvedHydrants = new List<Hydrant>();
    List<Request> approvedRequests = await getApprovedRequests();
    for (Request request in approvedRequests) {
      Hydrant hydrant = await getHydrantById(request.getHydrantId());
      approvedHydrants.add(hydrant);
    }
    return approvedHydrants;
  }

  Future<List<Department>> getDepartments() async {
    return await _departmentsController.getAll();
  }

  Future<List<String>> _getEnumByName(String name) async {
    List<Values> valueList = await _valuesController.getAll();
    for (Values value in valueList) {
      if (value.getName() == name) return value.getValues();
    }
    return List<String>();
  }

  Future<List<String>> getColors() async {
    return _getEnumByName('color');
  }

  Future<List<String>> getAttacks() async {
    return _getEnumByName('attack');
  }

  Future<List<String>> getOpenings() async {
    return _getEnumByName('opening');
  }

  Future<List<String>> getVehicles() async {
    return _getEnumByName('vehicle');
  }

  Future<List<String>> getTypes() async {
    return _getEnumByName('type');
  }

  Future<List<String>> getPressures() async {
    return _getEnumByName('pressure');
  }

  Future<Request> getRequestById(String id) async {
    return await _requestsController.get(id);
  }

  Future<Hydrant> getHydrantById(String id) async {
    return await _hydrantsController.get(id);
  }

  Future<User> getUserById(String id) async {
    return await _usersController.get(id);
  }

  Future<User> getUserByMail(String mail) async {
    List<User> usersList = await _usersController.getAll();
    for (User user in usersList) {
      if (user.getMail() == mail) return user;
    }
    return null;
  }

  void approveRequest(
      Hydrant hydrant, Request request, FirebaseUser curUser) async {
    await _hydrantsController.update(hydrant);
    User approvedBy = await this.getUserByMail(curUser.email);
    request.setApproved(true);
    request.setOpen(false);
    request.setApprovedByUserId(approvedBy.getId());
    await _requestsController.update(request);
  }

  void denyRequest(Request request) async {
    await _hydrantsController.delete(request.getHydrantId());
    await _requestsController.delete(request.getId());
  }

  void addRequest(Hydrant hydrant, bool isFireman, FirebaseUser curUser) async {
    Hydrant addedHydrant = await _hydrantsController.insert(hydrant);
    User requestedBy = await this.getUserByMail(curUser.email);
    Request newRequest = new Request(
        isFireman, !isFireman, addedHydrant.getId(), requestedBy.getId());
    if (isFireman) {
      newRequest.setApprovedByUserId(requestedBy.getId());
    }
    await _requestsController.insert(newRequest);
  }
}
