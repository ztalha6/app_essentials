import 'package:app_essentials/core/model/enums/response_status.dart';
import 'package:app_essentials/core/api/interceptor/api_interceptor.dart';
import 'package:app_essentials/core/model/base_response_model.dart';
import 'package:dio/dio.dart';

class ResponseModel<T> {
  T? response;
  String? error;
  ResponseStatus status;

  ResponseModel({this.error, required this.status, this.response});

  static Future<ResponseModel<T>> fromApiResponse<T extends BaseApiResponse>(
    Future<Response> Function() apiCall,
    T Function(Map<String, dynamic> body) parser,
  ) async {
    try {
      final Response apiResponse = await apiCall();
      return handleResponse<T>(parser, apiResponse);
    } on DioException {
      rethrow;
    }
  }

  static ResponseModel<T> handleResponse<T extends BaseApiResponse>(
    T Function(Map<String, dynamic> body) parser,
    Response apiResponse,
  ) {
    final T response = parser(apiResponse.data as Map<String, dynamic>);

    if (apiResponse.headers.value("x-auth-error") == "InvalidCredentials") {
      return ResponseModel<T>(
        status: ResponseStatus.responseError,
        response: response,
        error: response.message,
      );
    }
    if (apiResponse.statusCode == 401) {
      throw UnauthorizedException(apiResponse.requestOptions);
    }
    if ((apiResponse.statusCode! < 300 && apiResponse.statusCode! >= 200) ||
        apiResponse.statusCode == 500) {
      if (!response.status!) {
        return ResponseModel<T>(
          status: ResponseStatus.responseError,
          response: response,
          error: response.message,
        );
      } else {
        return ResponseModel<T>(
          status: ResponseStatus.success,
          response: response,
        );
      }
    } else {
      return ResponseModel(
        status: ResponseStatus.nullResponse,
        error: apiResponse.data['message'] as String,
      );
    }
  }
}
