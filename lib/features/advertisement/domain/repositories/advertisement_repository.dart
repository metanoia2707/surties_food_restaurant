import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/advertisement/models/ads_details_model.dart';
import 'package:surties_food_restaurant/features/advertisement/models/advertisement_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class AdvertisementRepository {
  final ApiClient apiClient;
  AdvertisementRepository({required this.apiClient});

  Future add(value) {
    throw UnimplementedError();
  }

  Future<Response> submitNewAdvertisement(
      Map<String, String> body, List<MultipartBody> selectedFile) async {
    return await apiClient.postMultipartData(
      AppConstants.addAdvertisementUri,
      body,
      selectedFile,
      [],
    );
  }

  Future<Response> copyAddAdvertisement(
      Map<String, String> body, List<MultipartBody> selectedFile) async {
    return await apiClient.postMultipartData(
      AppConstants.copyAddAdvertisementUri,
      body,
      selectedFile,
      [],
    );
  }

  Future delete({int? id}) async {
    return await _deleteAdvertisement(id: id!);
  }

  Future<bool> _deleteAdvertisement({required int id}) async {
    Response response =
        await apiClient.deleteData("${AppConstants.deleteAdvertisementUri}$id");
    return response.statusCode == 200;
  }

  Future<AdsDetailsModel?> get(int id) async {
    return await _getAdvertisementDetails(id: id);
  }

  Future<AdsDetailsModel?> _getAdvertisementDetails({required int id}) async {
    AdsDetailsModel? adsDetailsModel;
    Response response =
        await apiClient.getData("${AppConstants.advertisementDetailsUri}/$id");
    if (response.statusCode == 200) {
      adsDetailsModel = AdsDetailsModel.fromJson(response.body);
    }
    return adsDetailsModel;
  }

  Future getList() {
    throw UnimplementedError();
  }

  Future<AdvertisementModel?> getAdvertisementList(
      String offset, String type) async {
    AdvertisementModel? advertisementModel;
    Response response = await apiClient.getData(
        '${AppConstants.getAdvertisementListUri}?offset=$offset&limit=10&ads_type=$type');
    if (response.statusCode == 200) {
      advertisementModel = AdvertisementModel.fromJson(response.body);
    }
    return advertisementModel;
  }

  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  Future<Response> editAdvertisement(
      {required String id,
      required Map<String, String> body,
      List<MultipartBody>? selectedFile}) async {
    return await apiClient.postMultipartData(
      "${AppConstants.updateAdvertisementUri}/$id",
      body,
      selectedFile!,
      [],
    );
  }

  Future<bool> changeAdvertisementStatus(
      {required String note, required String status, required int id}) async {
    Response response =
        await apiClient.postData(AppConstants.changeAdvertisementStatusUri, {
      '_method': 'PUT',
      'id': '$id',
      'status': status,
      'pause_note': note,
    });
    if (response.statusCode == 200) {
      showCustomSnackBar(response.body['message'], isError: false);
    }
    return response.statusCode == 200;
  }
}
