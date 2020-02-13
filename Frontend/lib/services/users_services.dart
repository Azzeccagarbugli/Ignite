import '../models/user.dart';

abstract class UsersServices {
  Future<bool> isUserFiremanById(String id);
  Future<bool> isUserFirstAccessById(String id);
  Future<bool> setFirstAccessToFalseById(String id);
  Future<User> getUserById(String id);
  Future<User> getUserByMail(String mail);
  Future<User> addUser(User newUser);
  Future<User> updateUser(User updatedUser);
  Future<bool> userExistsByMail(String mail);
}
