import 'package:app_essentials/core/api/logger/api_logger.dart';
import 'package:app_essentials/core/api/error_handler/dio_error_handler.dart';
import 'package:dio/dio.dart';

// The main DioInterceptor class
class DioInterceptor extends Interceptor {
  final Dio dio;
  final bool enableLogging;
  final RequestLogger requestLogger;
  final ResponseLogger responseLogger;
  final ErrorLogger errorLogger;
  final ErrorHandler errorHandler;

  DioInterceptor(
    this.dio, {
    this.enableLogging = true,
    RequestLogger? requestLogger,
    ResponseLogger? responseLogger,
    ErrorLogger? errorLogger,
    ErrorHandler? errorHandler,
  })  : requestLogger = requestLogger ?? DioRequestLogger(),
        responseLogger = responseLogger ?? DioResponseLogger(),
        errorLogger = errorLogger ?? DioErrorLogger(),
        errorHandler = errorHandler ?? DioErrorHandler();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    if (enableLogging) {
      requestLogger.logRequest(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    if (enableLogging) {
      responseLogger.logResponse(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enableLogging) {
      errorLogger.logError(err);
    }
    errorHandler.handleException(err);
    handler.next(err);
  }
}
