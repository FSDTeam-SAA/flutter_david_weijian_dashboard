import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:drive_test_admin_dashboard/model/auth_model.dart';
import 'package:drive_test_admin_dashboard/model/user_model.dart';
import '../constants/api_constants.dart';
import 'secure_storage_service.dart';

class ApiService {
  final SecureStorageService _secureStorage = SecureStorageService();

  // Admin login
  Future<AuthResponse> adminLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.adminLoginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  // Fetch all users (authenticated request)
  Future<List<User>> fetchUsers() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse(ApiConstants.usersEndpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    debugPrint("Response for user data -> ${response.body}");

    if (response.statusCode == 200) {
      // Parse the response as a list of user objects
      List<dynamic> data = json.decode(response.body);
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
