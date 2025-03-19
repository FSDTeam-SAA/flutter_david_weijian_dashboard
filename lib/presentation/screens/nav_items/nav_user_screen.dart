import 'package:drive_test_admin_dashboard/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavUserScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  NavUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              userController.fetchUserData(); // Refresh the user data
            },
          ),
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (userController.userData.isEmpty) {
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
              rows:
                  userController.userData.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(Text(user.name)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.role)),
                        DataCell(Text(user.dateOfBirth.toString())),
                        DataCell(Text(user.createdAt.toString())),
                        DataCell(Text(user.updatedAt.toString())),
                      ],
                    );
                  }).toList(),
            ),
          );
        }
      }),
    );
  }
}
