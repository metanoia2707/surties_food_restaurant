import 'package:get/get.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/addon/domain/repositories/addon_repository.dart';
import 'package:surties_food_restaurant/features/restaurant/domain/models/product_model.dart';

class AddonController extends GetxController implements GetxService {
  final AddonRepository addonRepository;

  AddonController({required this.addonRepository});

  List<AddOns>? _addonList;

  List<AddOns>? get addonList => _addonList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<List<int?>> getAddonList() async {
    List<AddOns>? addonList = await addonRepository.getAddonList();
    List<int?> addonsIds = [];

    if (addonList != null) {
      _addonList = [];
      _addonList!.addAll(addonList);
      addonsIds.addAll(addonRepository.prepareAddonIds(addonList));
    }

    update();
    return addonsIds;
  }

  Future<void> addAddon(AddOns addonModel) async {
    _isLoading = true;
    update();
    bool isSuccess = await addonRepository.addAddon(addonModel);
    if (isSuccess) {
      Get.back();
      showCustomSnackBar('addon_added_successfully'.tr, isError: false);
      getAddonList();
    }
    _isLoading = false;
    update();
  }

  Future<void> updateAddon(AddOns addonModel) async {
    _isLoading = true;
    update();
    bool isSuccess = await addonRepository.updateAddon(addonModel.toJson());
    if (isSuccess) {
      Get.back();
      showCustomSnackBar('addon_updated_successfully'.tr, isError: false);
      getAddonList();
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteAddon(int id) async {
    _isLoading = true;
    update();
    bool isSuccess = await addonRepository.deleteAddon(id: id);
    if (isSuccess) {
      Get.back();
      showCustomSnackBar('addon_removed_successfully'.tr, isError: false);
      getAddonList();
    }
    _isLoading = false;
    update();
  }
}
