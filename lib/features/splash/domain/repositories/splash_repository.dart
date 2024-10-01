import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/models/config_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class SplashRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  SplashRepository({required this.apiClient, required this.sharedPreferences});

  Future<ConfigModel?> getConfigData() async {
    ConfigModel? configModel;
    Response response = await apiClient.getData(AppConstants.configUri);
    if (response.statusCode == 200) {
      configModel = ConfigModel.fromJson(response.body);
    }
    return configModel;
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences.containsKey(AppConstants.theme)) {
      return sharedPreferences.setBool(AppConstants.theme, false);
    }
    if (!sharedPreferences.containsKey(AppConstants.countryCode)) {
      return sharedPreferences.setString(
          AppConstants.countryCode, AppConstants.languages[0].countryCode!);
    }
    if (!sharedPreferences.containsKey(AppConstants.languageCode)) {
      return sharedPreferences.setString(
          AppConstants.languageCode, AppConstants.languages[0].languageCode!);
    }
    if (!sharedPreferences.containsKey(AppConstants.notification)) {
      return sharedPreferences.setBool(AppConstants.notification, true);
    }
    if (!sharedPreferences.containsKey(AppConstants.intro)) {
      return sharedPreferences.setBool(AppConstants.intro, true);
    }
    if (!sharedPreferences.containsKey(AppConstants.intro)) {
      return sharedPreferences.setInt(AppConstants.notificationCount, 0);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  bool showIntro() {
    return sharedPreferences.getBool(AppConstants.intro) ?? true;
  }

  void setIntro(bool intro) {
    sharedPreferences.setBool(AppConstants.intro, intro);
  }

  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  Future delete({int? id}) {
    // TODO: implement delete
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
