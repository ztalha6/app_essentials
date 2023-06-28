// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:app_essentials/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_essentials/core/env/env_setup.dart';
import 'package:app_essentials/app/data/config/app_configuration.dart';
import 'package:app_essentials/app/data/repositories/auth_repository.dart';
import 'package:app_essentials/app/routes/app_pages.dart';

import '../../create_password/views/create_password_view.dart';

class VerifyOtpController extends GetxController {
  AuthRepository authRepository;

  VerifyOtpController({
    required this.authRepository,
  });

  Configuration configs = Configuration();
  TextEditingController otpController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isResending = false.obs;

  @override
  void onInit() {
    startTimer();
    if (Environment.currentEnv.user != null) {
      otpController.text = '0000';
    }
    super.onInit();
  }

  Rxn<Timer>? timer = Rxn();
  RxInt start = RxInt(60);

  void startTimer() {
    start.value = 30;
    const oneSec = Duration(seconds: 1);
    timer!.value = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
        } else {
          if (start.value > 0) {
            start.value--;
          }
        }
      },
    );
  }

  Future<void> onVerifyTap({
    bool fromSignUp = false,
    bool fromSignIn = false,
  }) async {
    if (otpController.text.isEmpty) return;
    isLoading.value = true;
    bool response = await authRepository.verifyOtp(otpController.text);
    if (response) {
      if (fromSignUp) {
        Get.offAllNamed(ERoutes.POST_SIGN_UP);
      } else if (fromSignIn) {
        Get.offAllNamed(ERoutes.HOME);
      } else {
        debugPrint("Auto: ${otpController.text}");
        Get.offAndToNamed(
          ERoutes.CREATE_PASSWORD,
          arguments: CreatePasswordViewParams(
            isChangingPassword: false,
            otp: otpController.text,
          ),
        );
      }
    }
    isLoading.value = false;
  }

  Future<void> resendOtp() async {
    isResending.value = true;
    if (await AuthRepository()
        .sendOtp((await UserManager().getUser())!.email!)) {
      startTimer();
    }
    isResending.value = false;
  }
}
