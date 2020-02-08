import 'dart:convert';
import '../../apicontrollers/users_apicontroller.dart';
import '../../models/user.dart';
import '../users_services.dart';

class BackendUsersServices implements UsersServices {
  UsersApiController _controller;

  BackendUsersServices(String ip) {
    _controller = new UsersApiController(ip);
  }

  @override
  Future<User> getUserById(String id) async {
    String controllerJson = await _controller.getUserById(id);
    if (controllerJson == null) {
      return null;
    }
    var user = json.decode(controllerJson);
    if (user["fireman"] == 'true') {
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
    String controllerJson = await _controller.getUserByMail(mail);
    if (controllerJson == null) {
      return null;
    }
    var user = json.decode(controllerJson);
    if (user["fireman"] == 'true') {
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
  Future<bool> isUserFiremanByMail(String mail) async {
    String controllerJson = await _controller.isUserFiremanByMail(mail);
    if (controllerJson == null) {
      return false;
    }
    return controllerJson == 'true';
  }

  @override
  Future<bool> isUserFirstAccessByMail(String mail) async {
    String controllerJson = await _controller.isUserFirstAccessByMail(mail);
    if (controllerJson == null) {
      return false;
    }
    return controllerJson == 'true';
  }

  @override
  Future<void> setFirstAccessToFalseByMail(String mail) async {
    await _controller.setFirstAccessToFalseByMail(mail);
  }

  @override
  Future<User> addUser(User newUser) async {
    String controllerJson = await _controller.addUser(newUser);
    var user = json.decode(controllerJson);
    if (user["fireman"] == 'true') {
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
    String controllerJson = await _controller.updateUser(updatedUser);
    var user = json.decode(controllerJson);
    if (user["fireman"] == 'true') {
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
}
