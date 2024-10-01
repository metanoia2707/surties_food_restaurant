import 'package:get/get.dart';
import 'package:surties_food_restaurant/features/notification/domain/models/notification_model.dart';
import 'package:surties_food_restaurant/features/notification/domain/repositories/notification_repository.dart';
import 'package:surties_food_restaurant/helper/date_converter_helper.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepository notificationRepository;

  NotificationController({required this.notificationRepository});

  List<NotificationModel>? _notificationList;

  List<NotificationModel>? get notificationList => _notificationList;

  Future<void> getNotificationList() async {
    List<NotificationModel>? notificationList =
        await notificationRepository.getList();
    if (notificationList != null) {
      _notificationList = [];
      _notificationList!.addAll(notificationList);
      _notificationList!.sort((NotificationModel n1, NotificationModel n2) {
        return DateConverter.dateTimeStringToDate(n1.createdAt!)
            .compareTo(DateConverter.dateTimeStringToDate(n2.createdAt!));
      });
      _notificationList = _notificationList!.reversed.toList();
    }
    update();
  }

  void saveSeenNotificationCount(int count) {
    notificationRepository.saveSeenNotificationCount(count);
  }

  int? getSeenNotificationCount() {
    return notificationRepository.getSeenNotificationCount();
  }

  void clearNotification() {
    _notificationList = null;
  }
}
