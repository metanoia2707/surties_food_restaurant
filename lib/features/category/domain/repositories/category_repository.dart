import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/category/domain/models/category_model.dart';
import 'package:surties_food_restaurant/util/app_constants.dart';

class CategoryRepository {
  final ApiClient apiClient;

  CategoryRepository({required this.apiClient});

  Future<List<CategoryModel>?> getList() async {
    List<CategoryModel>? categoryList;
    Response response = await apiClient.getData(AppConstants.categoryUri);
    if (response.statusCode == 200) {
      categoryList = [];
      response.body.forEach(
          (category) => categoryList!.add(CategoryModel.fromJson(category)));
    }
    return categoryList;
  }

  Future<List<CategoryModel>?> getSubCategoryList(int? parentID) async {
    List<CategoryModel>? subCategoryList;
    Response response =
        await apiClient.getData('${AppConstants.subCategoryUri}$parentID');
    if (response.statusCode == 200) {
      subCategoryList = [];
      response.body.forEach((subCategory) =>
          subCategoryList!.add(CategoryModel.fromJson(subCategory)));
    }
    return subCategoryList;
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
}
