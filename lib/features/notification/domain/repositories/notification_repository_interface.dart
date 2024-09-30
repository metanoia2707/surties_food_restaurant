import 'package:surties_food_restaurant/interface/repository_interface.dart';

abstract class NotificationRepositoryInterface implements RepositoryInterface {
  void saveSeenNotificationCount(int count);
  int? getSeenNotificationCount();
}
