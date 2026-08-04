import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:player/ui/biometric/biometric_binding.dart';
import 'package:player/ui/biometric/biometric_screen.dart';
import 'package:player/ui/create_new_pass/create_new_pass_binding.dart';
import 'package:player/ui/create_new_pass/create_new_pass_screen.dart';
import 'package:player/ui/create_profile/create_profile_binding.dart';
import 'package:player/ui/create_profile/create_profile_screen.dart';
import 'package:player/ui/dashboard/home/home_screen_binding.dart';
import 'package:player/ui/forget_pass/foreget_pass_binding.dart';
import 'package:player/ui/forget_pass/forget_pass_screen.dart';
import 'package:player/ui/login_screen/login_binding.dart';
import 'package:player/ui/login_screen/login_screen.dart';
import 'package:player/ui/otp_verification/otp_verification_binding.dart';
import 'package:player/ui/otp_verification/otp_verification_screen.dart';
import 'package:player/ui/permission_screen/permission_binding.dart';
import 'package:player/ui/permission_screen/permission_screen.dart';
import 'package:player/ui/select_language/select_language_binding.dart';
import 'package:player/ui/select_language/select_language_screen.dart';
import 'package:player/ui/select_new_user/new_user_binding.dart';
import 'package:player/ui/select_new_user/new_user_screen.dart';
import 'package:player/ui/select_nationlity/select_nationlity_binding.dart';
import 'package:player/ui/select_nationlity/select_nationlity_controller.dart';
import 'package:player/ui/select_nationlity/select_nationlity_screen.dart';
import 'package:player/ui/registration_success/registration_success_screen.dart';
import 'package:player/ui/signup/signup_binding.dart';
import 'package:player/ui/signup/signup_screen.dart';

import '../game/game_controller.dart';
import '../game/game_detail_screen.dart';
import '../game/game_list_screen.dart';
import '../game/merchant/MerchantQrBinding.dart';
import '../game/merchant/merchant_qr.dart';
import '../ui/create_profile/update_profile_screen.dart';
import '../ui/dashboard/home/home_screen.dart';
import '../mysterybox/mysterybox_controller.dart';
import '../mysterybox/mysterybox_detail_screen.dart';
import '../mysterybox/mysterybox_shelf_screen.dart';
import '../shop/address_form_screen.dart';
import '../shop/address_list_screen.dart';
import '../shop/cart_screen.dart';
import '../shop/checkout_screen.dart';
import '../shop/shop_controller.dart';
import '../shop/shop_detail_screen.dart';
import '../shop/shop_list_screen.dart';
import '../shop/shop_screen.dart';
import '../ui/splash/splash_screen.dart';
import '../ui/splash/splash_screen_binding.dart';
import '../wallet/wallet_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final page = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
      transition: Transition.leftToRightWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.biometricScreen,
      page: () => Biometric(),
      binding: BiometricBinding(),
      // transition: Transition.rightToLeft, // Add transition
    ),
    GetPage(
      name: AppRoutes.permissionScreen,
      page: () => const PermissionScreen(),
      binding: PermissionBinding(),
      transition: Transition.leftToRightWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.selectLanguage,
      page: () => const SelectLanguageScreen(),
      binding: SelectLanguageBinding(),
      transition: Transition.leftToRightWithFade, // Add transition


    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.leftToRightWithFade, // Add transition


    ),
    GetPage(
      name: AppRoutes.newUserScreen,
      page: () => const NewUserScreen(),
      binding: NewUserBinding(),
      transition: Transition.leftToRightWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.selectNation,
      page: () => SelectNationlityScreen(),
      binding: SelectNationlityBinding(),
      transition: Transition.leftToRightWithFade, // Add transition

    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => SignupScreen(),
      binding: SignupBinding(),
      transition: Transition.leftToRightWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.createProfile,
      page: () => CreateProfileScreen(),
      binding: CreateProfileBinding(),
      transition: Transition.leftToRightWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.registrationSuccess,
      page: () => const RegistrationSuccessScreen(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.updateProfile,
      page: () => UpdateProfileScreen(),
      binding: UpdateProfileBinding(),
      transition: Transition.leftToRightWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.otpScreen,
      page: () => OtpVerificationScreen(),
      binding: OtpVerificationBinding(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => HomeScreen(),
      binding: HomeScreenBinding(),
      transition: Transition.leftToRightWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.forgetPassScreen,
      page: () => ForgetPassScreen(),
      binding: ForgetPassBinding(),
      transition: Transition.leftToRightWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.createNewPassword,
      page: () => CreateNewPassScreen(),
      binding: CreateNewPassBinding(),
      transition: Transition.leftToRightWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.merchantQR,
      page: () => MerchantQr(),
      binding: MerchantQrBinding(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.gameList,
      page: () => GameDetailScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<GameController>(
                () => GameController());
      }),
    ),
    GetPage(
      name: AppRoutes.shopScreen,
      page: () => const ShopScreen(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.shopList,
      page: () => const ShopListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ShopController>(() => ShopController());
      }),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.shopDetail,
      page: () => const ShopDetailScreen(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.shopCart,
      page: () => const CartScreen(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.shopCheckout,
      page: () => const CheckoutScreen(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.shopAddressList,
      page: () => const AddressListScreen(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.shopAddressForm,
      page: () => const AddressFormScreen(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.mysteryBoxShelf,
      page: () => const MysteryBoxShelfScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MysteryBoxController>(() => MysteryBoxController());
      }),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.mysteryBoxDetail,
      page: () => const MysteryBoxDetailScreen(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
    GetPage(
      name: AppRoutes.walletScreen,
      page: () => const WalletScreen(),
      transition: Transition.rightToLeftWithFade, // Add transition
    ),
  ];
}
