import 'package:app_essentials/app/routes/app_pages.dart';
import 'package:get/get.dart';

class PostSignUpController extends GetxController {
  RxBool isLoading = false.obs;
  RxString selectedAge = '17 Years'.obs;
  RxString selectedGender = 'Male'.obs;

  Future<void> onNextTap() async {
    isLoading(true);
    await Future.delayed(2.seconds);
    Get.offAllNamed(ERoutes.HOME);
    isLoading(false);
  }
}
