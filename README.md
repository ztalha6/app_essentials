<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Flutter App Essentials

Flutter App Essentials is a comprehensive package that aims to accelerate app development by providing essential features and utilities. It includes authentication management, API integration, exception handling, and more. With Flutter Fast App, developers can jumpstart their projects and focus on building great user experiences.

## Features

- **Auth Repository**: A repository for managing user authentication, including sign-in, sign-up, password reset, and user profile management.
- **User Manager**: A utility for managing user-related data and interactions, such as user preferences, profile updates, and access control.
- **Token Manager**: A secure token management system for handling user authentication tokens and refreshing expired tokens.
- **API Layers**: Abstracted layers for handling API requests and responses, including authentication headers and error handling.
- **Concise main.dart File**: A streamlined main.dart file with boilerplate code, app initialization, and routing setup.
- **Authentication Logic**: Pre-implemented authentication logic for handling login, registration, session management, and user state.
- **Exception Handler**: A centralized exception handling mechanism for catching and handling errors in a unified way.
- **Snackbar Handler**: A utility for displaying snackbars and toast messages, providing a consistent user feedback mechanism.

## Installation

To use App Essentials in your Flutter project, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  app_essentials: ^1.0.0
```

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart

import 'package:flutter/material.dart';
import 'package:app_essentials/app_essentials.dart';

void main() {
  AppEssentials().main();
}

```

## Contribution

Contributions are welcome! If you find any issues or have suggestions for improvement, please create a new issue or submit a pull request on the GitHub repository.

## License

This project is licensed under the MIT License.
