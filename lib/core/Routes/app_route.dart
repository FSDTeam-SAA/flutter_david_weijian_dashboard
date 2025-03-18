import 'package:drive_test_admin_dashboard/core/Routes/route_names.dart';
import 'package:drive_test_admin_dashboard/middleware/auth_guard.dart';
import 'package:drive_test_admin_dashboard/presentation/screens/auth/dashboard.dart';
import 'package:drive_test_admin_dashboard/presentation/screens/auth/login_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: RouteNames.login,
      page: () => LoginScreen(),
      
    ),
    GetPage(
      name: RouteNames.dashboard,
      page: () => AdminDashboard(),
      middlewares: [AuthGuard()]
    ),

    // GetPage(
    //   name: RouteNames.,
    //   page: () => LocationScreen(),
    // ),
  ];
}