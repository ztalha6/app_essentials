import 'package:app_essentials/app/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

import '../controllers/forget_passsword_controller.dart';

class ForgetPassswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPassswordController>(
      () => ForgetPassswordController(authRepository: AuthRepository()),
    );
  }
}
