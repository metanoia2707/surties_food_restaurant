import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:surties_food_restaurant/features/advertisement/controllers/advertisement_controller.dart';
import 'package:surties_food_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:surties_food_restaurant/features/chat/controllers/chat_controller.dart';
import 'package:surties_food_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:surties_food_restaurant/features/dashboard/widgets/new_request_dialog_widget.dart';
import 'package:surties_food_restaurant/features/order/controllers/order_controller.dart';
import 'package:surties_food_restaurant/helper/custom_print_helper.dart';
import 'package:surties_food_restaurant/helper/route_helper.dart';
import 'package:surties_food_restaurant/helper/user_type.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class NotificationHelper {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: (NotificationResponse load) async {
      try {
        if (load.payload!.isNotEmpty) {
          NotificationBodyModel payload =
              NotificationBodyModel.fromJson(jsonDecode(load.payload!));

          if (payload.notificationType == NotificationType.order) {
            Get.toNamed(RouteHelper.getOrderDetailsRoute(payload.orderId));
          } else if (payload.notificationType == NotificationType.general) {
            Get.toNamed(
                RouteHelper.getNotificationRoute(fromNotification: true));
          } else if (payload.notificationType ==
              NotificationType.advertisement) {
            Get.toNamed(RouteHelper.getAdvertisementListRoute());
          } else {
            customPrint('message enter');
            Get.toNamed(RouteHelper.getChatRoute(
              notificationBody: payload,
              conversationId: payload.conversationId,
            ));
          }
        }
      } catch (_) {}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      customPrint("onMessage: ${message.data}");
      customPrint("onMessage message type:${message.data['type']}");

      if (message.data['type'] == 'message' &&
          Get.currentRoute.startsWith(RouteHelper.chatScreen)) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<ChatController>().getConversationList(1);
          if (Get.find<ChatController>()
                  .messageModel!
                  .conversation!
                  .id
                  .toString() ==
              message.data['conversation_id'].toString()) {
            Get.find<ChatController>().getMessages(
              1,
              NotificationBodyModel(
                notificationType: NotificationType.message,
                customerId: message.data['sender_type'] == UserType.user.name
                    ? 0
                    : null,
                deliveryManId:
                    message.data['sender_type'] == UserType.delivery_man.name
                        ? 0
                        : null,
              ),
              null,
              int.parse(message.data['conversation_id'].toString()),
            );
          } else {
            NotificationHelper.showNotification(
                message, flutterLocalNotificationsPlugin);
          }
        }
      } else if (message.data['type'] == 'message' &&
          Get.currentRoute.startsWith(RouteHelper.conversationListScreen)) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<ChatController>().getConversationList(1);
        }
        NotificationHelper.showNotification(
            message, flutterLocalNotificationsPlugin);
      } else {
        NotificationHelper.showNotification(
            message, flutterLocalNotificationsPlugin);

        if (message.data['type'] == 'new_order' ||
            message.data['title'] == 'New order placed') {
          Get.find<OrderController>().getPaginatedOrders(1, true);
          Get.find<OrderController>().getCurrentOrders();

          Get.dialog(const NewRequestDialogWidget());
        } else if (message.data['type'] == 'advertisement') {
          Get.find<AdvertisementController>().getAdvertisementList('1', 'all');
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      customPrint("onOpenApp: ${message.data}");
      customPrint("onOpenApp message type:${message.data['type']}");
      try {
        NotificationBodyModel notificationBody =
            convertNotification(message.data);

        if (notificationBody.notificationType == NotificationType.order) {
          Get.toNamed(RouteHelper.getOrderDetailsRoute(
              int.parse(message.data['order_id'])));
        } else if (notificationBody.notificationType ==
            NotificationType.general) {
          Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true));
        } else {
          Get.toNamed(RouteHelper.getChatRoute(
              notificationBody: notificationBody,
              conversationId: notificationBody.conversationId));
        }
      } catch (_) {}
    });
  }

  static Future<void> showNotification(
      RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
    if (!GetPlatform.isIOS) {
      String? title;
      String? body;
      String? image;
      NotificationBodyModel notificationBody;

      title = message.data['title'];
      body = message.data['body'] ?? '';
      notificationBody = convertNotification(message.data);

      image = (message.data['image'] != null &&
              message.data['image'].isNotEmpty)
          ? message.data['image'].startsWith('http')
              ? message.data['image']
              : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}'
          : null;

      if (image != null && image.isNotEmpty) {
        try {
          await showBigPictureNotificationHiddenLargeIcon(
              title, body, notificationBody, image, fln);
        } catch (e) {
          await showBigTextNotification(title, body!, notificationBody, fln);
        }
      } else {
        await showBigTextNotification(title, body!, notificationBody, fln);
      }
    }
  }

  static Future<void> showTextNotification(
      String title,
      String body,
      NotificationBodyModel? notificationBody,
      FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'stackfood',
      'stackfood',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics,
        payload: notificationBody != null
            ? jsonEncode(notificationBody.toJson())
            : null);
  }

  static Future<void> showBigTextNotification(
      String? title,
      String body,
      NotificationBodyModel? notificationBody,
      FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'stackfood',
      'stackfood',
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics,
        payload: notificationBody != null
            ? jsonEncode(notificationBody.toJson())
            : null);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      String? title,
      String? body,
      NotificationBodyModel? notificationBody,
      String image,
      FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath =
        await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'stackfood',
      'stackfood',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      priority: Priority.max,
      playSound: true,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics,
        payload: notificationBody != null
            ? jsonEncode(notificationBody.toJson())
            : null);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBodyModel convertNotification(Map<String, dynamic> data) {
    if (data['type'] == 'general') {
      return NotificationBodyModel(notificationType: NotificationType.general);
    } else if (data['type'] == 'advertisement') {
      return NotificationBodyModel(
          notificationType: NotificationType.advertisement);
    } else if (data['type'] == 'new_order' ||
        data['type'] == 'New order placed' ||
        data['type'] == 'order_status') {
      return NotificationBodyModel(
          orderId: int.parse(data['order_id']),
          notificationType: NotificationType.order);
    } else {
      return NotificationBodyModel(
        orderId: (data['order_id'] != null && data['order_id'].isNotEmpty)
            ? int.parse(data['order_id'])
            : null,
        conversationId: (data['conversation_id'] != null &&
                data['conversation_id'].isNotEmpty)
            ? int.parse(data['conversation_id'])
            : null,
        notificationType: NotificationType.message,
        type: data['sender_type'] == UserType.delivery_man.name
            ? UserType.delivery_man.name
            : UserType.customer.name,
      );
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  customPrint("onBackground: ${message.data}");
  // var androidInitialize = new AndroidInitializationSettings('notification_icon');
  // var iOSInitialize = new IOSInitializationSettings();
  // var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
}
