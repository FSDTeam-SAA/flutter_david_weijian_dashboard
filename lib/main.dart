import 'package:drive_test_admin_dashboard/constants/auth_controller.dart';
import 'package:drive_test_admin_dashboard/core/Routes/app_pages.dart';
import 'package:drive_test_admin_dashboard/core/theme/binders/nav_binder.dart';
import 'package:drive_test_admin_dashboard/core/theme/theme_data.dart';
import 'package:drive_test_admin_dashboard/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driving Test',
      theme: AppThemes.appThemeData,
      initialBinding: NavBinding(),
      // getPages: AppPages.pages,
      home: MainScreen(),
    );
  }
}
