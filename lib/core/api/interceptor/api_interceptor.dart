import 'dart:developer';

import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    log('[ URL: ${options.baseUrl}${options.path} ]');
    log('[ Headers: ${options.headers} ]');
    log('[ Request: ${options.data} ]');
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    log('[ Response: ${response.data} ]');
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('[ Error ] $err');
    log('[ Error Response] ${err.response}');
    if (err.response != null) {
      switch (err.response?.statusCode) {
        case 400:
          throw BadRequestException(err.requestOptions);
        case 401:
          if (err.response?.headers.value("x-auth-error") ==
              "InvalidCredentials") {
            throw InvalidCredentialsException(err.requestOptions);
          }
          throw UnauthorizedException(err.requestOptions);
        case 403:
          throw UnauthorizedException(err.requestOptions);
        case 404:
          throw NotFoundException(err.requestOptions);
        case 409:
          throw ConflictException(err.requestOptions);
        case 500:
          throw InternalServerErrorException(err.requestOptions);
      }
    }
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(err.requestOptions);
      case DioExceptionType.badCertificate:
        throw BadCertificateException(err.requestOptions);
      case DioExceptionType.badResponse:
        throw BadResponseException(err.requestOptions);
      case DioExceptionType.connectionError:
        throw ConnectionErrorException(err.requestOptions);
    }

    return handler.next(err);
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class BadCertificateException extends DioException {
  BadCertificateException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Bad certificate';
  }
}

class BadResponseException extends DioException {
  BadResponseException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Bad response';
  }
}

class ConnectionErrorException extends DioException {
  ConnectionErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Connection error';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class InvalidCredentialsException extends DioException {
  InvalidCredentialsException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid credentials';
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
