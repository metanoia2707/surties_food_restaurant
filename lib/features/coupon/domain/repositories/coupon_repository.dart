import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/coupon/domain/models/coupon_body_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class CouponRepository {
  final ApiClient apiClient;
  CouponRepository({required this.apiClient});

  Future<List<CouponBodyModel>?> getCouponList(int offset) async {
    List<CouponBodyModel>? couponList;
    Response response = await apiClient
        .getData('${AppConstants.couponListUri}?limit=50&offset=$offset');
    if (response.statusCode == 200) {
      couponList = [];
      response.body.forEach((coupon) {
        couponList!.add(CouponBodyModel.fromJson(coupon));
      });
    }
    return couponList;
  }

  Future<CouponBodyModel?> get(int id) async {
    CouponBodyModel? couponDetails;
    Response response = await apiClient
        .getData('${AppConstants.couponDetailsUri}?coupon_id=$id');
    if (response.statusCode == 200) {
      couponDetails = CouponBodyModel.fromJson(response.body[0]);
    }
    return couponDetails;
  }

  Future<bool> changeStatus(int? couponId, int status) async {
    bool success = false;
    Response response = await apiClient.postData(
        AppConstants.couponChangeStatusUri,
        {"coupon_id": couponId, "status": status});
    if (response.statusCode == 200) {
      success = true;
      showCustomSnackBar(response.body['message'], isError: false);
    }
    return success;
  }

  Future<ResponseModel?> addCoupon(Map<String, String?> data) async {
    ResponseModel? responseModel;
    Response response =
        await apiClient.postData(AppConstants.addCouponUri, data);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel?> update(Map<String, dynamic> body) async {
    ResponseModel? responseModel;
    Response response =
        await apiClient.postData(AppConstants.couponUpdateUri, body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel?> delete({int? id}) async {
    ResponseModel? responseModel;
    Response response = await apiClient
        .postData(AppConstants.couponDeleteUri, {"coupon_id": id});
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }
    return responseModel;
  }

  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  Future getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }
}
