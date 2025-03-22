import 'package:drive_test_admin_dashboard/core/Routes/app_route.dart';
import 'package:drive_test_admin_dashboard/core/Routes/route_names.dart';
import 'package:drive_test_admin_dashboard/core/binders/nav_binder.dart';
import 'package:drive_test_admin_dashboard/core/theme/theme_data.dart';
import 'package:drive_test_admin_dashboard/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
      initialBinding: Binding(),
      home: SplashScreen(),
    );
  }
}
