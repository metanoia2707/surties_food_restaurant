import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class ProfileRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ProfileRepository({required this.apiClient, required this.sharedPreferences});

  Future<ProfileModel?> getProfileInfo() async {
    ProfileModel? profileModel;
    Response response = await apiClient.getData(AppConstants.profileUri);
    if (response.statusCode == 200) {
      profileModel = ProfileModel.fromJson(response.body);
    }
    return profileModel;
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  void setNotificationActive(bool isActive) {
    if (isActive) {
      _updateToken();
    } else {
      if (!GetPlatform.isWeb) {
        _updateToken(notificationDeviceToken: '@');
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        FirebaseMessaging.instance.unsubscribeFromTopic(
            sharedPreferences.getString(AppConstants.zoneTopic)!);
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  Future<Response> _updateToken({String notificationDeviceToken = ''}) async {
    String? deviceToken;
    if (notificationDeviceToken.isEmpty) {
      if (GetPlatform.isIOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = await _saveDeviceToken();
        }
      } else {
        deviceToken = await _saveDeviceToken();
      }
      if (!GetPlatform.isWeb) {
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
        FirebaseMessaging.instance.subscribeToTopic(
            sharedPreferences.getString(AppConstants.zoneTopic)!);
      }
    }
    return await apiClient.postData(
        AppConstants.tokenUri,
        {
          "_method": "put",
          "token": getUserToken(),
          "fcm_token": notificationDeviceToken.isNotEmpty
              ? notificationDeviceToken
              : deviceToken
        },
        handleError: false);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '';
    if (!GetPlatform.isWeb) {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    }
    return deviceToken;
  }

  Future<bool> updateProfile(
      ProfileModel userInfoModel, XFile? data, String token) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put',
      'f_name': userInfoModel.fName!,
      'l_name': userInfoModel.lName!,
      'phone': userInfoModel.phone!,
      'token': getUserToken()
    });
    Response response = await apiClient.postMultipartData(
        AppConstants.updateProfileUri,
        fields,
        [MultipartBody('image', data)],
        []);
    return (response.statusCode == 200);
  }

  Future<ResponseModel> delete({int? id}) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(
        AppConstants.vendorRemove, {"_method": "delete"},
        handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  Future get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  Future getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
