// lib/navbar/bindings/nav_binding.dart
import 'package:drive_test_admin_dashboard/controller/auth_controller.dart';
import 'package:drive_test_admin_dashboard/controller/navbar_controller.dart';
import 'package:drive_test_admin_dashboard/controller/user_controller.dart';
import 'package:get/get.dart';

class Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => NavController());
    Get.lazyPut(() => UserController());
  }
}
