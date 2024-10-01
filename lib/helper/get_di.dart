import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/controllers/theme_controller.dart';
import 'package:surties_food_restaurant/features/addon/controllers/addon_controller.dart';
import 'package:surties_food_restaurant/features/addon/domain/repositories/addon_repository.dart';
import 'package:surties_food_restaurant/features/advertisement/controllers/advertisement_controller.dart';
import 'package:surties_food_restaurant/features/advertisement/domain/repositories/advertisement_repository.dart';
import 'package:surties_food_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:surties_food_restaurant/features/auth/controllers/forgot_password_controller.dart';
import 'package:surties_food_restaurant/features/auth/controllers/location_controller.dart';
import 'package:surties_food_restaurant/features/auth/domain/repositories/auth_repository.dart';
import 'package:surties_food_restaurant/features/auth/domain/repositories/forgot_password_repository.dart';
import 'package:surties_food_restaurant/features/auth/domain/repositories/location_repository.dart';
import 'package:surties_food_restaurant/features/business/controllers/business_controller.dart';
import 'package:surties_food_restaurant/features/business/domain/repositories/business_repository.dart';
import 'package:surties_food_restaurant/features/campaign/controllers/campaign_controller.dart';
import 'package:surties_food_restaurant/features/campaign/domain/repositories/campaign_repository.dart';
import 'package:surties_food_restaurant/features/category/controllers/category_controller.dart';
import 'package:surties_food_restaurant/features/category/domain/repositories/category_repository.dart';
import 'package:surties_food_restaurant/features/chat/controllers/chat_controller.dart';
import 'package:surties_food_restaurant/features/chat/domain/repositories/chat_repository.dart';
import 'package:surties_food_restaurant/features/coupon/controllers/coupon_controller.dart';
import 'package:surties_food_restaurant/features/coupon/domain/repositories/coupon_repository.dart';
import 'package:surties_food_restaurant/features/deliveryman/controllers/deliveryman_controller.dart';
import 'package:surties_food_restaurant/features/deliveryman/domain/repositories/deliveryman_repository.dart';
import 'package:surties_food_restaurant/features/disbursement/controllers/disbursement_controller.dart';
import 'package:surties_food_restaurant/features/disbursement/domain/repositories/disbursement_repository.dart';
import 'package:surties_food_restaurant/features/expense/controllers/expense_controller.dart';
import 'package:surties_food_restaurant/features/expense/domain/repositories/expense_repository.dart';
import 'package:surties_food_restaurant/features/language/controllers/localization_controller.dart';
import 'package:surties_food_restaurant/features/language/domain/models/language_model.dart';
import 'package:surties_food_restaurant/features/language/domain/repositories/language_repository.dart';
import 'package:surties_food_restaurant/features/notification/controllers/notification_controller.dart';
import 'package:surties_food_restaurant/features/notification/domain/repositories/notification_repository.dart';
import 'package:surties_food_restaurant/features/order/controllers/order_controller.dart';
import 'package:surties_food_restaurant/features/order/domain/repositories/order_repository.dart';
import 'package:surties_food_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:surties_food_restaurant/features/payment/domain/repositories/payment_repository.dart';
import 'package:surties_food_restaurant/features/pos/controllers/pos_controller.dart';
import 'package:surties_food_restaurant/features/pos/domain/repositories/pos_repository.dart';
import 'package:surties_food_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:surties_food_restaurant/features/profile/domain/repositories/profile_repository.dart';
import 'package:surties_food_restaurant/features/reports/controllers/report_controller.dart';
import 'package:surties_food_restaurant/features/reports/domain/repositories/report_repository.dart';
import 'package:surties_food_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:surties_food_restaurant/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:surties_food_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:surties_food_restaurant/features/splash/domain/repositories/splash_repository.dart';
import 'package:surties_food_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:surties_food_restaurant/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  /// Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  /// Repo Interfaces
  AuthRepository authRepoInterface =
      AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => authRepoInterface);

  LocationRepository locationRepository =
      LocationRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => locationRepository);

  AddonRepository addonRepoInterface = AddonRepository(apiClient: Get.find());
  Get.lazyPut(() => addonRepoInterface);

  AdvertisementRepository advertisementRepository =
      AdvertisementRepository(apiClient: Get.find());
  Get.lazyPut(() => advertisementRepository);

  BusinessRepository businessPlanRepoInterface =
      BusinessRepository(apiClient: Get.find());
  Get.lazyPut(() => businessPlanRepoInterface);

  SubscriptionRepository subscriptionRepository =
      SubscriptionRepository(apiClient: Get.find());
  Get.lazyPut(() => subscriptionRepository);

  ProfileRepository profileRepository =
      ProfileRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => profileRepository);

  SplashRepository splashRepository =
      SplashRepository(sharedPreferences: Get.find(), apiClient: Get.find());
  Get.lazyPut(() => splashRepository);

  CampaignRepository campaignRepository =
      CampaignRepository(apiClient: Get.find());
  Get.lazyPut(() => campaignRepository);

  CategoryRepository categoryRepository =
      CategoryRepository(apiClient: Get.find());
  Get.lazyPut(() => categoryRepository);

  ChatRepository chatRepository =
      ChatRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => chatRepository);

  CouponRepository couponRepository = CouponRepository(apiClient: Get.find());
  Get.lazyPut(() => couponRepository);

  DeliverymanRepository deliverymanRepository =
      DeliverymanRepository(apiClient: Get.find());
  Get.lazyPut(() => deliverymanRepository);

  DisbursementRepository disbursementRepository =
      DisbursementRepository(apiClient: Get.find());
  Get.lazyPut(() => disbursementRepository);

  ExpenseRepository expenseRepository =
      ExpenseRepository(apiClient: Get.find());
  Get.lazyPut(() => expenseRepository);

  NotificationRepository notificationRepository = NotificationRepository(
      apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => notificationRepository);

  ReportRepository reportRepository = ReportRepository(apiClient: Get.find());
  Get.lazyPut(() => reportRepository);

  LanguageRepository languageRepository =
      LanguageRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => languageRepository);

  OrderRepository orderRepository =
      OrderRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => orderRepository);

  PosRepository posRepository = PosRepository(apiClient: Get.find());
  Get.lazyPut(() => posRepository);

  PaymentRepository paymentRepository =
      PaymentRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => paymentRepository);

  RestaurantRepository restaurantRepository =
      RestaurantRepository(apiClient: Get.find());
  Get.lazyPut(() => restaurantRepository);

  ForgotPasswordRepository forgotPasswordRepository = ForgotPasswordRepository(
      apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => forgotPasswordRepository);

  /// Controller
  Get.lazyPut(() => AuthController(authRepository: Get.find()));
  Get.lazyPut(() => LocationController(locationRepository: Get.find()));
  Get.lazyPut(() => AddonController(addonRepository: Get.find()));
  Get.lazyPut(
      () => AdvertisementController(advertisementRepository: Get.find()));
  Get.lazyPut(() => BusinessController(businessRepository: Get.find()));
  Get.lazyPut(() => SubscriptionController(subscriptionRepository: Get.find()));
  Get.lazyPut(() => ProfileController(profileRepository: Get.find()));
  Get.lazyPut(() => SplashController(splashRepository: Get.find()));
  Get.lazyPut(() => CampaignController(campaignRepository: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepository: Get.find()));
  Get.lazyPut(() => ChatController(chatRepository: Get.find()));
  Get.lazyPut(() => CouponController(couponRepository: Get.find()));
  Get.lazyPut(() => DeliveryManController(deliverymanRepository: Get.find()));
  Get.lazyPut(() => DisbursementController(disbursementRepository: Get.find()));
  Get.lazyPut(() => ExpenseController(expenseRepository: Get.find()));
  Get.lazyPut(() => LocalizationController(languageRepository: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepository: Get.find()));
  Get.lazyPut(() => ReportController(reportRepository: Get.find()));
  Get.lazyPut(() => OrderController(orderRepository: Get.find()));
  Get.lazyPut(() => PosController(posRepository: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => PaymentController(paymentRepository: Get.find()));
  Get.lazyPut(() => RestaurantController(restaurantRepository: Get.find()));
  Get.lazyPut(
      () => ForgotPasswordController(forgotPasswordRepository: Get.find()));

  /// Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        json;
  }
  return languages;
}
