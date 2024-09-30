import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:surties_food_restaurant/features/profile/domain/models/profile_model.dart';

abstract class ProfileServiceInterface {
  Future<dynamic> getProfileInfo();
  Future<dynamic> deleteVendor();
  void setNotificationActive(bool isActive);
  bool isNotificationActive();
  String getUserToken();
  Future<bool> updateProfile(
      ProfileModel userInfoModel, XFile? data, String token);
}
