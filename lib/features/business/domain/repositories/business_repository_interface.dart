import 'package:get/get.dart';
import 'package:surties_food_restaurant/features/business/domain/models/business_plan_model.dart';
import 'package:surties_food_restaurant/interface/repository_interface.dart';

abstract class BusinessRepositoryInterface<T>
    implements RepositoryInterface<T> {
  Future<Response> setUpBusinessPlan(BusinessPlanModel businessPlanModel);
  Future<Response> subscriptionPayment(String id, String? paymentName);
}
