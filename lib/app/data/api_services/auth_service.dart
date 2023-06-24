import 'package:app_essentials/core/api_builder/dio_builder.dart';
import 'package:app_essentials/core/interfaces/api_services/auth_api_service.dart';
import 'package:app_essentials/app/data/model/change_password/change_password_request_model.dart';
import 'package:app_essentials/app/data/model/resend_otp/resend_otp_request_model.dart';
import 'package:app_essentials/app/data/model/reset_password/reset_pass_request_model.dart';
import 'package:app_essentials/app/data/model/sign_in/sign_in_request_model.dart';
import 'package:app_essentials/app/data/model/sign_up/sign_in_request_model.dart';
import 'package:app_essentials/app/data/model/verify_otp/verify_otp_request_model.dart';
import 'package:dio/dio.dart';
import 'package:app_essentials/app/data/config/api_constants.dart'
    as api_constant;

class AuthApiService implements IAuthApiService {
  @override
  Future<dynamic> signUpUser(SignUpRequest requestModel) async {
    final DioBuilderResponse dioBuilderResponse =
        await DioBuilder().buildNonCachedDio(passDomain: true);
    final Response response = await dioBuilderResponse.dio.post(
      api_constant.signUpApiConstant,
      options: dioBuilderResponse.dioOptions,
      data: requestModel.toJson(),
    );
    return response;
  }

  @override
  Future<dynamic> resetPassword(ResetPasswordRequest requestModel) async {
    final DioBuilderResponse dioBuilderResponse =
        await DioBuilder().buildNonCachedDio(passDomain: true);
    final Response response = await dioBuilderResponse.dio.post(
      api_constant.resetApiConstant,
      options: dioBuilderResponse.dioOptions,
      data: requestModel.toJson(),
    );
    return response;
  }

  @override
  Future<dynamic> signInUser(
    AccessRequest requestModel, {
    bool isSocial = false,
  }) async {
    final DioBuilderResponse dioBuilderResponse =
        await DioBuilder().buildNonCachedDio(passDomain: true);
    final Response response = await dioBuilderResponse.dio.post(
      isSocial
          ? api_constant.socialSignInApiConstant
          : api_constant.signInApiConstant,
      options: dioBuilderResponse.dioOptions,
      data: requestModel.toJson(),
    );
    return response;
  }

  @override
  Future<dynamic> guestSignIn() async {
    final DioBuilderResponse dioBuilderResponse =
        await DioBuilder().buildNonCachedDio(passDomain: true);
    final Response response = await dioBuilderResponse.dio.post(
      api_constant.registerGuestUser,
      options: dioBuilderResponse.dioOptions,
    );
    return response;
  }

  @override
  Future<dynamic> verifyOtp(OtpRequest requestModel) async {
    final DioBuilderResponse dioBuilderResponse =
        await DioBuilder().buildNonCachedDio(passDomain: true);
    final Response response = await dioBuilderResponse.dio.post(
      api_constant.verifyOtpApiConstant,
      options: dioBuilderResponse.dioOptions,
      data: requestModel.toJson(),
    );
    return response;
  }

  @override
  Future<dynamic> sendOtp(ResendOtpRequest requestModel) async {
    final DioBuilderResponse dioBuilderResponse =
        await DioBuilder().buildNonCachedDio(passDomain: true);
    final Response response = await dioBuilderResponse.dio.post(
      api_constant.resendOtpApiConstant,
      options: dioBuilderResponse.dioOptions,
      data: requestModel.toJson(),
    );
    return response;
  }

  @override
  Future<dynamic> changePassword(ChangePasswordRequest requestModel) async {
    final DioBuilderResponse dioBuilderResponse =
        await DioBuilder().buildNonCachedDio(hasAuth: true);
    final Response response = await dioBuilderResponse.dio.post(
      api_constant.changePasswordApiConstant,
      options: dioBuilderResponse.dioOptions,
      data: requestModel.toJson(),
    );
    return response;
  }
}
