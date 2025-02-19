import 'package:surties_food_restaurant/features/auth/domain/models/auth_response_model.dart';

class ResponseModel {
  final bool _isSuccess;
  final String? _message;
  AuthResponseModel? authResponseModel;
  ResponseModel(this._isSuccess, this._message, {this.authResponseModel});

  String? get message => _message;
  bool get isSuccess => _isSuccess;
}