import 'package:app_essentials/core/api/response_handler/api_response_handler.dart';
import 'package:app_essentials/core/model/enums/response_status.dart';
import 'package:app_essentials/core/model/base_response_model.dart';
import 'package:dio/dio.dart';

/// A generic class representing a response model from an API call.
///
/// This class holds the [response] data, [error] message (if any), and the [status] of the response.
class ResponseModel<T> {
  /// The response data of generic type [T].
  T? response;

  /// A string containing the error message, if any.
  String? error;

  /// The status of the response.
  ResponseStatus status;

  /// Creates an instance of [ResponseModel] with the provided [error], [status], and [response].
  ResponseModel({this.error, required this.status, this.response});

  /// A static method to generate a [ResponseModel] from an API response.
  ///
  /// It takes an [apiCall] function that returns a [Response], and a [parser] function
  /// that converts the response body to type [T].
  ///
  /// Returns a [ResponseModel] representing the parsed API response.
  static Future<ResponseModel<T>> fromApiResponse<T extends BaseApiResponse>(
    Future<Response> Function() apiCall,
    T Function(Map<String, dynamic> body) parser,
  ) async {
    try {
      final Response apiResponse = await apiCall();
      return ApiResponseHandler<T>(parser, apiResponse).handleResponse();
    } on DioException {
      rethrow;
    }
  }
}
