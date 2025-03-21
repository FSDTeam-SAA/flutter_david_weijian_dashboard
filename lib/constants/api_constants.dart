class ApiConstants {
  static const String baseUrl =
      'https://backend-david-weijian.onrender.com/api/v1';

  static const String adminLoginEndpoint = '$baseUrl/admin/login';
  static const String usersEndpoint = '$baseUrl/admin/all-users';

  static const String contactDetailsEndpoint = '$baseUrl/admin/contact-details';
  static const String bugReportEndpoint = '$baseUrl/admin/bug-report';
  static const String allReviewsEndpoint = '$baseUrl/admin/all-review';


  static const String testCentresEndpoint = '$baseUrl/admin/all-test-centre';

  // post
  static const String addTestCentreEndpoint = '$baseUrl/admin/add-test-centre';
  static const String createRouteEndpoint = '$baseUrl/admin/create-route';

  // put
  static const String updateTestCentreEndpoint = '$baseUrl/admin/update-test-centre';

}
