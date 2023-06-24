import 'package:app_essentials/app/data/model/sign_up/sign_in_request_model.dart';
import 'package:app_essentials/app/data/model/user_model.dart';
import 'package:app_essentials/core/model/repository_response_model.dart';

abstract class IAuthRepository<T> {
  late T authApiService;
  late String notificationDeviceToken;

  Future<bool> signUp(SignUpRequest signUpRequest);
  Future<RepositoryResponse<User>> signIn(String email, String password);
  Future<RepositoryResponse<User>> guestSignIn();
  Future<bool> verifyOtp(String otp);
  Future<bool> sendOtp(String email);
  Future<bool> resetPassword(
      String password, String confirmPassword, String otp);
  Future<bool> changePassword(
      String password, String confirmPassword, String oldPassword);
}
