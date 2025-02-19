import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/interface/repository_interface.dart';
import 'package:image_picker/image_picker.dart';

abstract class AuthRepositoryInterface implements RepositoryInterface {
  Future<dynamic> login(String? email, String password);
  Future<Response> otpLogin({required String phone, required String otp, required String verified});
  Future<bool> saveUserToken(String token, String zoneTopic);
  Future<dynamic> updateToken({String notificationDeviceToken = ''});
  bool isLoggedIn();
  Future<bool> clearSharedData();
  Future<void> saveUserCredentials(String number, String password);
  Future<void> saveUserNumberAndPassword(String number, String countryCode);
  String getUserNumber();
  String getUserCountryCode();
  String getUserPassword();
  Future<bool> clearUserCredentials();
  Future<bool> clearUserNumberAndPassword();
  String getUserToken();
  void setNotificationActive(bool isActive);
  Future<dynamic> toggleRestaurantClosedStatus();
  Future<dynamic> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument);
  Future<bool> saveIsRestaurantRegistration(bool status);
  bool getIsRestaurantRegistration();
}