import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class LanguageRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LanguageRepository(
      {required this.apiClient, required this.sharedPreferences});

  void updateHeader(Locale locale) {
    apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token), locale.languageCode);
  }

  Locale getLocaleFromSharedPref() {
    return Locale(
        sharedPreferences.getString(AppConstants.languageCode) ??
            AppConstants.languages[0].languageCode!,
        sharedPreferences.getString(AppConstants.countryCode) ??
            AppConstants.languages[0].countryCode);
  }

  void saveLanguage(Locale locale) {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
  }

  void saveCacheLanguage(Locale locale) {
    sharedPreferences.setString(
        AppConstants.cacheLanguageCode, locale.languageCode);
    sharedPreferences.setString(
        AppConstants.cacheCountryCode, locale.countryCode!);
  }

  Locale getCacheLocaleFromSharedPref() {
    return Locale(
        sharedPreferences.getString(AppConstants.cacheLanguageCode) ??
            AppConstants.languages[0].languageCode!,
        sharedPreferences.getString(AppConstants.cacheCountryCode) ??
            AppConstants.languages[0].countryCode);
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

  Future getList() {
    throw UnimplementedError();
  }

  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }
}
