import 'package:get/get.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:surties_food_restaurant/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:surties_food_restaurant/features/chat/domain/services/chat_service_interface.dart';
import 'package:surties_food_restaurant/helper/user_type.dart';

class ChatService implements ChatServiceInterface {
  final ChatRepositoryInterface chatRepositoryInterface;
  ChatService({required this.chatRepositoryInterface});

  @override
  Future<ConversationsModel?> getConversationList(
      int offset, String type) async {
    return await chatRepositoryInterface.getConversationList(offset, type);
  }

  @override
  Future<ConversationsModel?> searchConversationList(String name) async {
    return await chatRepositoryInterface.searchConversationList(name);
  }

  @override
  Future<Response> getMessages(
      int offset, int? userId, UserType userType, int? conversationID) async {
    return await chatRepositoryInterface.getMessages(
        offset, userId, userType, conversationID);
  }

  @override
  Future<Response> sendMessage(String message, List<MultipartBody> images,
      int? conversationId, int? userId, UserType userType) async {
    return await chatRepositoryInterface.sendMessage(
        message, images, conversationId, userId, userType);
  }
}
