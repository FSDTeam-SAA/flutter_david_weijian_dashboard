import 'package:drive_test_admin_dashboard/constants/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>(); // Find the initialized controller
    return authController.isAuthenticated ? null : const RouteSettings(name: '/login');
  }
}