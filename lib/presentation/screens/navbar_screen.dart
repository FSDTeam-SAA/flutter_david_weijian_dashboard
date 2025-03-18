// lib/presentation/screens/navbar_screen.dart
import 'package:drive_test_admin_dashboard/presentation/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive_test_admin_dashboard/controller/navbar_controller.dart';
import 'package:drive_test_admin_dashboard/presentation/screens/drawer/drawer.dart';

class NavBarScreen extends StatelessWidget {
  NavBarScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "David Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: ProfileIcon()),
          ),
        ],
      ),
      drawer: NavDrawer(),
      body: Obx(() => Get.find<NavController>().currentScreen.value), // Reactive body
    );
  }
}