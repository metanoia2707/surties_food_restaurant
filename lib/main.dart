import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:surties_food_restaurant/common/controllers/theme_controller.dart';
import 'package:surties_food_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:surties_food_restaurant/firebase_options.dart';
import 'package:surties_food_restaurant/helper/notification_helper.dart';
import 'package:surties_food_restaurant/helper/route_helper.dart';
import 'package:surties_food_restaurant/theme/dark_theme.dart';
import 'package:surties_food_restaurant/theme/light_theme.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';
import 'package:surties_food_restaurant/util/messages.dart';
import 'package:url_strategy/url_strategy.dart';

import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if (!GetPlatform.isWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await di.init();

  if (GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  NotificationBodyModel? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (_) {}

  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;

  const MyApp({super.key, required this.languages, required this.body});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.key,
        theme: themeController.darkTheme ? dark : light,
        locale: Locale(AppConstants.languages[0].languageCode!,
            AppConstants.languages[0].countryCode),
        translations: Messages(languages: languages),
        fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
            AppConstants.languages[0].countryCode),
        initialRoute: RouteHelper.getSplashRoute(body),
        getPages: RouteHelper.routes,
        defaultTransition: Transition.topLevel,
        transitionDuration: const Duration(milliseconds: 500),
        builder: (BuildContext context, widget) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!);
        },
      );
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// return GetBuilder<ThemeController>(builder: (themeController) {
// return GetBuilder<LocalizationController>(builder: (localizeController) {
// return GetMaterialApp(
// title: AppConstants.appName,
// debugShowCheckedModeBanner: false,
// navigatorKey: Get.key,
// theme: themeController.darkTheme ? dark : light,
// locale: localizeController.locale,
// translations: Messages(languages: languages),
// fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
// AppConstants.languages[0].countryCode),
// initialRoute: RouteHelper.getSplashRoute(body),
// getPages: RouteHelper.routes,
// defaultTransition: Transition.topLevel,
// transitionDuration: const Duration(milliseconds: 500),
// builder: (BuildContext context, widget) {
// return MediaQuery(
// data: MediaQuery.of(context)
//     .copyWith(textScaler: const TextScaler.linear(1.0)),
// child: widget!);
// },
// );
// });
// });
