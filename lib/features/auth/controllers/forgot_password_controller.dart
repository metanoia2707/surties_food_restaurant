import 'package:get/get.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/auth/domain/repositories/forgot_password_repository.dart';
import 'package:surties_food_restaurant/features/profile/domain/models/profile_model.dart';

class ForgotPasswordController extends GetxController implements GetxService {
  final ForgotPasswordRepository forgotPasswordRepository;
  ForgotPasswordController({required this.forgotPasswordRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isForgotLoading = false;
  bool get isForgotLoading => _isForgotLoading;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  Future<ResponseModel> forgotPassword(String? email) async {
    _isForgotLoading = true;
    update();
    ResponseModel responseModel =
        await forgotPasswordRepository.forgotPassword(email);
    _isForgotLoading = false;
    update();
    return responseModel;
  }

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  Future<ResponseModel> verifyToken(String? email) async {
    _isLoading = true;
    update();
    ResponseModel responseModel =
        await forgotPasswordRepository.verifyToken(email, _verificationCode);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<bool> changePassword(
      ProfileModel updatedUserModel, String password) async {
    _isLoading = true;
    update();
    bool isSuccess;
    bool success = await forgotPasswordRepository.changePassword(
        updatedUserModel, password);
    _isLoading = false;
    if (success) {
      Get.back();
      showCustomSnackBar('password_updated_successfully'.tr, isError: false);
      isSuccess = true;
    } else {
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  Future<ResponseModel> resetPassword(String? resetToken, String? email,
      String password, String confirmPassword) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await forgotPasswordRepository.resetPassword(
        resetToken, email, password, confirmPassword);
    _isLoading = false;
    update();
    return responseModel;
  }
}
