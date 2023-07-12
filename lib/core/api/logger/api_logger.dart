// Interface for logging requests
import 'dart:developer';

import 'package:dio/dio.dart';

abstract class RequestLogger {
  void logRequest(RequestOptions options);
}

// Implementation of RequestLogger using Dio
class DioRequestLogger implements RequestLogger {
  @override
  void logRequest(RequestOptions options) {
    final url = '${options.baseUrl}${options.path}';
    final headers = '${options.headers}';
    final requestData = '${options.data}';
    log('[ URL: $url ]');
    log('[ Headers: $headers ]');
    log('[ Request: $requestData ]');
  }
}

// Interface for logging responses
abstract class ResponseLogger {
  void logResponse(Response response);
}

// Implementation of ResponseLogger using Dio
class DioResponseLogger implements ResponseLogger {
  @override
  void logResponse(Response response) {
    final responseData = '${response.data}';
    log('[ Response: $responseData ]');
  }
}

// Interface for logging errors
abstract class ErrorLogger {
  void logError(DioException error);
}

// Implementation of ErrorLogger for Dio exceptions
class DioErrorLogger implements ErrorLogger {
  @override
  void logError(DioException error) {
    log('[ Error ] $error');
    log('[ Error Response] ${error.response}');
  }
}
