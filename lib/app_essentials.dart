library app_essentials;

import 'package:flutter/material.dart';

import 'app/data/widgets/base_widget.dart';
import 'app/routes/app_pages.dart';
import 'core/env/env_setup.dart';

interface class AppEssentials {
  Future<void> main({Future<void> Function()? additionalSetup}) async {
    WidgetsFlutterBinding.ensureInitialized();
    additionalSetup ?? ();
    Environment(
      devApiBaseUrl: "http://www.abc.com",
    ).initialize();
    runApp(const BaseWidget(ERoutes.SPLASH));
  }
}
