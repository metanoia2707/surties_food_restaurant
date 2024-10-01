import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/notification/domain/models/notification_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class NotificationRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  NotificationRepository(
      {required this.apiClient, required this.sharedPreferences});

  Future<List<NotificationModel>?> getList() async {
    List<NotificationModel>? notificationList;
    Response response = await apiClient.getData(AppConstants.notificationUri);
    if (response.statusCode == 200) {
      notificationList = [];
      response.body.forEach((notify) {
        NotificationModel notification = NotificationModel.fromJson(notify);
        notification.title = notify['data']['title'];
        notification.description = notify['data']['description'];
        notification.imageFullUrl = notify['image_full_url'];
        notificationList!.add(notification);
      });
    }
    return notificationList;
  }

  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.notificationCount, count);
  }

  int? getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.notificationCount);
  }

  Future add(value) {
    throw UnimplementedError();
  }

  Future delete({int? id}) {
    throw UnimplementedError();
  }

  Future get(int id) {
    throw UnimplementedError();
  }

  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }
}
