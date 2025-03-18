import 'package:drive_test_admin_dashboard/controller/navbar_controller.dart';
import 'package:drive_test_admin_dashboard/presentation/screens/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  final NavController navController = Get.put(NavController());

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Obx(() {
        return navController.currentScreen.value; // Reactive UI update
      }),
      drawer: NavDrawer(),
    );
  }
}