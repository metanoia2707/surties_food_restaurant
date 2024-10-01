import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:surties_food_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:surties_food_restaurant/features/profile/domain/repositories/profile_repository.dart';
import 'package:surties_food_restaurant/helper/route_helper.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileRepository profileRepository;

  ProfileController({required this.profileRepository}) {
    _notification = profileRepository.isNotificationActive();
  }

  ProfileModel? _profileModel;

  ProfileModel? get profileModel => _profileModel;

  bool _notification = true;

  bool get notification => _notification;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  XFile? _pickedFile;

  XFile? get pickedFile => _pickedFile;

  void setProfile(ProfileModel? proModel) {
    _profileModel = proModel;
  }

  Future<void> getProfile() async {
    ProfileModel? profileModel = await profileRepository.getProfileInfo();
    if (profileModel != null) {
      _profileModel = profileModel;
    }
    update();
  }

  Future<void> deleteVendor() async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileRepository.delete();
    _isLoading = false;
    if (responseModel.isSuccess) {
      showCustomSnackBar('your_account_remove_successfully'.tr, isError: false);
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    } else {
      Get.back();
      showCustomSnackBar(responseModel.message, isError: true);
    }
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    profileRepository.setNotificationActive(isActive);
    update();
    return _notification;
  }

  void initData() {
    _pickedFile = null;
  }

  String getUserToken() {
    return profileRepository.getUserToken();
  }

  Future<bool> updateUserInfo(
      ProfileModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    bool success = await profileRepository.updateProfile(
        updateUserModel, _pickedFile, token);
    _isLoading = false;
    bool isSuccess;
    if (success) {
      await getProfile();
      Get.back();
      showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      isSuccess = true;
    } else {
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  void pickImage() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }
}
