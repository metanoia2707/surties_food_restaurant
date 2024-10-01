import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class PosRepository {
  final ApiClient apiClient;

  PosRepository({required this.apiClient});

  Future<List<Product>?> searchProductList(String searchText) async {
    List<Product>? searchProductList;
    Response response = await apiClient
        .postData(AppConstants.searchProductListUri, {'name': searchText});
    if (response.statusCode == 200) {
      searchProductList = [];
      response.body
          .forEach((food) => searchProductList!.add(Product.fromJson(food)));
    }
    return searchProductList;
  }

  Future<Response> searchCustomerList(String searchText) async {
    return await apiClient
        .getData('${AppConstants.searchCustomersUri}?search=$searchText');
  }

  Future<Response> placeOrder(String searchText) async {
    return await apiClient.postData(AppConstants.placeOrderUri, {});
  }

  Future<Response> getPosOrders() async {
    return await apiClient.getData(AppConstants.posOrdersUri);
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
