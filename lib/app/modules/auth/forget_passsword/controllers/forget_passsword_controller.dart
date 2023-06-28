// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_essentials/services/validator_service.dart';
import 'package:app_essentials/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_essentials/core/env/env_setup.dart';
import 'package:app_essentials/app/data/model/user_model.dart';
import 'package:app_essentials/app/data/repositories/auth_repository.dart';
import 'package:app_essentials/services/user_manager.dart';

class ForgetPassswordController extends GetxController {
  AuthRepository authRepository;

  TextEditingController emailController = TextEditingController();
  RxnString emailErrorText = RxnString();
  RxBool isLoading = false.obs;
  ForgetPassswordController({
    required this.authRepository,
  });

  @override
  void onInit() {
    if (Environment.currentEnv.user != null) {
      emailController.text = Environment.currentEnv.user!.email;
      // onSignInTap();
    }
    super.onInit();
  }

  Future<void> onRecoverNowTap() async {
    final bool isValid = checkForValidation();
    if (!isValid) return;
    isLoading.value = true;
    if (await authRepository.sendOtp(emailController.text)) {
      await UserManager().saveUser(User(email: emailController.text));
      Get.offAndToNamed(
        ERoutes.VERIFY_OTP,
        arguments: [false, false, emailController.text],
      );
    }
    isLoading.value = false;
  }

  bool checkForValidation() {
    emailErrorText.value = Validator().validateEmail(emailController.text);
    return emailErrorText.value == null;
  }
}
