import 'dart:convert';
import 'package:drive_test_admin_dashboard/model/bugreport_model.dart';
import 'package:drive_test_admin_dashboard/model/contact_model.dart';
import 'package:drive_test_admin_dashboard/model/review_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:drive_test_admin_dashboard/model/auth_model.dart';
import 'package:drive_test_admin_dashboard/model/user_model.dart';
import '../constants/api_constants.dart';
import 'secure_storage_service.dart';
import 'package:get/get.dart';

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

  //// Post ///

  // Fetch all test centres
  Future<Map<String, dynamic>> getAllTestCentres() async {
    final token = await _secureStorage.getAccessToken();
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.testCentresEndpoint),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch test centres: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  // Method to add a test center
  Future<Map<String, dynamic>> addTestCentre(Map<String, dynamic> data) async {
    final token = await _secureStorage.getAccessToken();

    debugPrint("Data for test center -> $data");
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.addTestCentreEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      debugPrint("Response for test center data -> ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add test centre: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  // Method to create a new route
  Future<void> createRoute(Map<String, dynamic> data) async {
    final token = await _secureStorage.getAccessToken();
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.createRouteEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Ensure Content-Type is set
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Route created successfully');
      } else {
        throw Exception('Failed to create route: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<Map<String, dynamic>> getAllRoutes(String id) async {
    final token = await _secureStorage.getAccessToken();
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.routesEndpoint}/$id"),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint("Response for all routes data -> ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch routes: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  // Update a test centre
  Future<Map<String, dynamic>> updateTestCentre(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.updateTestCentreEndpoint}$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update test centre: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
