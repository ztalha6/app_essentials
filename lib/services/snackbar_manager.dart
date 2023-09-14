import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// An abstract class representing the configuration for a snackbar.
abstract class SnackbarConfig {
  /// The background color of the snackbar.
  Color get backgroundColor;

  /// The widget to display as the title of the snackbar.
  Widget get titleText;

  /// The widget to display as the message of the snackbar.
  Widget get messageText;

  /// The duration for which the snackbar should be displayed.
  Duration get duration;

  /// The main button to display on the snackbar.
  TextButton? get mainButton;
}

/// A class responsible for managing and displaying snackbars.
class SnackbarManager {
  /// Displays a snackbar using the provided [config].
  void showSnackbar(SnackbarConfig config) {
    Get.snackbar(
      '',
      '',
      backgroundColor: config.backgroundColor,
      titleText: config.titleText,
      messageText: config.messageText,
      duration: config.duration,
      mainButton: config.mainButton,
    );
  }

  /// Displays a success snackbar with the given [message].
  void showSuccessSnackbar(String message) {
    showSnackbar(SuccessSnackbarConfig(message));
  }

  /// Displays an alert snackbar with the given [message].
  void showAlertSnackbar(String message,
      {String? buttonText, void Function()? buttonOnPressed}) {
    showSnackbar(AlertSnackbarConfig(message,
        buttonText: buttonText, buttonOnPressed: buttonOnPressed));
  }

  /// Displays an info snackbar with the given [message].
  void showInfoSnackbar(String message,
      {String? buttonText, void Function()? buttonOnPressed}) {
    showSnackbar(InfoSnackbarConfig(message,
        buttonText: buttonText, buttonOnPressed: buttonOnPressed));
  }
}

/// A configuration for a success snackbar.
class SuccessSnackbarConfig implements SnackbarConfig {
  final String message;

  SuccessSnackbarConfig(this.message);

  @override
  Color get backgroundColor => Theme.of(Get.context!).primaryColor;

  @override
  Widget get titleText => Container();

  @override
  Widget get messageText => Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Gotham',
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  @override
  Duration get duration => const Duration(seconds: 2);

  @override
  TextButton? get mainButton => null;
}

/// A configuration for an alert snackbar.
class AlertSnackbarConfig implements SnackbarConfig {
  final String message;
  final String? buttonText;
  final void Function()? buttonOnPressed;

  AlertSnackbarConfig(this.message, {this.buttonText, this.buttonOnPressed});

  @override
  Color get backgroundColor => const Color(0xffFF5C5C);

  @override
  Widget get titleText => Container();

  @override
  Widget get messageText => Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Gotham',
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  @override
  Duration get duration => const Duration(seconds: 2);

  @override
  TextButton? get mainButton => buttonText != null
      ? TextButton(
          onPressed: buttonOnPressed,
          child: Text(buttonText!),
        )
      : null;
}

/// A configuration for an info snackbar.
class InfoSnackbarConfig implements SnackbarConfig {
  final String message;
  final String? buttonText;
  final void Function()? buttonOnPressed;

  InfoSnackbarConfig(this.message, {this.buttonText, this.buttonOnPressed});

  @override
  Color get backgroundColor => Colors.white;

  @override
  Widget get titleText => Container();

  @override
  Widget get messageText => Row(
        children: [
          Icon(
            CupertinoIcons.info_circle,
            size: 30,
            color: Theme.of(Get.context!).primaryColor,
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(message)),
        ],
      );

  @override
  Duration get duration => const Duration(seconds: 2);

  @override
  TextButton? get mainButton => buttonText != null
      ? TextButton(
          onPressed: buttonOnPressed,
          child: Text(buttonText!),
        )
      : null;
}
