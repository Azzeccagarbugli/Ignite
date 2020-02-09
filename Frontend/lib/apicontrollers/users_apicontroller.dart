import 'package:ignite/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class UsersApiController {
  String _ip;
  String _baseUrl;
  Map<String, String> _header;
  UsersApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/user";
    _header = {
      "content-type": "application/json",
      "accept": "application/json"
    };
  }

//User - body = "" -> null
  Future<String> getUserById(String id) async {
    http.Response res = await http.get(
      "$_baseUrl/id/$id",
      headers: _header,
    );
    return res.body;
  }

//User - body = "" -> null
  Future<String> getUserByMail(String mail) async {
    http.Response res = await http.get(
      "$_baseUrl/mail/$mail",
      headers: _header,
    );
    return res.body;
  }

//bool
  Future<String> isUserFiremanById(String id) async {
    http.Response res = await http.get(
      "$_baseUrl/isFireman/$id",
      headers: _header,
    );
    return res.body;
  }

//bool
  Future<String> isUserFirstAccessById(String id) async {
    http.Response res = await http.get(
      "$_baseUrl/isFirstAccess/$id",
      headers: _header,
    );
    return res.body;
  }

//bool
  Future<String> setFirstAccessToFalseById(String id) async {
    http.Response res = await http.put(
      Uri.encodeFull("$_baseUrl/setFirstAccess/$id"),
      headers: _header,
    );
    return res.body;
  }

//User - body = "" -> null
  Future<String> addUser(User newUser) async {
    http.Response res = await http.post(
      Uri.encodeFull("$_baseUrl/new"),
      headers: _header,
      body: json.encode({
        "department": newUser.getDepartmentId(),
        "birthday": newUser.getBirthday(),
        "cap": newUser.getCap(),
        "mail": newUser.getMail(),
        "name": newUser.getName(),
        "surname": newUser.getSurname(),
        "streetNameNumber": newUser.getStreetNumber(),
        "firstAccess": newUser.isFirstAccess(),
        "google": newUser.isGoogle(),
        "fireman": newUser.isFireman(),
        "facebook": newUser.isFacebook(),
      }),
    );
    return res.body;
  }

//User - body = "" -> null
  Future<String> updateUser(User updatedUser) async {
    http.Response res = await http.post(
      Uri.encodeFull("$_baseUrl/update"),
      headers: _header,
      body: json.encode({
        "id": updatedUser.getId(),
        "department": updatedUser.getDepartmentId(),
        "birthday": updatedUser.getBirthday(),
        "cap": updatedUser.getCap(),
        "mail": updatedUser.getMail(),
        "name": updatedUser.getName(),
        "surname": updatedUser.getSurname(),
        "streetNameNumber": updatedUser.getStreetNumber(),
        "firstAccess": updatedUser.isFirstAccess(),
        "google": updatedUser.isGoogle(),
        "fireman": updatedUser.isFireman(),
        "facebook": updatedUser.isFacebook(),
      }),
    );
    return res.body;
  }
}
