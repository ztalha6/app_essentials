import 'package:app_essentials/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class BaseWidget extends StatelessWidget {
  final String initalRoute;
  final List<GetPage<dynamic>>? getPages;
  final AppTheme? theme;

  const BaseWidget(this.initalRoute, this.getPages, {super.key, this.theme});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: GetMaterialApp(
            // translations: LocalizationService(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en', 'US'),
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            initialRoute: initalRoute,
            getPages: getPages,
            theme: (theme ?? AppTheme()).getAppTheme(context),
          ),
        );
      },
    );
  }
}
