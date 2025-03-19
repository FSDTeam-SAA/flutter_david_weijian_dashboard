import 'dart:convert';
import 'package:drive_test_admin_dashboard/model/bugreport_model.dart';
import 'package:drive_test_admin_dashboard/model/contact_model.dart';
import 'package:drive_test_admin_dashboard/model/review_data_model.dart';
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
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> data = responseData['data'];
      return data
          .map((user) => User.fromJson(user))
          .where((user) => user.role == 'user')
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Fetch contact details
  Future<List<Contact>> fetchContactDetails() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse(ApiConstants.contactDetailsEndpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    debugPrint("Response for contact data -> ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> data = responseData['data'];
      return data.map((contact) {
        debugPrint("Contact JSON: $contact"); // Debug the JSON data
        return Contact.fromJson(contact);
      }).toList();
    } else {
      throw Exception('Failed to load contact details');
    }
  }

  // Fetch bug reports
  Future<List<BugReport>> fetchBugReports() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse(ApiConstants.bugReportEndpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    // debugPrint("Response for bug report data -> ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> data = responseData['data'];
      return data.map((bugReport) => BugReport.fromJson(bugReport)).toList();
    } else {
      throw Exception('Failed to load bug reports');
    }
  }


  // Fetch all reviews

  Future<List<ReviewData>> fetchReviews() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse(ApiConstants.allReviewsEndpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    debugPrint("Response for all reviews data -> ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> data = responseData['data'];
      return data.map((reviewData) => ReviewData.fromJson(reviewData)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
