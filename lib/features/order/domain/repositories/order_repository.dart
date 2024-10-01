import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/features/order/domain/models/order_cancellation_body_model.dart';
import 'package:surties_food_restaurant/features/order/domain/models/order_model.dart';
import 'package:surties_food_restaurant/features/order/domain/models/update_status_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class OrderRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  OrderRepository({required this.apiClient, required this.sharedPreferences});

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<Response> get(int id) {
    return apiClient.getData('${AppConstants.orderDetailsUri}$id');
  }

  Future<List<OrderModel>?> getCurrentOrders() async {
    List<OrderModel>? runningOrderList = [];
    Response response = await apiClient.getData(AppConstants.currentOrdersUri);
    if (response.statusCode == 200) {
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        runningOrderList.add(orderModel);
      });
    }
    return runningOrderList;
  }

  Future<PaginatedOrderModel?> getPaginatedOrderList(
      int offset, String status) async {
    PaginatedOrderModel? historyOrderModel;
    Response response = await apiClient.getData(
        '${AppConstants.completedOrdersUri}?status=$status&offset=$offset&limit=10');
    if (response.statusCode == 200) {
      historyOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return historyOrderModel;
  }

  Future<ResponseModel> updateOrderStatus(UpdateStatusModel updateStatusBody,
      List<MultipartBody> proofAttachment) async {
    ResponseModel responseModel;
    Response response = await apiClient.postMultipartData(
        AppConstants.updateOrderStatusUri,
        updateStatusBody.toJson(),
        proofAttachment,
        [],
        handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  Future<OrderModel?> getOrderWithId(int? orderId) async {
    OrderModel? orderModel;
    Response response = await apiClient
        .getData('${AppConstants.currentOrderDetailsUri}$orderId');
    if (response.statusCode == 200) {
      orderModel = OrderModel.fromJson(response.body);
    }
    return orderModel;
  }

  Future<List<CancellationData>?> getCancelReasons() async {
    List<CancellationData>? orderCancelReasons;
    Response response = await apiClient.getData(
        '${AppConstants.orderCancellationUri}?offset=1&limit=30&type=restaurant');
    if (response.statusCode == 200) {
      OrderCancellationBodyModel orderCancellationBody =
          OrderCancellationBodyModel.fromJson(response.body);
      orderCancelReasons = [];
      for (var element in orderCancellationBody.reasons!) {
        orderCancelReasons.add(element);
      }
    }
    return orderCancelReasons;
  }

  Future<bool> sendDeliveredNotification(int? orderID) async {
    Response response = await apiClient.postData(
        AppConstants.deliveredOrderNotificationUri,
        {"_method": "put", 'token': _getUserToken(), 'order_id': orderID});
    return (response.statusCode == 200);
  }

  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  Future delete({int? id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  Future<void> setBluetoothAddress(String? address) async {
    await sharedPreferences.setString(
        AppConstants.bluetoothMacAddress, address ?? '');
  }

  String? getBluetoothAddress() =>
      sharedPreferences.getString(AppConstants.bluetoothMacAddress);
}
