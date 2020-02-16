import 'dart:convert';
import 'package:ignite/backendservices/backend_users_services.dart';
import 'package:ignite/controllers/users_controller.dart';
import '../../models/user.dart';

class UsersApiController implements UsersController {
  BackendUsersServices _services;

  UsersApiController(String ip) {
    _services = new BackendUsersServices(ip);
  }

  @override
  Future<User> getUserById(String id) async {
    String controllerJson = await _services.getUserById(id);
    if (controllerJson == "") {
      return null;
    }
    var user = json.decode(controllerJson);
    bool isFireman = (user["role"] == "FIREMAN");
    if (isFireman) {
      return new User.fireman(
        user["id"],
        user["mail"],
        user["birthday"],
        user["name"],
        user["surname"],
        user["streetNameNumber"],
        user["cap"],
        user["departmentId"],
        user["firstAccess"],
        user["google"],
        user["facebook"],
      );
    } else {
      return new User.citizen(
        user["id"],
        user["mail"],
        user["firstAccess"],
        user["google"],
        user["facebook"],
      );
    }
  }

  @override
  Future<User> getUserByMail(String mail) async {
    String controllerJson = await _services.getUserByMail(mail);
    if (controllerJson == "") {
      return null;
    }
    var user = json.decode(controllerJson);
    bool isFireman = (user["role"] == "FIREMAN");
    if (isFireman) {
      return new User.fireman(
        user["id"],
        user["mail"],
        user["birthday"],
        user["name"],
        user["surname"],
        user["streetNameNumber"],
        user["cap"],
        user["departmentId"],
        user["firstAccess"],
        user["google"],
        user["facebook"],
      );
    } else {
      return new User.citizen(
        user["id"],
        user["mail"],
        user["firstAccess"],
        user["google"],
        user["facebook"],
      );
    }
  }

  @override
  Future<bool> isUserFiremanById(String id) async {
    String controllerJson = await _services.isUserFiremanById(id);
    return controllerJson == 'true';
  }

  @override
  Future<bool> isUserFirstAccessById(String id) async {
    String controllerJson = await _services.isUserFirstAccessById(id);
    return controllerJson == 'true';
  }

  @override
  Future<bool> setFirstAccessToFalseById(String id) async {
    String controllerJson = await _services.setFirstAccessToFalseById(id);
    return controllerJson == 'true';
  }

  @override
  Future<User> addUser(User newUser) async {
    String controllerJson = await _services.addUser(newUser);
    if (controllerJson == "") {
      return null;
    }
    var user = json.decode(controllerJson);
    bool isFireman = (user["role"] == "FIREMAN");
    if (isFireman) {
      return new User.fireman(
        user["id"],
        user["mail"],
        user["birthday"],
        user["name"],
        user["surname"],
        user["streetNameNumber"],
        user["cap"],
        user["departmentId"],
        user["firstAccess"],
        user["google"],
        user["facebook"],
      );
    } else {
      return new User.citizen(
        user["id"],
        user["mail"],
        user["firstAccess"],
        user["google"],
        user["facebook"],
      );
    }
  }

  @override
  Future<User> updateUser(User updatedUser) async {
    String controllerJson = await _services.updateUser(updatedUser);
    if (controllerJson == "") {
      return null;
    }
    var user = json.decode(controllerJson);
    bool isFireman = (user["role"] == "FIREMAN");
    if (isFireman) {
      return new User.fireman(
        user["id"],
        user["mail"],
        user["birthday"],
        user["name"],
        user["surname"],
        user["streetNameNumber"],
        user["cap"],
        user["departmentId"],
        user["firstAccess"],
        user["google"],
        user["facebook"],
      );
    } else {
      return new User.citizen(
        user["id"],
        user["mail"],
        user["firstAccess"],
        user["google"],
        user["facebook"],
      );
    }
  }

  @override
  Future<bool> userExistsByMail(String mail) async {
    String controllerJson = await _services.userExistsByMail(mail);
    return controllerJson == 'true';
  }
}
