import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/models/config_model.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/auth/domain/repositories/auth_repository.dart';
import 'package:surties_food_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:surties_food_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:surties_food_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:surties_food_restaurant/helper/route_helper.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _notification = true;

  bool get notification => _notification;

  ProfileModel? _profileModel;

  ProfileModel? get profileModel => _profileModel;

  XFile? _pickedFile;

  XFile? get pickedFile => _pickedFile;

  XFile? _pickedLogo;

  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;

  XFile? get pickedCover => _pickedCover;

  String? _subscriptionType;

  String? get subscriptionType => _subscriptionType;

  String? _expiredToken;

  String? get expiredToken => _expiredToken;

  double _storeStatus = 0.4;

  double get storeStatus => _storeStatus;

  String _storeMinTime = '--';

  String get storeMinTime => _storeMinTime;

  String _storeMaxTime = '--';

  String get storeMaxTime => _storeMaxTime;

  String _storeTimeUnit = 'minute';

  String get storeTimeUnit => _storeTimeUnit;

  bool _showPassView = false;

  bool get showPassView => _showPassView;

  bool _lengthCheck = false;

  bool get lengthCheck => _lengthCheck;

  bool _numberCheck = false;

  bool get numberCheck => _numberCheck;

  bool _uppercaseCheck = false;

  bool get uppercaseCheck => _uppercaseCheck;

  bool _lowercaseCheck = false;

  bool get lowercaseCheck => _lowercaseCheck;

  bool _spatialCheck = false;

  bool get spatialCheck => _spatialCheck;

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  List<Data>? _dataList;

  List<Data>? get dataList => _dataList;

  List<dynamic>? _additionalList;

  List<dynamic>? get additionalList => _additionalList;

  void setJoinUsPageData({bool willUpdate = true}) {
    _dataList = [];
    _additionalList = [];
    if (Get.find<SplashController>()
            .configModel!
            .restaurantAdditionalJoinUsPageData !=
        null) {
      for (var data in Get.find<SplashController>()
          .configModel!
          .restaurantAdditionalJoinUsPageData!
          .data!) {
        int index = Get.find<SplashController>()
            .configModel!
            .restaurantAdditionalJoinUsPageData!
            .data!
            .indexOf(data);
        _dataList!.add(data);
        if (data.fieldType == 'text' ||
            data.fieldType == 'number' ||
            data.fieldType == 'email' ||
            data.fieldType == 'phone') {
          _additionalList!.add(TextEditingController());
        } else if (data.fieldType == 'date') {
          _additionalList!.add(null);
        } else if (data.fieldType == 'check_box') {
          _additionalList!.add([]);
          if (data.checkData != null) {
            for (int i = 0; i < data.checkData!.length; i++) {
              _additionalList![index].add(0);
            }
          }
        } else if (data.fieldType == 'file') {
          _additionalList!.add([]);
        }
      }
    }
    if (willUpdate) {
      update();
    }
  }

  void setAdditionalDate(int index, String date) {
    _additionalList![index] = date;
    update();
  }

  void setAdditionalCheckData(int index, int i, String date) {
    if (_additionalList![index][i] == date) {
      _additionalList![index][i] = 0;
    } else {
      _additionalList![index][i] = date;
    }
    update();
  }

  void removeAdditionalFile(int index, int subIndex) {
    _additionalList![index].removeAt(subIndex);
    update();
  }

  Future<void> pickFile(int index, MediaData mediaData) async {
    FilePickerResult? result = await authRepository.picFile(mediaData);
    if (result != null) {
      _additionalList![index].add(result);
    }
    update();
  }

  Future<ResponseModel?> login(String? email, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepository.login(email, password);
    _profileModel = authRepository.getProfileModel(response,
        Get.find<SplashController>().configModel!.businessPlan!.subscription);
    _subscriptionType = authRepository.getSubscriptionType(response);
    _expiredToken = authRepository.getExpiredToken(response,
        Get.find<SplashController>().configModel!.businessPlan!.subscription);
    ResponseModel? responseModel = await authRepository.manageLogin(response,
        Get.find<SplashController>().configModel!.businessPlan!.subscription);
    _isLoading = false;
    update();
    return responseModel;
  }

  void pickImageForRegistration(bool isLogo, bool isRemove) async {
    if (isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    } else {
      if (isLogo) {
        _pickedLogo = await authRepository.pickImageFromGallery();
      } else {
        _pickedCover = await authRepository.pickImageFromGallery();
      }
      update();
    }
  }

  Future<void> updateToken() async {
    await authRepository.updateToken();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authRepository.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepository.clearSharedData();
  }

  void saveUserCredentials(String number, String password) {
    authRepository.saveUserCredentials(number, password);
  }

  String getUserNumber() {
    return authRepository.getUserNumber();
  }

  String getUserPassword() {
    return authRepository.getUserPassword();
  }

  Future<bool> clearUserCredentials() async {
    return authRepository.clearUserCredentials();
  }

  String getUserToken() {
    return authRepository.getUserToken();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authRepository.setNotificationActive(isActive);
    update();
    return _notification;
  }

  void initData() {
    _pickedFile = null;
  }

  String camelCaseToSentence(String text) {
    var result = text.replaceAll('_', " ");
    var finalResult = result[0].toUpperCase() + result.substring(1);
    return finalResult;
  }

  Future<void> toggleRestaurantClosedStatus() async {
    bool isSuccess = await authRepository.toggleRestaurantClosedStatus();
    if (isSuccess) {
      Get.find<ProfileController>().getProfile();
    }
    update();
  }

  Future deleteVendor() async {
    _isLoading = true;
    update();
    bool isSuccess = await authRepository.delete();
    _isLoading = false;
    if (isSuccess) {
      showCustomSnackBar('your_account_remove_successfully'.tr, isError: false);
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    } else {
      Get.back();
    }
  }

  Future<void> registerRestaurant(
      Map<String, String> data,
      List<FilePickerResult> additionalDocuments,
      List<String> inputTypeList) async {
    _isLoading = true;
    update();
    List<MultipartDocument> multiPartsDocuments = authRepository
        .prepareMultipartDocuments(inputTypeList, additionalDocuments);
    await authRepository.registerRestaurant(
        data, _pickedLogo, _pickedCover, multiPartsDocuments);
    _isLoading = false;
    update();
  }

  void storeStatusChange(double value, {bool willUpdate = true}) {
    _storeStatus = value;
    if (willUpdate) {
      update();
    }
  }

  void showHidePass({bool willUpdate = true}) {
    _showPassView = !_showPassView;
    if (willUpdate) {
      update();
    }
  }

  void minTimeChange(String time) {
    _storeMinTime = time;
    update();
  }

  void maxTimeChange(String time) {
    _storeMaxTime = time;
    update();
  }

  void timeUnitChange(String unit) {
    _storeTimeUnit = unit;
    update();
  }

  void validPassCheck(String pass, {bool willUpdate = true}) {
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if (pass.length > 7) {
      _lengthCheck = true;
    }
    if (pass.contains(RegExp(r'[a-z]'))) {
      _lowercaseCheck = true;
    }
    if (pass.contains(RegExp(r'[A-Z]'))) {
      _uppercaseCheck = true;
    }
    if (pass.contains(RegExp(r'[ .!@#$&*~^%]'))) {
      _spatialCheck = true;
    }
    if (pass.contains(RegExp(r'[\d+]'))) {
      _numberCheck = true;
    }
    if (willUpdate) {
      update();
    }
  }
}
