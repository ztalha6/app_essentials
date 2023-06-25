import 'package:flutter/material.dart';

import 'app/data/widgets/base_widget.dart';
import 'app/routes/app_pages.dart';
import 'core/env/env_setup.dart';

interface class AppEssentials {
  Future<void> main({
    Future<void> Function()? additionalSetup,
    String initailRoute = ERoutes.SPLASH,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    additionalSetup ?? ();
    Environment(
      devApiBaseUrl: "http://www.abc.com",
    ).initialize();
    runApp(BaseWidget(initailRoute));
  }
}
