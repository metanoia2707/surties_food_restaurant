import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class ForgotPasswordRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  ForgotPasswordRepository(
      {required this.apiClient, required this.sharedPreferences});

  Future<ResponseModel> forgotPassword(String? email) async {
    ResponseModel responseModel;
    Response response = await apiClient
        .postData(AppConstants.forgetPasswordUri, {"email": email});
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  Future<ResponseModel> verifyToken(String? email, String token) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(
        AppConstants.verifyTokenUri, {"email": email, "reset_token": token});
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  Future<bool> changePassword(
      ProfileModel userInfoModel, String password) async {
    Response response =
        await apiClient.postData(AppConstants.updateProfileUri, {
      '_method': 'put',
      'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName,
      'phone': userInfoModel.phone,
      'password': password,
      'token': _getUserToken()
    });
    return (response.statusCode == 200);
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<ResponseModel> resetPassword(String? resetToken, String? email,
      String password, String confirmPassword) async {
    ResponseModel responseModel;
    Response response =
        await apiClient.postData(AppConstants.resetPasswordUri, {
      "_method": "put",
      "email": email,
      "reset_token": resetToken,
      "password": password,
      "confirm_password": confirmPassword
    });
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
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
