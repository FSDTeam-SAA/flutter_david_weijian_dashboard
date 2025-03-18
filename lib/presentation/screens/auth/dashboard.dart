import 'package:drive_test_admin_dashboard/constants/auth_controller.dart';
import 'package:drive_test_admin_dashboard/presentation/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AdminDashboard extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.isLoggedIn(false);
              authController.accessToken('');
              Get.offAll(() => LoginScreen()); // Navigate back to login screen
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the Admin Dashboard'),
      ),
    );
  }
}