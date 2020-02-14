import 'package:ignite/apicontrollers/basic_auth_config.dart';
import 'package:ignite/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class UsersApiController {
  String _ip;
  String _baseUrl;
  UsersApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/user";
  }

//User - body = "" -> null
  Future<String> getUserById(String id) async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/id/$id",
      headers: header,
    );
    return res.body;
  }

//User - body = "" -> null
  Future<String> getUserByMail(String mail) async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/mail/$mail",
      headers: header,
    );
    return res.body;
  }

//bool
  Future<String> isUserFiremanById(String id) async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/isFireman/$id",
      headers: header,
    );
    return res.body;
  }

//bool
  Future<String> isUserFirstAccessById(String id) async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.get(
      "$_baseUrl/isFirstAccess/$id",
      headers: header,
    );
    return res.body;
  }

//bool
  Future<String> setFirstAccessToFalseById(String id) async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.put(
      Uri.encodeFull("$_baseUrl/setFirstAccess/$id"),
      headers: header,
    );
    return res.body;
  }

//User - body = "" -> null
  Future<String> addUser(User newUser) async {
    String role = newUser.isFireman() ? "FIREMAN" : "CITIZEN";
    Map<String, String> header = await BasicAuthConfig().getAdminHeader();

    http.Response res = await http.post(
      Uri.encodeFull("$_baseUrl/new"),
      headers: header,
      body: json.encode({
        "department": newUser.getDepartmentId(),
        "birthday": newUser.getBirthday(),
        "cap": newUser.getCap(),
        "mail": newUser.getMail(),
        "name": newUser.getName(),
        "surname": newUser.getSurname(),
        "streetNameNumber": newUser.getStreetNumber(),
        "role": role,
        "firstAccess": newUser.isFirstAccess(),
        "google": newUser.isGoogle(),
        "facebook": newUser.isFacebook(),
      }),
    );
    return res.body;
  }

//User - body = "" -> null
  Future<String> updateUser(User updatedUser) async {
    String role = updatedUser.isFireman() ? "FIREMAN" : "CITIZEN";
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res = await http.post(
      Uri.encodeFull("$_baseUrl/update"),
      headers: header,
      body: json.encode({
        "id": updatedUser.getId(),
        "department": updatedUser.getDepartmentId(),
        "birthday": updatedUser.getBirthday(),
        "cap": updatedUser.getCap(),
        "mail": updatedUser.getMail(),
        "name": updatedUser.getName(),
        "surname": updatedUser.getSurname(),
        "streetNameNumber": updatedUser.getStreetNumber(),
        "role": role,
        "firstAccess": updatedUser.isFirstAccess(),
        "google": updatedUser.isGoogle(),
        "fireman": updatedUser.isFireman(),
        "facebook": updatedUser.isFacebook(),
      }),
    );
    return res.body;
  }

  Future<String> userExistsByMail(String mail) async {
    Map<String, String> header = await BasicAuthConfig().getAdminHeader();
    http.Response res = await http.get(
      "$_baseUrl/exists/$mail",
      headers: header,
    );
    return res.body;
  }
}
