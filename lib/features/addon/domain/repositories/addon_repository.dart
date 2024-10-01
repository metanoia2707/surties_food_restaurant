import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class AddonRepository {
  final ApiClient apiClient;

  AddonRepository({required this.apiClient});

  Future<bool> addAddon(AddOns addonModel) async {
    Response response =
        await apiClient.postData(AppConstants.addAddonUri, addonModel.toJson());
    return (response.statusCode == 200);
  }

  Future updateAddon(Map<String, dynamic> body) async {
    Response response =
        await apiClient.putData(AppConstants.updateAddonUri, body);
    return (response.statusCode == 200);
  }

  Future<bool> deleteAddon({int? id}) async {
    Response response = await apiClient.postData(
        '${AppConstants.deleteAddonUri}?id=$id', {"_method": "delete"});
    return (response.statusCode == 200);
  }

  Future<List<AddOns>?> getAddonList() async {
    List<AddOns>? addonList;

    Response response = await apiClient.getData(AppConstants.addonListUri);
    if (response.statusCode == 200) {
      addonList = [];

      response.body.forEach((addon) {
        addonList!.add(AddOns.fromJson(addon));
      });
    }

    return addonList;
  }

  Future get(int id) {
    throw UnimplementedError();
  }

  List<int?> prepareAddonIds(List<AddOns> addonList) {
    List<int?> addonsIds = [];
    for (var addon in addonList) {
      addonsIds.add(addon.id);
    }
    return addonsIds;
  }
}
