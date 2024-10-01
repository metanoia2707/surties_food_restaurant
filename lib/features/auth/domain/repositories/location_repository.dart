import 'dart:math';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/auth/domain/models/place_details_model.dart';
import 'package:surties_food_restaurant/features/auth/domain/models/prediction_model.dart';
import 'package:surties_food_restaurant/features/auth/domain/models/zone_model.dart';
import 'package:surties_food_restaurant/features/auth/domain/models/zone_response_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class LocationRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LocationRepository(
      {required this.apiClient, required this.sharedPreferences});

  Future<List<ZoneModel>?> getList() async {
    List<ZoneModel>? zoneList;
    Response response = await apiClient.getData(AppConstants.zoneListUri);
    if (response.statusCode == 200) {
      zoneList = [];
      response.body.forEach((zone) => zoneList!.add(ZoneModel.fromJson(zone)));
    }
    return zoneList;
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String address = 'Unknown Location Found';
    Response response = await apiClient.getData(
        '${AppConstants.geocodeUri}?lat=${latLng.latitude}&lng=${latLng.longitude}');
    if (response.statusCode == 200 && response.body['status'] == 'OK') {
      address = response.body['results'][0]['formatted_address'].toString();
    } else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return address;
  }

  Future<List<PredictionModel>> searchLocation(String text) async {
    List<PredictionModel> predictionList = [];
    Response response = await apiClient
        .getData('${AppConstants.searchLocationUri}?search_text=$text');
    if (response.statusCode == 200 && response.body['status'] == 'OK') {
      predictionList = [];
      response.body['predictions'].forEach((prediction) =>
          predictionList.add(PredictionModel.fromJson(prediction)));
    } else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return predictionList;
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.zoneUri}?lat=$lat&lng=$lng');
  }

  Future<PlaceDetailsModel?> getPlaceDetails(String? placeID) async {
    PlaceDetailsModel? placeDetails;
    Response response = await apiClient
        .getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
    if (response.statusCode == 200) {
      placeDetails = PlaceDetailsModel.fromJson(response.body);
    }
    return placeDetails;
  }

  Future<bool> saveUserAddress(String address) async {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      sharedPreferences.getString(AppConstants.languageCode),
    );
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }

  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
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

  LatLng? setRestaurantLocation(ZoneResponseModel response, LatLng location) {
    LatLng? restaurantLocation;
    if (response.isSuccess && response.zoneIds.isNotEmpty) {
      restaurantLocation = location;
    } else {
      restaurantLocation = null;
    }
    return restaurantLocation;
  }

  List<int>? setZoneIds(ZoneResponseModel response) {
    List<int>? zoneIds;
    if (response.isSuccess && response.zoneIds.isNotEmpty) {
      zoneIds = response.zoneIds;
    } else {
      zoneIds = null;
    }
    return zoneIds;
  }

  int? setSelectedZoneIndex(ZoneResponseModel response, List<int>? zoneIds,
      int? selectedZoneIndex, List<ZoneModel>? zoneList) {
    int? zoneIndex = selectedZoneIndex;
    if (response.isSuccess && response.zoneIds.isNotEmpty) {
      for (int index = 0; index < zoneList!.length; index++) {
        if (zoneIds!.contains(zoneList[index].id)) {
          zoneIndex = index;
          break;
        }
      }
    }
    return zoneIndex;
  }

  Future<void> prepareZoomToFit(GoogleMapController googleMapController,
      LatLngBounds bounds, LatLng centerBounds, double padding) async {
    bool keepZoomingOut = true;
    int count = 0;

    while (keepZoomingOut) {
      count++;
      final LatLngBounds screenBounds =
          await googleMapController.getVisibleRegion();
      if (_fits(bounds, screenBounds) || count == 200) {
        keepZoomingOut = false;
        final double zoomLevel =
            await googleMapController.getZoomLevel() - padding;
        googleMapController
            .moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        final double zoomLevel = await googleMapController.getZoomLevel() - 0.1;
        googleMapController
            .moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool _fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck =
        screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck =
        screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck =
        screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck =
        screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck &&
        northEastLongitudeCheck &&
        southWestLatitudeCheck &&
        southWestLongitudeCheck;
  }

  LatLngBounds computeBounds(List<LatLng> list) {
    assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var south = firstLatLng.latitude,
        north = firstLatLng.latitude,
        west = firstLatLng.longitude,
        east = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latLng = list[i];
      south = min(south, latLng.latitude);
      north = max(north, latLng.latitude);
      west = min(west, latLng.longitude);
      east = max(east, latLng.longitude);
    }
    return LatLngBounds(
        southwest: LatLng(south, west), northeast: LatLng(north, east));
  }
}
