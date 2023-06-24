import 'package:app_essentials/app/data/model/change_password/change_password_request_model.dart';
import 'package:app_essentials/app/data/model/resend_otp/resend_otp_request_model.dart';
import 'package:app_essentials/app/data/model/reset_password/reset_pass_request_model.dart';
import 'package:app_essentials/app/data/model/sign_in/sign_in_request_model.dart';
import 'package:app_essentials/app/data/model/sign_up/sign_in_request_model.dart';
import 'package:app_essentials/app/data/model/verify_otp/verify_otp_request_model.dart';

abstract class IAuthApiService {
  Future<dynamic> signUpUser(SignUpRequest requestModel);
  Future<dynamic> resetPassword(ResetPasswordRequest requestModel);
  Future<dynamic> signInUser(AccessRequest requestModel,
      {bool isSocial = false});
  Future<dynamic> guestSignIn();
  Future<dynamic> verifyOtp(OtpRequest requestModel);
  Future<dynamic> sendOtp(ResendOtpRequest requestModel);
  Future<dynamic> changePassword(ChangePasswordRequest requestModel);
}
