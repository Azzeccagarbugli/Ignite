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

  Future<String> getUserById(String id) async {
    http.Response res = await http.get(
      "$_baseUrl/id/$id",
      headers: _header,
    );
    if (res.statusCode == 500) {
      return null;
    }
    return res.body;
  }

  Future<String> getUserByMail(String mail) async {
    http.Response res = await http.get(
      "$_baseUrl/mail/$mail",
      headers: _header,
    );
    if (res.statusCode == 500) {
      return null;
    }
    return res.body;
  }

  Future<String> isUserFiremanByMail(String mail) async {
    http.Response res = await http.get(
      "$_baseUrl/isFireman/$mail",
      headers: _header,
    );
    if (res.statusCode == 500) {
      return null;
    }
    return res.body;
  }

  Future<String> isUserFirstAccessByMail(String mail) async {
    http.Response res = await http.get(
      "$_baseUrl/isFirstAccess/$mail",
      headers: _header,
    );
    if (res.statusCode == 500) {
      return null;
    }
    return res.body;
  }

  Future<String> setFirstAccessToFalseByMail(String mail) async {
    http.Response res = await http.put(
      Uri.encodeFull("$_baseUrl/setFirstAccess/$mail"),
      headers: _header,
    );
    if (res.statusCode == 500) {
      return null;
    }
    return res.body;
  }

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
    if (res.statusCode == 500) {
      return null;
    }
    return res.body;
  }

  Future<String> updateUser(User updatedUser) async {
    http.Response res = await http.post(
      Uri.encodeFull("$_baseUrl/update"),
      headers: _header,
      body: json.encode({
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
    if (res.statusCode == 500) {
      return null;
    }
    return res.body;
  }
}
