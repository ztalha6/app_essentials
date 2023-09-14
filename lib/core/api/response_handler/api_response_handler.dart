import 'package:app_essentials/core/api/interceptor/api_interceptor.dart';
import 'package:app_essentials/core/api/parser/response_parser.dart';
import 'package:app_essentials/core/model/base_response_model.dart';
import 'package:app_essentials/core/model/enums/response_status.dart';
import 'package:dio/dio.dart';

/// The `ApiResponseHandler` class is responsible for handling API responses and converting them into `ResponseModel` instances. It is designed to work with API responses that adhere to the structure defined by the `BaseApiResponse` type.

class ApiResponseHandler<T extends BaseApiResponse> {
  /// A function that takes a JSON [Map] and parses it into an instance of type [T].
  final T Function(Map<String, dynamic> body) parser;

  /// The HTTP response received from the API.
  final Response apiResponse;

  /// Creates an instance of the `ApiResponseHandler` class with the provided [parser] function and [apiResponse].
  ApiResponseHandler(this.parser, this.apiResponse);

  /// Handles the API response and converts it into a [ResponseModel] instance.
  /// This method performs checks for various response conditions, such as success, error, unauthorized access, and invalid credentials.
  ///
  /// Returns a [ResponseModel] representing the parsed API response.
  ResponseModel<T> handleResponse() {
    if (_isInvalidCredentialsError(apiResponse)) {
      return _buildErrorResponse(apiResponse.data);
    }

    if (_isUnauthorized(apiResponse)) {
      throw UnauthorizedException(apiResponse.requestOptions);
    }

    if (_isSuccess(apiResponse)) {
      return _buildSuccessResponse(apiResponse.data);
    }

    if (_hasErrors(apiResponse)) {
      return _buildErrorResponse(apiResponse.data);
    }

    return _buildNullResponse(
      apiResponse.data?['message'] as String? ?? "Something is wrong!",
    );
  }

  /// Checks if the API response indicates an "Invalid Credentials" error.
  bool _isInvalidCredentialsError(Response apiResponse) {
    return apiResponse.headers.value("x-auth-error") == "InvalidCredentials";
  }

  /// Checks if the API response indicates an unauthorized access (HTTP status code 401).
  bool _isUnauthorized(Response apiResponse) {
    return apiResponse.statusCode == 401;
  }

  /// Checks if the API response is successful based on HTTP status codes.
  bool _isSuccess(Response apiResponse) {
    return (apiResponse.statusCode! < 300 && apiResponse.statusCode! >= 200) ||
        apiResponse.statusCode == 500;
  }

  /// Checks if the API response contains errors based on the parsed response's status.
  bool _hasErrors(Response apiResponse) {
    return _isSuccess(apiResponse) && !(parser(apiResponse.data)).status!;
  }

  /// Builds an error response [ResponseModel] based on the provided [responseData].
  ResponseModel<T> _buildErrorResponse(Map<String, dynamic> responseData) {
    final T response = parser(responseData);
    return ResponseModel<T>(
      status: ResponseStatus.responseError,
      error: response.message,
      response: response,
    );
  }

  /// Builds a success response [ResponseModel] based on the provided [responseData].
  ResponseModel<T> _buildSuccessResponse(Map<String, dynamic>? responseData) {
    final T? response = responseData == null ? null : parser(responseData);
    return ResponseModel<T>(
      status: ResponseStatus.success,
      response: response,
      error: response?.message,
    );
  }

  /// Builds a null response [ResponseModel] with the given [errorMessage].
  ResponseModel<T> _buildNullResponse(String errorMessage) {
    return ResponseModel(
      status: ResponseStatus.nullResponse,
      error: errorMessage,
    );
  }
}
