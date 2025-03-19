// import 'package:drive_test_admin_dashboard/services/api_service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:drive_test_admin_dashboard/model/contact_model.dart';

// class ContactController extends GetxController {
//   final ApiService _apiService = ApiService();
//   var isLoading = false.obs;
//   var contactData = <Contact>[].obs;

//   @override
//   void onInit() {
//     fetchContactData();
//     super.onInit();
//   }

//   // Fetch contact data
//   Future<void> fetchContactData() async {
//     try {
//       isLoading(true);
//       final contacts = await _apiService.fetchContactDetails();
//       // debugPrint("Contact Details -> $contacts");
//       contactData.assignAll(contacts); // Update the observable list
//     } catch (e) {
//       Get.snackbar('Error', e.toString()); // Show error message
//     } finally {
//       isLoading(false);
//     }
//   }
// }
