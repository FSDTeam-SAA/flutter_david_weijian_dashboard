import 'dart:convert';
import 'package:drive_test_admin_dashboard/model/auth_model.dart';
import 'package:drive_test_admin_dashboard/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiService {

  /// Admin Loing 
  Future<AuthResponse> adminLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.adminLoginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }


  /// Fetch All User Data
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(ApiConstants.usersEndpoint));

    debugPrint("Response for user data -> ${response.toString()}");

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
