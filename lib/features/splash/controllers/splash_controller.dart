import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:surties_food_restaurant/common/models/config_model.dart';
import 'package:surties_food_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:surties_food_restaurant/features/splash/domain/repositories/splash_repository.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepository splashRepository;
  SplashController({required this.splashRepository});

  ConfigModel? _configModel;
  ConfigModel? get configModel => _configModel;

  final DateTime _currentTime = DateTime.now();
  DateTime get currentTime => _currentTime;

  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  Future<bool> getConfigData() async {
    ConfigModel? configModel = await splashRepository.getConfigData();
    bool isSuccess = false;
    if (configModel != null) {
      _configModel = configModel;
      isSuccess = true;
      Get.find<RestaurantController>().setOrderStatus(
          _configModel!.instantOrder!, _configModel!.scheduleOrder!);
    }
    update();
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepository.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepository.removeSharedData();
  }

  bool showIntro() {
    return splashRepository.showIntro();
  }

  void setIntro(bool intro) {
    splashRepository.setIntro(intro);
  }

  void initialConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  bool isRestaurantClosed() {
    DateTime open = DateFormat('hh:mm').parse('');
    DateTime close = DateFormat('hh:mm').parse('');
    DateTime openTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, open.hour, open.minute);
    DateTime closeTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, close.hour, close.minute);
    if (closeTime.isBefore(openTime)) {
      closeTime = closeTime.add(const Duration(days: 1));
    }
    if (_currentTime.isAfter(openTime) && _currentTime.isBefore(closeTime)) {
      return false;
    } else {
      return true;
    }
  }
}
