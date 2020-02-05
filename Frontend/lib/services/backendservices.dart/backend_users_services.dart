import 'package:ignite/models/user.dart';
import 'package:ignite/services/users_services.dart';

class BackendUsersServices implements UsersServices {
  String _ip;
  BackendUsersServices(String ip) {
    this._ip = ip;
  }

  @override
  Future<User> getUserById(String id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<User> getUserByMail(String mail) {
    // TODO: implement getUserByMail
    throw UnimplementedError();
  }

  @override
  Future<bool> isUserFiremanByMail(String mail) {
    // TODO: implement isUserFiremanByMail
    throw UnimplementedError();
  }

  @override
  Future<bool> isUserFirstAccessByMail(String mail) {
    // TODO: implement isUserFirstAccessByMail
    throw UnimplementedError();
  }

  @override
  Future<void> setFirstAccessToFalseByMail(String mail) {
    // TODO: implement setFirstAccessToFalseByMail
    throw UnimplementedError();
  }

  @override
  Future<User> addUser(User newUser) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<User> updateUser(User updatedUser) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
