import 'package:ignite/dbcontrollers/firebasedbcontrollers/users_firebasecontroller.dart';
import 'package:ignite/factories/controllerfactories/firebasecontrollerfactory.dart';
import 'package:ignite/models/user.dart';
import 'package:ignite/services/users_services.dart';

class FirebaseUsersServices implements UsersServices {
  FirebaseUsersController _usersController =
      FirebaseControllerFactory().getUsersController();
  @override
  Future<User> getUserById(String id) async {
    return await _usersController.get(id);
  }

  @override
  Future<User> getUserByMail(String mail) async {
    List<User> usersList = await _usersController.getAll();
    for (User user in usersList) {
      if (user.getMail() == mail) return user;
    }
    return null;
  }

  @override
  Future<bool> isUserFiremanByMail(String mail) async {
    List<User> users = await this._usersController.getAll();
    for (User user in users) {
      if (user.getMail() == mail) return user.isFireman();
    }
    return false;
  }

  @override
  Future<bool> isUserFirstAccessByMail(String mail) async {
    List<User> users = await this._usersController.getAll();
    for (User user in users) {
      if (user.getMail() == mail) return user.isFirstAccess();
    }
    return false;
  }

  @override
  Future<void> setFirstAccessToFalseByMail(String mail) async {
    List<User> users = await this._usersController.getAll();
    for (User user in users) {
      if (user.getMail() == mail) {
        user.setFirstAccess(false);
        this._usersController.update(user);
      }
    }
  }

  @override
  Future<User> addUser(User newUser) async {
    return await _usersController.insert(newUser);
  }

  @override
  Future<User> updateUser(User updatedUser) async {
    return await _usersController.update(updatedUser);
  }
}
