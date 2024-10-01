import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/business/domain/models/business_plan_model.dart';
import 'package:surties_food_restaurant/features/business/domain/models/package_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class BusinessRepository {
  final ApiClient apiClient;
  BusinessRepository({required this.apiClient});

  Future<PackageModel?> getList() async {
    PackageModel? packageModel;
    Response response =
        await apiClient.getData(AppConstants.restaurantPackagesUri);
    if (response.statusCode == 200) {
      packageModel = PackageModel.fromJson(response.body);
    }
    return packageModel;
  }

  Future<Response> setUpBusinessPlan(
      BusinessPlanModel businessPlanModel) async {
    return await apiClient.postData(
        AppConstants.businessPlanUri, businessPlanModel.toJson());
  }

  Future<Response> subscriptionPayment(String id, String? paymentName) async {
    return await apiClient.postData(AppConstants.businessPlanPaymentUri,
        {'id': id, 'payment_gateway': paymentName});
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

  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
