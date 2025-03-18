// lib/navbar/bindings/nav_binding.dart
import 'package:drive_test_admin_dashboard/controller/navbar_controller.dart';
import 'package:get/get.dart';


class NavBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavController()); // Lazy initialization
  }
}