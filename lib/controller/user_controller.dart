import 'package:drive_test_admin_dashboard/model/user_model.dart';
import 'package:drive_test_admin_dashboard/services/pi_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var userData = <User>[].obs; // Observable list of authentication data
  var isLoading = true.obs; // Loading state

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading(true);
      final fetchedAuthData = await _apiService.fetchUsers();
      debugPrint("Fetch data ${fetchedAuthData.toString()}");
      userData.assignAll(fetchedAuthData); // Update the observable list
    } catch (e) {
      Get.snackbar('Error', e.toString()); // Show error message
    } finally {
      isLoading(false); // Stop loading
    }
  }
}
