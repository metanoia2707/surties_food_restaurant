import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/models/config_model.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/business/screens/business_plan_screen.dart';
import 'package:surties_food_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:surties_food_restaurant/helper/route_helper.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class AuthRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepository({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(String? email, String password) async {
    return await apiClient.postData(
        AppConstants.loginUri, {"email": email, "password": password},
        handleError: false);
  }

  Future<bool> saveUserToken(String token, String zoneTopic) async {
    apiClient.token = token;
    apiClient.updateHeader(
        token, sharedPreferences.getString(AppConstants.languageCode));
    sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  Future<Response> updateToken({String notificationDeviceToken = ''}) async {
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
          "token": _getUserToken(),
          "fcm_token": notificationDeviceToken.isNotEmpty
              ? notificationDeviceToken
              : deviceToken
        },
        handleError: false);
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '';
    if (!GetPlatform.isWeb) {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    }
    return deviceToken;
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    if (!GetPlatform.isWeb) {
      apiClient.postData(AppConstants.tokenUri,
          {"_method": "put", "token": _getUserToken(), "fcm_token": '@'},
          handleError: false);
      FirebaseMessaging.instance.unsubscribeFromTopic(
          sharedPreferences.getString(AppConstants.zoneTopic)!);
    }
    await sharedPreferences.remove(AppConstants.token);
    await sharedPreferences.remove(AppConstants.userAddress);
    return true;
  }

  Future<void> saveUserCredentials(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  Future<bool> clearUserCredentials() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  void setNotificationActive(bool isActive) {
    if (isActive) {
      updateToken();
    } else {
      if (!GetPlatform.isWeb) {
        updateToken(notificationDeviceToken: '@');
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        FirebaseMessaging.instance.unsubscribeFromTopic(
            sharedPreferences.getString(AppConstants.zoneTopic)!);
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  Future<bool> toggleRestaurantClosedStatus() async {
    Response response =
        await apiClient.postData(AppConstants.updateRestaurantStatusUri, {});
    return (response.statusCode == 200);
  }

  Future<Response> register(Map<String, String> data, XFile? logo, XFile? cover,
      List<MultipartDocument> additionalDocument) async {
    return apiClient.postMultipartData(
      AppConstants.restaurantRegisterUri,
      data,
      [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)],
      additionalDocument,
    );
  }

  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  Future<bool> delete({int? id}) {
    return _deleteVendor();
  }

  Future<bool> _deleteVendor() async {
    Response response = await apiClient
        .postData(AppConstants.vendorRemove, {"_method": "delete"});
    return (response.statusCode == 200);
  }

  Future get(int id) {
    throw UnimplementedError();
  }

  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  Future getList() {
    throw UnimplementedError();
  }

  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo,
      XFile? cover, List<MultipartDocument> additionalDocument) async {
    Response response =
        await registerRestaurant(data, logo, cover, additionalDocument);
    if (response.statusCode == 200) {
      int? restaurantId = response.body['restaurant_id'];
      Get.off(() => BusinessPlanScreen(restaurantId: restaurantId));
    }
    return response;
  }

  Future<FilePickerResult?> picFile(MediaData mediaData) async {
    List<String> permission = [];
    if (mediaData.image == 1) {
      permission.add('jpg');
    }
    if (mediaData.pdf == 1) {
      permission.add('pdf');
    }
    if (mediaData.docs == 1) {
      permission.add('doc');
    }

    FilePickerResult? result;

    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: permission,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      if (result.files.single.size > 2000000) {
        result = null;
        showCustomSnackBar('please_upload_lower_size_file'.tr);
      } else {
        return result;
      }
    }
    return result;
  }

  Future<XFile?> pickImageFromGallery() async {
    XFile? pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      pickImage.length().then((value) {
        if (value > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          return pickImage;
        }
      });
    }
    return pickImage;
  }

  List<MultipartDocument> prepareMultipartDocuments(
      List<String> inputTypeList, List<FilePickerResult> additionalDocuments) {
    List<MultipartDocument> multiPartsDocuments = [];
    List<String> dataName = [];
    for (String data in inputTypeList) {
      dataName.add('additional_documents[$data]');
    }
    for (FilePickerResult file in additionalDocuments) {
      int index = additionalDocuments.indexOf(file);
      multiPartsDocuments.add(MultipartDocument('${dataName[index]}[]', file));
    }
    return multiPartsDocuments;
  }

  Future<ResponseModel?> manageLogin(
      Response response, int? subscription) async {
    ResponseModel? responseModel;
    if (response.statusCode == 200) {
      if (response.body['pending_payment'] != null) {
        Get.to(BusinessPlanScreen(
            restaurantId: null,
            paymentId: response.body['pending_payment']['id']));
      } else if (response.body['subscribed'] != null) {
        int? restaurantId = response.body['subscribed']['restaurant_id'];
        Get.to(() => BusinessPlanScreen(restaurantId: restaurantId));
        responseModel = ResponseModel(false, 'no');
      } else {
        saveUserToken(response.body['token'], response.body['zone_wise_topic']);
        await updateToken();
        responseModel = ResponseModel(true, 'successful');
      }
    } else if (response.statusCode == 205) {
      if (subscription == 1) {
        Get.toNamed(RouteHelper.getSubscriptionViewRoute());
      } else {
        responseModel = ResponseModel(
            false, 'subscription_not_available_please_contact_with_admin'.tr);
      }
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  String? getSubscriptionType(Response response) {
    String? subscriptionType;
    if (response.statusCode == 200 && response.body['subscribed'] != null) {
      subscriptionType = response.body['subscribed']['type'];
    }
    return subscriptionType;
  }

  String? getExpiredToken(Response response, int? subscription) {
    String? expiredToken;
    if (response.statusCode == 205 && subscription == 1) {
      expiredToken = response.body['token'];
    }
    return expiredToken;
  }

  ProfileModel? getProfileModel(Response response, int? subscription) {
    ProfileModel? profileModel;
    if (response.statusCode == 205 && subscription == 1) {
      profileModel = ProfileModel(
        restaurants: [
          Restaurant(id: int.parse(response.body['restaurant_id'].toString()))
        ],
        balance: response.body['balance']?.toDouble(),
        subscription: Subscription.fromJson(response.body['subscription']),
        subscriptionOtherData: SubscriptionOtherData.fromJson(
            response.body['subscription_other_data']),
      );
    }
    return profileModel;
  }
}
