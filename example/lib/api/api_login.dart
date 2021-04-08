import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

@immutable
class LoginResponse {
  const LoginResponse({this.token, this.error});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );
  }

  final String? token;
  final String? error;
}

class LoginRequest {
  LoginRequest({
    this.account,
    this.password,
  });

  String? account;
  String? password;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'email': account!.trim(),
      'password': password!.trim(),
    };

    return map;
  }
}

class APIService {
  static const host = 'reqres.in';

  static Future<LoginResponse> login(LoginRequest request) async {
    const path = '/api/login';
    final uri = Uri.https(host, path);

    final response = await http.post(uri, body: request.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
