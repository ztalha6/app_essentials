import 'package:app_essentials/app/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

import '../controllers/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(
      () => SignInController(authRepository: AuthRepository()),
    );
  }
}
