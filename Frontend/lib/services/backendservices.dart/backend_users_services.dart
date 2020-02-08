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
    var user = json.decode(controllerJson);
    if (user["isFireman"]) {
      return new User.fireman(
          user["id"],
          user["mail"],
          user["birthday"],
          user["name"],
          user["surname"],
          user["streetnumber"],
          user["cap"],
          user["departmentId"],
          user["isFirstAccess"],
          user["isGoogle"],
          user["isFacebook"]);
    } else {
      return new User.citizen(user["id"], user["mail"], user["isFirstAccess"],
          user["isGoogle"], user["isFacebook"]);
    }
  }

  @override
  Future<User> getUserByMail(String mail) async {
    String controllerJson = await _controller.getUserByMail(mail);
    var user = json.decode(controllerJson);
    if (user["isFireman"]) {
      return new User.fireman(
          user["id"],
          user["mail"],
          user["birthday"],
          user["name"],
          user["surname"],
          user["streetnumber"],
          user["cap"],
          user["departmentId"],
          user["isFirstAccess"],
          user["isGoogle"],
          user["isFacebook"]);
    } else {
      return new User.citizen(user["id"], user["mail"], user["isFirstAccess"],
          user["isGoogle"], user["isFacebook"]);
    }
  }

  @override
  Future<bool> isUserFiremanByMail(String mail) async {
    User user = await this.getUserByMail(mail);
    return user.isFireman();
  }

  @override
  Future<bool> isUserFirstAccessByMail(String mail) async {
    User user = await this.getUserByMail(mail);
    return user.isFirstAccess();
  }

  @override
  Future<void> setFirstAccessToFalseByMail(String mail) async {
    await _controller.setFirstAccessToFalseByMail(mail);
  }

  @override
  Future<User> addUser(User newUser) async {
    String controllerJson = await _controller.addUser(newUser);
    var user = json.decode(controllerJson);
    if (user["isFireman"]) {
      return new User.fireman(
          user["id"],
          user["mail"],
          user["birthday"],
          user["name"],
          user["surname"],
          user["streetnumber"],
          user["cap"],
          user["departmentId"],
          user["isFirstAccess"],
          user["isGoogle"],
          user["isFacebook"]);
    } else {
      return new User.citizen(user["id"], user["mail"], user["isFirstAccess"],
          user["isGoogle"], user["isFacebook"]);
    }
  }

  @override
  Future<User> updateUser(User updatedUser) async {
    String controllerJson = await _controller.updateUser(updatedUser);
    var user = json.decode(controllerJson);
    if (user["isFireman"]) {
      return new User.fireman(
          user["id"],
          user["mail"],
          user["birthday"],
          user["name"],
          user["surname"],
          user["streetnumber"],
          user["cap"],
          user["departmentId"],
          user["isFirstAccess"],
          user["isGoogle"],
          user["isFacebook"]);
    } else {
      return new User.citizen(user["id"], user["mail"], user["isFirstAccess"],
          user["isGoogle"], user["isFacebook"]);
    }
  }
}
