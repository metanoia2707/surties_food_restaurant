import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surties_food_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:surties_food_restaurant/features/language/domain/models/language_model.dart';
import 'package:surties_food_restaurant/features/language/domain/repositories/language_repository.dart';
import 'package:surties_food_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:surties_food_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class LocalizationController extends GetxController implements GetxService {
  final LanguageRepository languageRepository;

  LocalizationController({required this.languageRepository}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!,
      AppConstants.languages[0].countryCode);
  Locale get locale => _locale;

  bool _isLtr = true;
  bool get isLtr => _isLtr;

  int _selectedLanguageIndex = 0;
  int get selectedLanguageIndex => _selectedLanguageIndex;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale, {bool fromBottomSheet = false}) {
    Get.updateLocale(locale);
    _locale = locale;
    _locale.languageCode == 'ar' ? _isLtr = false : _isLtr = true;
    languageRepository.updateHeader(_locale);

    if (!fromBottomSheet) {
      saveLanguage(_locale);
    }

    if (Get.find<AuthController>().isLoggedIn() && !fromBottomSheet) {
      Get.find<RestaurantController>().getProductList('1', 'all');
      Get.find<ProfileController>().getProfile();
    }
    update();
  }

  void setSelectLanguageIndex(int index) {
    _selectedLanguageIndex = index;
    update();
  }

  void loadCurrentLanguage() async {
    _locale = languageRepository.getLocaleFromSharedPref();
    _isLtr = _locale.languageCode != 'ar';
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (_locale.languageCode == AppConstants.languages[index].languageCode) {
        _selectedLanguageIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    languageRepository.saveLanguage(locale);
  }

  void saveCacheLanguage(Locale? locale) {
    languageRepository.saveCacheLanguage(
        locale ?? languageRepository.getLocaleFromSharedPref());
  }

  Locale getCacheLocaleFromSharedPref() {
    return languageRepository.getCacheLocaleFromSharedPref();
  }

  void searchSelectedLanguage() {
    for (var language in AppConstants.languages) {
      if (language.languageCode!
          .toLowerCase()
          .contains(_locale.languageCode.toLowerCase())) {
        _selectedLanguageIndex = AppConstants.languages.indexOf(language);
      }
    }
  }
}
