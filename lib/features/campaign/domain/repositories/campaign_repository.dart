import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/campaign/domain/models/campaign_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class CampaignRepository {
  final ApiClient apiClient;
  CampaignRepository({required this.apiClient});

  Future<List<CampaignModel>?> getList() async {
    List<CampaignModel>? campaignList;
    Response response = await apiClient.getData(AppConstants.basicCampaignUri);
    if (response.statusCode == 200) {
      campaignList = [];
      response.body.forEach((campaign) {
        campaignList!.add(CampaignModel.fromJson(campaign));
      });
    }
    return campaignList;
  }

  Future<bool> joinCampaign(int? campaignID) async {
    Response response = await apiClient
        .putData(AppConstants.joinCampaignUri, {'campaign_id': campaignID});
    return (response.statusCode == 200);
  }

  Future<bool> leaveCampaign(int? campaignID) async {
    Response response = await apiClient
        .putData(AppConstants.leaveCampaignUri, {'campaign_id': campaignID});
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

  Future get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

  List<CampaignModel>? filterCampaign(
      String status, List<CampaignModel> allCampaignList) {
    List<CampaignModel>? campaignList = [];
    if (status == 'joined') {
      for (var campaign in allCampaignList) {
        if (campaign.isJoined!) {
          campaignList.add(campaign);
        }
      }
    } else {
      campaignList.addAll(allCampaignList);
    }
    return campaignList;
  }
}
