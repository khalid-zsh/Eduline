import 'package:get/get.dart';
import 'package:eduline/features/product/models/product_model.dart';
import 'package:eduline/features/home/screens/home_screen.dart';
import 'package:eduline/features/product/screens/add_edit_product_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/verify_code_screen.dart';
import '../features/location/screens/enable_location_screen.dart';
import '../features/location/screens/language_selection_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/product/screens/product_detail_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/setup_profile_screen.dart';
import '../shared/widgets/success_popup.dart';


class AppPages {
  static List<GetPage> routes = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: '/onBoarding', page: () => OnboardingScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/sign-up', page: () => SignupScreen()),
    GetPage(name: '/forgot-password', page: () => ForgotPassword()),
    GetPage(name: '/verify_code', page: () => VerifyCodeScreen()),
    GetPage(name: '/reset-password', page: () => ResetPassword()),
    GetPage(name: '/popup', page: () => SuccessPopup(image: '', title: '', content: '', buttonTitle: '')),
    GetPage(name: '/home', page: () => HomeScreen()),
    GetPage(name: '/add-edit-product', page: () => AddEditProductScreen()),
    GetPage(name: '/enable-location', page: () => EnableLocation()),
    GetPage(name: '/language', page: () => LanguageSelectionScreen()),
    GetPage(name: '/profile', page: () => ProfilePage()),
    GetPage(name: '/setup-profile', page: () => SetupProfileScreen()),
    GetPage(name: '/product-detail', page: () => ProductDetailScreen(product: Get.arguments as ProductModel,)),
  ];
}