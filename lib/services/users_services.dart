import 'package:ignite/models/user.dart';

abstract class UsersServices {
  Future<bool> isUserFiremanByMail(String mail);
  Future<bool> isUserFirstAccessByMail(String mail);
  Future<void> setFirstAccessToFalseByMail(String mail);
  Future<User> getUserById(String id);
  Future<User> getUserByMail(String mail);
  Future<User> addUser(User newUser);
  Future<User> updateUser(User updatedUser);
}
