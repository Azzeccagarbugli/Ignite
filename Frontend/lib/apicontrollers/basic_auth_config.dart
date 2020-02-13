import 'dart:convert';

import 'package:ignite/providers/auth_provider.dart';

const kPass = "Ignite";

class BasicAuthConfig {
  static final BasicAuthConfig _singleton = BasicAuthConfig._internal();

  factory BasicAuthConfig() {
    return _singleton;
  }

  BasicAuthConfig._internal();

  Future<Map<String, String>> getIgniteHeader() async {
    String userMail = await AuthProvider().getUserMail();
    var bytes = utf8.encode("$userMail:$kPass");
    var credentials = base64.encode(bytes);
    var headers = {
      "content-type": "application/json",
      "accept": "application/json",
      "authorization": "Basic $credentials"
    };
    return headers;
  }
}
