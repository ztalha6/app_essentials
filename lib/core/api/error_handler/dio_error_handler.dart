// Interface for handling exceptions
import 'package:app_essentials/core/api/interceptor/exceptions.dart';
import 'package:dio/dio.dart';

abstract class ErrorHandler {
  void handleException(DioException error);
}

// Implementation of ErrorHandler for Dio exceptions
class DioErrorHandler implements ErrorHandler {
  @override
  void handleException(DioException error) {
    final requestOptions = error.requestOptions;

    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final Map<int, Function()> statusCodeExceptionMap = {
        400: () => throw BadRequestException(requestOptions),
        401: () => _handleUnauthorizedException(error),
        403: () => throw UnauthorizedException(requestOptions),
        404: () => throw NotFoundException(requestOptions),
        409: () => throw ConflictException(requestOptions),
        500: () => throw InternalServerErrorException(requestOptions),
      };

      statusCodeExceptionMap[statusCode]?.call();
      throw DioException(requestOptions: requestOptions);
    } else {
      _handleDioExceptionType(error.type, requestOptions);
    }
  }

  void _handleUnauthorizedException(DioException error) {
    final authError = error.response!.headers.value("x-auth-error");
    if (authError == "InvalidCredentials") {
      throw InvalidCredentialsException(error.requestOptions);
    }
    throw UnauthorizedException(error.requestOptions);
  }

  void _handleDioExceptionType(
      DioExceptionType errorType, RequestOptions requestOptions) {
    switch (errorType) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(requestOptions);
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(requestOptions);
      case DioExceptionType.badCertificate:
        throw BadCertificateException(requestOptions);
      case DioExceptionType.badResponse:
        throw BadResponseException(requestOptions);
      case DioExceptionType.connectionError:
        throw ConnectionErrorException(requestOptions);
      default:
        throw DioException(requestOptions: requestOptions);
    }
  }
}
