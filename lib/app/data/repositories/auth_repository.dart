import 'dart:io';

import 'package:app_essentials/core/api/parser/response_parser.dart';
import 'package:app_essentials/core/model/base_response_model.dart';
import 'package:app_essentials/core/model/repository_response_model.dart';
import 'package:app_essentials/core/interfaces/repositories/auth_repository.dart';
import 'package:app_essentials/app/data/api_services/auth_service.dart';
import 'package:app_essentials/core/model/enums/response_status.dart';
import 'package:app_essentials/app/data/model/change_password/change_password_request_model.dart';
import 'package:app_essentials/app/data/model/resend_otp/resend_otp_request_model.dart';
import 'package:app_essentials/app/data/model/reset_password/reset_pass_request_model.dart';
import 'package:app_essentials/app/data/model/sign_in/sign_in_request_model.dart';
import 'package:app_essentials/app/data/model/sign_up/sign_in_request_model.dart';
import 'package:app_essentials/app/data/model/sign_up/sign_up_response_model.dart';
import 'package:app_essentials/app/data/model/user_model.dart';
import 'package:app_essentials/app/data/model/verify_otp/verify_otp_request_model.dart';
import 'package:app_essentials/app/data/model/verify_otp/verify_otp_response_model.dart';
import 'package:app_essentials/services/exception_handler.dart';
import 'package:app_essentials/services/snackbar_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../services/token_manager.dart';
import '../../../services/user_manager.dart';

class AuthRepository implements IAuthRepository<AuthApiService> {
  @override
  AuthApiService authApiService = AuthApiService();

  @override
  String notificationDeviceToken = 'dummy token';

  /// Use pass the request from controller as below
  ///
  // /        SignUpRequest(
  // /         fullName: fullName,
  // /         phone: phone,
  // /         email: email,
  // /         password: password,
  // /         passwordConfirmation: password,
  // /         deviceToken: FCMNotificationService.fcmDeviceToken,
  // /         deviceType: 'mobile',
  // /         platform: Platform.isIOS ? "ios" : 'android',
  // /       ),
  @override
  Future<bool> signUp(
    SignUpRequest signUpRequest,
  ) async {
    try {
      SignUpRequest request = SignUpRequest(
        fullName: signUpRequest.fullName,
        phone: signUpRequest.phone,
        email: signUpRequest.email,
        password: signUpRequest.password,
        passwordConfirmation: signUpRequest.password,
        deviceToken: notificationDeviceToken,
        deviceType: 'mobile',
        platform: Platform.isIOS ? "ios" : 'android',
      );

      final ResponseModel<AccessResponse> responseModel =
          await ResponseModel.fromApiResponse<AccessResponse>(
        () async => await authApiService.signUpUser(request),
        (body) => AccessResponse.fromJson(body),
      );
      if (responseModel.status == ResponseStatus.success) {
        await TokenManager()
            .setToken(responseModel.response!.data!.accessToken!.token!);
        await UserManager().saveUser(responseModel.response!.data!.user!);
        return true;
      } else if (responseModel.status == ResponseStatus.responseError ||
          responseModel.status == ResponseStatus.nullResponse) {
        SnackbarManager().showAlertSnackbar(responseModel.error!);
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
      return false;
    }
    return false;
  }

  @override
  Future<RepositoryResponse<User>> signIn(String email, String password) async {
    try {
      final ResponseModel<AccessResponse> responseModel =
          await ResponseModel.fromApiResponse<AccessResponse>(
        () async => await authApiService.signInUser(
          AccessRequest(
            email: email,
            password: password,
            deviceToken: notificationDeviceToken,
            deviceType: 'mobile',
            platform: Platform.isIOS ? "ios" : 'android',
          ),
        ),
        (body) => AccessResponse.fromJson(body),
      );
      if (responseModel.status == ResponseStatus.success) {
        await TokenManager()
            .setToken(responseModel.response!.data!.accessToken!.token!);
        await UserManager().saveUser(responseModel.response!.data!.user!);
        return RepositoryResponse(
          isSuccess: true,
          data: responseModel.response!.data!.user,
        );
      } else if (responseModel.status == ResponseStatus.responseError ||
          responseModel.status == ResponseStatus.nullResponse) {
        SnackbarManager().showAlertSnackbar(responseModel.error!);
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
    return RepositoryResponse(isSuccess: false);
  }

  @override
  Future<RepositoryResponse<User>> guestSignIn() async {
    try {
      final ResponseModel<AccessResponse> responseModel =
          await ResponseModel.fromApiResponse<AccessResponse>(
        () async => await AuthApiService().guestSignIn(),
        (body) => AccessResponse.fromJson(body),
      );
      if (responseModel.status == ResponseStatus.success) {
        await TokenManager()
            .setToken(responseModel.response!.data!.accessToken!.token!);
        await UserManager().saveUser(responseModel.response!.data!.user!);
        return RepositoryResponse(
          isSuccess: true,
          data: responseModel.response!.data!.user,
        );
      } else if (responseModel.status == ResponseStatus.responseError ||
          responseModel.status == ResponseStatus.nullResponse) {
        SnackbarManager().showAlertSnackbar(responseModel.error!);
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
    return RepositoryResponse(isSuccess: false);
  }

  Future<bool> googleSignIn(
    GoogleSignInAccount creds,
    String accessToken,
  ) async {
    try {
      final ResponseModel<AccessResponse> responseModel =
          await ResponseModel.fromApiResponse<AccessResponse>(
        () async => await AuthApiService().signInUser(
          AccessRequest(
            email: creds.email,
            username: creds.displayName,
            fullName: creds.displayName,
            socialPlatform: "google",
            clientId: creds.id,
            token: accessToken,
            deviceToken: notificationDeviceToken,
            deviceType: 'mobile',
            platform: Platform.isIOS ? "ios" : 'android',
          ),
          isSocial: true,
        ),
        (body) => AccessResponse.fromJson(body),
      );
      if (responseModel.status == ResponseStatus.success) {
        await TokenManager()
            .setToken(responseModel.response!.data!.accessToken!.token!);
        await UserManager().saveUser(responseModel.response!.data!.user!);
        return true;
      } else if (responseModel.status == ResponseStatus.responseError ||
          responseModel.status == ResponseStatus.nullResponse) {
        SnackbarManager().showAlertSnackbar(responseModel.error!);
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
    return false;
  }

  Future<bool> appleLogin(
    AuthorizationCredentialAppleID creds,
  ) async {
    try {
      final ResponseModel<AccessResponse> responseModel =
          await ResponseModel.fromApiResponse<AccessResponse>(
        () async => await AuthApiService().signInUser(
          AccessRequest(
            email: creds.email,
            username: creds.givenName,
            fullName: creds.givenName,
            socialPlatform: "apple",
            clientId: creds.userIdentifier,
            token: creds.authorizationCode,
            deviceToken: notificationDeviceToken,
            deviceType: 'mobile',
            platform: Platform.isIOS ? "ios" : 'android',
          ),
          isSocial: true,
        ),
        (body) => AccessResponse.fromJson(body),
      );
      if (responseModel.status == ResponseStatus.success) {
        await TokenManager()
            .setToken(responseModel.response!.data!.accessToken!.token!);
        await UserManager().saveUser(responseModel.response!.data!.user!);
        return true;
      } else if (responseModel.status == ResponseStatus.responseError ||
          responseModel.status == ResponseStatus.nullResponse) {
        SnackbarManager().showAlertSnackbar(responseModel.error!);
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
    return false;
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    try {
      final userEmail = (await UserManager().getUser())!.email;
      final ResponseModel<OtpRespponse> responseModel =
          await ResponseModel.fromApiResponse<OtpRespponse>(
        () async => await AuthApiService().verifyOtp(
          OtpRequest(otpCode: otp, email: userEmail),
        ),
        (body) => OtpRespponse.fromJson(body),
      );
      if (responseModel.status == ResponseStatus.success) {
        await UserManager().saveUser(responseModel.response!.data!.user!);
        return responseModel.response!.status!;
      } else if (responseModel.status == ResponseStatus.responseError ||
          responseModel.status == ResponseStatus.nullResponse) {
        SnackbarManager().showAlertSnackbar(responseModel.error!);
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
    return false;
  }

  @override
  Future<bool> sendOtp(String email) async {
    try {
      final ResponseModel<BaseApiResponse> responseModel =
          await ResponseModel.fromApiResponse<BaseApiResponse>(
        () async => await AuthApiService().sendOtp(
          ResendOtpRequest(email: email),
        ),
        (body) => BaseApiResponse.fromJson(body),
      );
      if (responseModel.status == ResponseStatus.success) {
        return responseModel.response!.status!;
      } else if (responseModel.status == ResponseStatus.responseError ||
          responseModel.status == ResponseStatus.nullResponse) {
        SnackbarManager().showAlertSnackbar(responseModel.error!);
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
    return false;
  }

  @override
  Future<bool> resetPassword(
    String password,
    String confirmPassword,
    String otp,
  ) async {
    try {
      final User? user = await UserManager().getUser();
      final ResponseModel<BaseApiResponse> responseModel =
          await ResponseModel.fromApiResponse<BaseApiResponse>(
        () async => await AuthApiService().resetPassword(
          ResetPasswordRequest(
            passwordConfirmation: confirmPassword,
            password: password,
            email: user!.email,
            otpCode: int.parse(otp),
          ),
        ),
        (body) => BaseApiResponse.fromJson(body),
      );
      if (responseModel.status == ResponseStatus.success) {
        return responseModel.response!.status!;
      } else if (responseModel.status == ResponseStatus.responseError ||
          responseModel.status == ResponseStatus.nullResponse) {
        SnackbarManager().showAlertSnackbar(responseModel.error!);
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
    return false;
  }

  @override
  Future<bool> changePassword(
    String password,
    String confirmPassword,
    String oldPassword,
  ) async {
    try {
      final ResponseModel<BaseApiResponse> responseModel =
          await ResponseModel.fromApiResponse<BaseApiResponse>(
        () async => await AuthApiService().changePassword(
          ChangePasswordRequest(
            passwordConfirmation: confirmPassword,
            password: password,
            currentPassword: oldPassword,
          ),
        ),
        (body) => BaseApiResponse.fromJson(body),
      );
      if (responseModel.status == ResponseStatus.success) {
        return responseModel.response!.status!;
      } else if (responseModel.status == ResponseStatus.responseError ||
          responseModel.status == ResponseStatus.nullResponse) {
        SnackbarManager().showAlertSnackbar(responseModel.error!);
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
    return false;
  }
}
