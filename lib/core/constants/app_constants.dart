class AppConstants {
  static const String appName = 'MediCompare Doctor';

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  static const String baseUrl =
      isProduction
          ? 'https://api.medicompares.com/api/v1'
          : 'http://192.168.0.161:9001/api/v1';

  static const String socketUrl =
      isProduction
          ? 'https://api.medicompares.com'
          : 'http://192.168.0.161:9001';

  // API Endpoints
  static const String loginEndpoint = '/doctor/auth/login';
  static const String verifyOtpEndpoint = '/doctor/auth/verify-otp';
  static const String dashboardEndpoint = '/doctor/dashboard';
  static const String scheduleEndpoint = '/doctor/dashboard/schedule';
  static const String patientsEndpoint = '/doctor/dashboard/patient-list';
  static const String profileEndpoint = '/doctor/profile';
  static const String logoutEndpoint = '/doctor/profile/logout';
  static const String pendingCallOffer = '/calls/pending/';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 10);
  static const Duration internetCheckTimeout = Duration(seconds: 3);
}
