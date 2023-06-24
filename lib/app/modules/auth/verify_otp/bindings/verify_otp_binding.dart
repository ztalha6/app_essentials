import 'package:app_essentials/app/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

import '../controllers/verify_otp_controller.dart';

class VerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyOtpController>(
      () => VerifyOtpController(authRepository: AuthRepository()),
    );
  }
}
