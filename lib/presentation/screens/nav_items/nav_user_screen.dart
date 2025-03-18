import 'package:drive_test_admin_dashboard/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavUserScreen extends StatelessWidget {

  final UserController authController = Get.put(UserController());

  NavUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              authController.fetchUserData(); // Refresh the authentication data
            },
          ),
        ],
      ),
      body: Obx(() {
        if (authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (authController.userData.isEmpty) {
          return const Center(child: Text('No user data found'));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Date of Birth')),
                DataColumn(label: Text('Created At')),
                DataColumn(label: Text('Updated At')),
              ],
              rows: authController.userData.map((auth) {
                return DataRow(cells: [
                  DataCell(Text(auth.name)),
                  DataCell(Text(auth.email)),
                  DataCell(Text(auth.role)),
                  DataCell(Text(auth.dateOfBirth.toString())),
                  DataCell(Text(auth.createdAt.toString())),
                  DataCell(Text(auth.updatedAt.toString())),
                ]);
              }).toList(),
            ),
          );
        }
      }),
    );
  }
}
