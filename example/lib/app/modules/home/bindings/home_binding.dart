import 'package:app_essentials/app/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(authRepository: AuthRepository()),
    );
  }
}
