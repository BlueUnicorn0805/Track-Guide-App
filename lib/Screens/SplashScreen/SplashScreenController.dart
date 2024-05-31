import 'package:get/get.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Screens/OnboardingScreen/LoginScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(
          () => ApiService.currentUser == null ? LoginScreen() : HomeScreen());
    });
  }
}
