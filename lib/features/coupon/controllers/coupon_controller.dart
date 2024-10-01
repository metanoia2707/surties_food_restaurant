import 'package:get/get.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/coupon/domain/models/coupon_body_model.dart';
import 'package:surties_food_restaurant/features/coupon/domain/repositories/coupon_repository.dart';

class CouponController extends GetxController implements GetxService {
  final CouponRepository couponRepository;

  CouponController({required this.couponRepository});

  int _couponTypeIndex = -1;

  int get couponTypeIndex => _couponTypeIndex;

  int _discountTypeIndex = -1;

  int get discountTypeIndex => _discountTypeIndex;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<CouponBodyModel>? _couponList;

  List<CouponBodyModel>? get couponList => _couponList;

  CouponBodyModel? _couponDetails;

  CouponBodyModel? get couponDetails => _couponDetails;

  Future<void> getCouponList() async {
    List<CouponBodyModel>? couponList = await couponRepository.getCouponList(1);
    if (couponList != null) {
      _couponList = [];
      _couponList!.addAll(couponList);
    }
    update();
  }

  Future<CouponBodyModel?> getCouponDetails(int id) async {
    _couponDetails = null;
    CouponBodyModel? couponDetails = await couponRepository.get(id);
    if (couponDetails != null) {
      _couponDetails = couponDetails;
    }
    update();
    return _couponDetails;
  }

  Future<bool> changeStatus(int? couponId, bool status) async {
    bool isSuccess =
        await couponRepository.changeStatus(couponId, status ? 1 : 0);
    return isSuccess;
  }

  Future<bool> deleteCoupon(int couponId) async {
    _isLoading = true;
    update();
    bool success = false;
    ResponseModel? responseModel = await couponRepository.delete(id: couponId);
    if (responseModel!.isSuccess) {
      success = true;
      await getCouponList();
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
    }
    _isLoading = false;
    update();
    return success;
  }

  Future<void> addCoupon(
      {String? code,
      String? title,
      String? startDate,
      String? expireDate,
      required String discount,
      String? couponType,
      String? discountType,
      String? limit,
      String? maxDiscount,
      String? minPurchase}) async {
    _isLoading = true;
    update();

    Map<String, String?> data = {
      "code": code,
      "translations": title,
      "start_date": startDate,
      "expire_date": expireDate,
      "discount": discount.isNotEmpty ? discount : '0',
      "coupon_type": couponType,
      "discount_type": discountType,
      "limit": limit,
      "max_discount": maxDiscount,
      "min_purchase": minPurchase,
    };

    ResponseModel responseModel = await couponRepository.add(data);
    if (responseModel.isSuccess) {
      getCouponList();
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> updateCoupon(
      {String? couponId,
      String? code,
      String? title,
      String? startDate,
      String? expireDate,
      required String discount,
      String? couponType,
      String? discountType,
      String? limit,
      String? maxDiscount,
      String? minPurchase}) async {
    _isLoading = true;
    update();

    Map<String, String?> data = {
      "coupon_id": couponId,
      "code": code,
      "translations": title,
      "start_date": startDate,
      "expire_date": expireDate,
      "discount": discount.isNotEmpty ? discount : '0',
      "coupon_type": couponType,
      "discount_type": discountType,
      "limit": limit,
      "max_discount": maxDiscount,
      "min_purchase": minPurchase,
    };

    ResponseModel? responseModel = await couponRepository.update(data);
    if (responseModel!.isSuccess) {
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
      getCouponList();
    }
    _isLoading = false;
    update();
  }

  void setCouponTypeIndex(int index, bool notify) {
    _couponTypeIndex = index;
    if (notify) {
      update();
    }
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if (notify) {
      update();
    }
  }
}
