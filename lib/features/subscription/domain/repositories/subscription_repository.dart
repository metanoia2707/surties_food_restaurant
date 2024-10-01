import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class SubscriptionRepository {
  final ApiClient apiClient;
  SubscriptionRepository({required this.apiClient});

  Future<Response> renewBusinessPlan(
      Map<String, String> body, Map<String, String>? headers) async {
    return await apiClient.postData(AppConstants.renewBusinessPlanUri, body,
        headers: headers);
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
