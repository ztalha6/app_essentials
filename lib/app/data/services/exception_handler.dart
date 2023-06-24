import 'package:app_essentials/core/api/interceptor/api_interceptor.dart';

import 'snackbar_manager.dart';

class ExceptionHandler {
  void handle(Object e) {
    if (e is BadRequestException ||
        e is UnauthorizedException ||
        e is InternalServerErrorException ||
        e is NoInternetConnectionException ||
        e is DeadlineExceededException) {
      SnackbarManager().showAlertSnackbar(e.toString());
    }
  }
}
