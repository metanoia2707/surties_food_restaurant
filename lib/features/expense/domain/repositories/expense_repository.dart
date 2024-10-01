import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/expense/domain/models/expense_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class ExpenseRepository {
  final ApiClient apiClient;

  ExpenseRepository({required this.apiClient});

  Future<ExpenseBodyModel?> getExpenseList(
      {required int offset,
      required int? restaurantId,
      required String? from,
      required String? to,
      required String? searchText}) async {
    ExpenseBodyModel? expenseModel;
    Response response = await apiClient.getData(
        '${AppConstants.expanseListUri}?limit=10&offset=$offset&restaurant_id=$restaurantId&from=$from&to=$to&search=${searchText ?? ''}');
    if (response.statusCode == 200) {
      expenseModel = ExpenseBodyModel.fromJson(response.body);
    }
    return expenseModel;
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
