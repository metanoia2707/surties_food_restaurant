import 'package:surties_food_restaurant/features/order/domain/models/order_model.dart';

class RunningOrderModel {
  String status;
  List<OrderModel> orderList;

  RunningOrderModel({required this.status, required this.orderList});
}
