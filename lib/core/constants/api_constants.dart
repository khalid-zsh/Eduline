class ApiConstants {

  static const String baseUrl = 'https://product-management2-alpha.vercel.app';

  static const String login = '/api/v1/auth/login';
  static const String profile = '/api/v1/auth/profile';
  static const String currentUser     = '/api/v1/users/me';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String resendOtp = '/api/v1/auth/resend-otp';
  static const String resetPassword = '/api/v1/auth/reset-password';

  static const String register = '/api/v1/users/register';
  static const String completeProfile = '/api/v1/users/complete-profile';
  static const String updateProfile = '/api/v1/users/profile';

  static const String products = '/api/v1/products';
}