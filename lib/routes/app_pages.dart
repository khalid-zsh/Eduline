import 'package:get/get.dart';
import 'package:eduline/features/product/models/product_model.dart';
import 'package:eduline/features/home/screens/home_screen.dart';
import 'package:eduline/features/product/screens/add_edit_product_screen.dart';
import '../ui/pages/ProfilePage/profile_page.dart';
import '../ui/pages/Register/sign_up.dart';
import '../ui/pages/forgot_password/forgot_password.dart';
import '../ui/pages/language_section/language_section.dart';
import '../ui/pages/login/login_screen.dart';
import '../ui/pages/onboarding/onBoarding_screen.dart';
import '../ui/pages/profile_setup/profile_setup.dart';
import '../ui/pages/splash/splash_screen.dart';
import '../ui/pages/varify/varify_code_screen.dart';
import '../ui/pages/reset_password/reset_password.dart';
import '../ui/pages/enable_location/enable_location.dart';
import 'package:eduline/features/product/screens/product_detail_screen.dart';
import '../ui/widgets/custom_success_popup/success_popup.dart';

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