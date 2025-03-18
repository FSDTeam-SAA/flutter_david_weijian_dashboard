import 'package:drive_test_admin_dashboard/core/theme/binders/nav_binder.dart';
import 'package:drive_test_admin_dashboard/core/theme/theme_data.dart';
import 'package:drive_test_admin_dashboard/presentation/screens/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driving Test',
      theme: AppThemes.appThemeData,
      initialBinding: NavBinding(),
      home: NavBarScreen(),
    );
  }
}
