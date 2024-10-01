import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/reports/domain/models/report_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class ReportRepository {
  final ApiClient apiClient;
  ReportRepository({required this.apiClient});

  Future<TransactionReportModel?> getTransactionReportList(
      {required int offset, required String? from, required String? to}) async {
    TransactionReportModel? transactionReportModel;
    Response response = await apiClient.getData(
        '${AppConstants.transactionReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if (response.statusCode == 200) {
      transactionReportModel = TransactionReportModel.fromJson(response.body);
    }
    return transactionReportModel;
  }

  Future<OrderReportModel?> getOrderReportList(
      {required int offset, required String? from, required String? to}) async {
    OrderReportModel? orderReportModel;
    Response response = await apiClient.getData(
        '${AppConstants.orderReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if (response.statusCode == 200) {
      orderReportModel = OrderReportModel.fromJson(response.body);
    }
    return orderReportModel;
  }

  Future<OrderReportModel?> getCampaignReportList(
      {required int offset, required String? from, required String? to}) async {
    OrderReportModel? campaignReportModel;
    Response response = await apiClient.getData(
        '${AppConstants.campaignReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if (response.statusCode == 200) {
      campaignReportModel = OrderReportModel.fromJson(response.body);
    }
    return campaignReportModel;
  }

  Future<FoodReportModel?> getFoodReportList(
      {required int offset, required String? from, required String? to}) async {
    FoodReportModel? foodReportModel;
    Response response = await apiClient.getData(
        '${AppConstants.foodReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if (response.statusCode == 200) {
      foodReportModel = FoodReportModel.fromJson(response.body);
    }
    return foodReportModel;
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
