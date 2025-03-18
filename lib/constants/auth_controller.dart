import 'package:drive_test_admin_dashboard/presentation/screens/auth/dashboard.dart';
import 'package:drive_test_admin_dashboard/presentation/screens/auth/login_screen.dart';
import 'package:drive_test_admin_dashboard/services/pi_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var accessToken = ''.obs;

  // Check if the admin is authenticated
  bool get isAuthenticated => isLoggedIn.value;

  Future<void> adminLogin(String email, String password) async {
    try {
      isLoading(true);
      final response = await _apiService.adminLogin(email, password);
      if (response.status) {
        isLoggedIn(true);
        accessToken(response.accessToken ?? '');
        Get.offAll(() => AdminDashboard()); // Navigate to admin dashboard
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Logout the admin
  void logout() {
    isLoggedIn(false);
    accessToken('');
    Get.offAll(() => LoginScreen()); // Redirect to login screen
  }
}