// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_essentials/core/api/interceptor/api_interceptor.dart';

import 'snackbar_manager.dart';

/// The [ExceptionHandler] class handles exceptions in the application and performs appropriate actions based on the exception type.
///
/// It is responsible for displaying alert messages using [SnackbarManager] for specific types of exceptions.
/// This class follows Flutter's standard guidelines for exception handling.
class ExceptionHandler {
  SnackbarManager snackbarManager;

  /// Constructs an [ExceptionHandler] instance with an optional [SnackbarManager].
  ///
  /// If [snackbarManager] is not provided, a default [SnackbarManager] instance will be used.
  ExceptionHandler(SnackbarManager? snackbarManager)
      : snackbarManager = snackbarManager ?? SnackbarManager();

  /// Handles the given exception [e] and performs the necessary actions based on the exception type.
  ///
  /// - If the exception is an [UnauthorizedException], it displays an unauthorized alert message using the [SnackbarManager].
  /// - For [BadRequestException], [InternalServerErrorException], [NoInternetConnectionException], and [DeadlineExceededException],
  ///   it displays an alert message using the [SnackbarManager].
  void handle(Object e) {
    if (e is UnauthorizedException) {
      snackbarManager.showAlertSnackbar(e.toString());
      // Navigates to the sign-in screen
      return;
    }
    if (e is BadRequestException ||
        e is InternalServerErrorException ||
        e is NoInternetConnectionException ||
        e is DeadlineExceededException) {
      snackbarManager.showAlertSnackbar(e.toString());
    }
  }
}
