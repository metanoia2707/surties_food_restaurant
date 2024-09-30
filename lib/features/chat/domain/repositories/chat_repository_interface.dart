import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/helper/user_type.dart';
import 'package:surties_food_restaurant/interface/repository_interface.dart';

abstract class ChatRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getConversationList(int offset, String type);
  Future<dynamic> searchConversationList(String name);
  Future<dynamic> getMessages(
      int offset, int? userId, UserType userType, int? conversationID);
  Future<dynamic> sendMessage(String message, List<MultipartBody> images,
      int? conversationId, int? userId, UserType userType);
}
