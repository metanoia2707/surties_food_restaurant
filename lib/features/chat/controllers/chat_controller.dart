import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surties_food_restaurant/api/api_client.dart';
import 'package:surties_food_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:surties_food_restaurant/features/chat/domain/models/message_model.dart';
import 'package:surties_food_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:surties_food_restaurant/features/chat/domain/repositories/chat_repository.dart';
import 'package:surties_food_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:surties_food_restaurant/helper/date_converter_helper.dart';
import 'package:surties_food_restaurant/helper/user_type.dart';

class ChatController extends GetxController implements GetxService {
  final ChatRepository chatRepository;

  ChatController({required this.chatRepository});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _tabLoading = false;

  bool get tabLoading => _tabLoading;

  List<bool>? _showDate;

  List<bool>? get showDate => _showDate;

  List<XFile>? _imageFiles;

  List<XFile>? get imageFiles => _imageFiles;

  bool _isSendButtonActive = false;

  bool get isSendButtonActive => _isSendButtonActive;

  final bool _isSeen = false;

  bool get isSeen => _isSeen;

  final bool _isSend = true;

  bool get isSend => _isSend;

  bool _isMe = false;

  bool get isMe => _isMe;

  List<XFile>? _chatImage = [];

  List<XFile>? get chatImage => _chatImage;

  int? _pageSize;

  int? get pageSize => _pageSize;

  int? _offset;

  int? get offset => _offset;

  String _type = 'customer';

  String get type => _type;

  bool _clickTab = false;

  bool get clickTab => _clickTab;

  ConversationsModel? _conversationModel;

  ConversationsModel? get conversationModel => _conversationModel;

  ConversationsModel? _searchConversationModel;

  ConversationsModel? get searchConversationModel => _searchConversationModel;

  MessageModel? _messageModel;

  MessageModel? get messageModel => _messageModel;

  int _onMessageTimeShowID = 0;

  int get onMessageTimeShowID => _onMessageTimeShowID;

  int _onImageOrFileTimeShowID = 0;

  int get onImageOrFileTimeShowID => _onImageOrFileTimeShowID;

  bool _isClickedOnMessage = false;

  bool get isClickedOnMessage => _isClickedOnMessage;

  bool _isClickedOnImageOrFile = false;

  bool get isClickedOnImageOrFile => _isClickedOnImageOrFile;

  Future<void> getConversationList(int offset,
      {String type = '', bool canUpdate = true, bool fromTab = true}) async {
    if (fromTab) {
      _tabLoading = true;
    }
    if (canUpdate) {
      update();
    }
    _searchConversationModel = null;
    ConversationsModel? conversationModel =
        await chatRepository.getConversationList(offset, type);
    if (conversationModel != null) {
      if (offset == 1) {
        _conversationModel = conversationModel;
      } else {
        _conversationModel!.totalSize = conversationModel.totalSize;
        _conversationModel!.offset = conversationModel.offset;
        _conversationModel!.conversations!
            .addAll(conversationModel.conversations!);
      }
    }
    _tabLoading = false;
    update();
  }

  Future<void> searchConversation(String name) async {
    _searchConversationModel = ConversationsModel();
    update();
    ConversationsModel? searchConversationModel =
        await chatRepository.searchConversationList(name);
    if (searchConversationModel != null) {
      _searchConversationModel = searchConversationModel;
    }
    update();
  }

  void removeSearchMode() {
    _searchConversationModel = null;
    update();
  }

  Future<void> getMessages(int offset, NotificationBodyModel notificationBody,
      User? user, int? conversationID,
      {bool firstLoad = false}) async {
    Response? response;
    if (firstLoad) {
      _messageModel = null;
    }

    if (notificationBody.customerId != null ||
        notificationBody.type == UserType.customer.name ||
        notificationBody.type == UserType.user.name) {
      response = await chatRepository.getMessages(
          offset, notificationBody.customerId, UserType.user, conversationID);
    } else if (notificationBody.deliveryManId != null ||
        notificationBody.type == UserType.delivery_man.name) {
      response = await chatRepository.getMessages(
          offset,
          notificationBody.deliveryManId,
          UserType.delivery_man,
          conversationID);
    }

    if (response != null &&
        response.body['messages'] != {} &&
        response.statusCode == 200) {
      if (offset == 1) {
        if (Get.find<ProfileController>().profileModel == null) {
          await Get.find<ProfileController>().getProfile();
        }
        _messageModel = MessageModel.fromJson(response.body);
        if (_messageModel!.conversation == null && user != null) {
          _messageModel!.conversation = Conversation(
              sender: User(
                id: Get.find<ProfileController>().profileModel!.id,
                imageFullUrl:
                    Get.find<ProfileController>().profileModel!.imageFullUrl,
                fName: Get.find<ProfileController>().profileModel!.fName,
                lName: Get.find<ProfileController>().profileModel!.lName,
              ),
              receiver: user);
        } else if (_messageModel!.conversation != null &&
            _messageModel!.conversation!.receiverType == 'vendor') {
          User? receiver = _messageModel!.conversation!.receiver;
          _messageModel!.conversation!.receiver =
              _messageModel!.conversation!.sender;
          _messageModel!.conversation!.sender = receiver;
        }
      } else {
        _messageModel!.totalSize =
            MessageModel.fromJson(response.body).totalSize;
        _messageModel!.offset = MessageModel.fromJson(response.body).offset;
        _messageModel!.messages!
            .addAll(MessageModel.fromJson(response.body).messages!);
      }
    }
    _isLoading = false;
    update();
  }

  void pickImage(bool isRemove) async {
    if (isRemove) {
      _imageFiles = [];
      _chatImage = [];
    } else {
      _imageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      if (_imageFiles != null) {
        _chatImage = imageFiles;
        _isSendButtonActive = true;
      }
    }
    update();
  }

  void removeImage(int index) {
    chatImage!.removeAt(index);
    update();
  }

  Future<Response?> sendMessage(
      {required String message,
      required NotificationBodyModel? notificationBody,
      required int? conversationId}) async {
    Response? response;
    _isLoading = true;
    update();

    List<MultipartBody> myImages = [];
    for (var image in _chatImage!) {
      myImages.add(MultipartBody('image[]', image));
    }

    if (notificationBody != null &&
        (notificationBody.customerId != null ||
            notificationBody.type == UserType.customer.name)) {
      response = await chatRepository.sendMessage(message, myImages,
          conversationId, notificationBody.customerId, UserType.customer);
    } else if (notificationBody != null &&
        (notificationBody.deliveryManId != null ||
            notificationBody.type == UserType.delivery_man.name)) {
      response = await chatRepository.sendMessage(
          message,
          myImages,
          conversationId,
          notificationBody.deliveryManId,
          UserType.delivery_man);
    }

    if (response!.statusCode == 200) {
      _imageFiles = [];
      _chatImage = [];
      _isSendButtonActive = false;
      _isLoading = false;
      _messageModel = MessageModel.fromJson(response.body);
      if (_messageModel!.conversation != null &&
          _messageModel!.conversation!.receiverType == 'vendor') {
        User? receiver = _messageModel!.conversation!.receiver;
        _messageModel!.conversation!.receiver =
            _messageModel!.conversation!.sender;
        _messageModel!.conversation!.sender = receiver;
      }
    }

    _imageFiles = [];
    _chatImage = [];
    update();
    return response;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    update();
  }

  void setImageList(List<XFile> images) {
    _imageFiles = [];
    _imageFiles = images;
    _isSendButtonActive = true;
    update();
  }

  void setIsMe(bool value) {
    _isMe = value;
  }

  void setType(String type) {
    _type = type;
    update();
  }

  void setTabSelect() {
    _clickTab = !_clickTab;
  }

  String getChatTime(String todayChatTimeInUtc, String? nextChatTimeInUtc) {
    String chatTime = '';
    DateTime todayConversationDateTime =
        DateConverter.isoUtcStringToLocalTimeOnly(todayChatTimeInUtc);
    try {
      todayConversationDateTime =
          DateConverter.isoUtcStringToLocalTimeOnly(todayChatTimeInUtc);
    } catch (e) {
      todayConversationDateTime =
          DateConverter.dateTimeStringToDate(todayChatTimeInUtc);
    }

    if (kDebugMode) {
      print("Current Message DataTime: $todayConversationDateTime");
    }

    DateTime nextConversationDateTime;
    DateTime currentDate = DateTime.now();

    if (nextChatTimeInUtc == null) {
      return chatTime =
          DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
    } else {
      nextConversationDateTime =
          DateConverter.isoUtcStringToLocalTimeOnly(nextChatTimeInUtc);
      if (kDebugMode) {
        print("Next Message DateTime: $nextConversationDateTime");
        print(
            "The Difference between this two : ${todayConversationDateTime.difference(nextConversationDateTime)}");
        print(
            "Today message Weekday: ${todayConversationDateTime.weekday}\n Next Message WeekDay: ${nextConversationDateTime.weekday}");
      }

      if (todayConversationDateTime.difference(nextConversationDateTime) <
              const Duration(minutes: 30) &&
          todayConversationDateTime.weekday ==
              nextConversationDateTime.weekday) {
        chatTime = '';
      } else if (currentDate.weekday != todayConversationDateTime.weekday &&
          DateConverter.countDays(todayConversationDateTime) < 6) {
        if ((currentDate.weekday - 1 == 0 ? 7 : currentDate.weekday - 1) ==
            todayConversationDateTime.weekday) {
          chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(
              todayConversationDateTime, false);
        } else {
          chatTime = DateConverter.convertStringTimeToDateTime(
              todayConversationDateTime);
        }
      } else if (currentDate.weekday == todayConversationDateTime.weekday &&
          DateConverter.countDays(todayConversationDateTime) < 6) {
        chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(
            todayConversationDateTime, true);
      } else {
        chatTime =
            DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
      }
    }
    return chatTime;
  }

  String getChatTimeWithPrevious(Message currentChat, Message? previousChat) {
    DateTime todayConversationDateTime =
        DateConverter.isoUtcStringToLocalTimeOnly(currentChat.createdAt ?? "");

    DateTime previousConversationDateTime;

    if (previousChat?.createdAt == null) {
      return 'Not-Same';
    } else {
      previousConversationDateTime =
          DateConverter.isoUtcStringToLocalTimeOnly(previousChat!.createdAt!);
      if (kDebugMode) {
        print(
            "The Difference is ${previousConversationDateTime.difference(todayConversationDateTime) < const Duration(minutes: 30)}");
      }
      if (previousConversationDateTime.difference(todayConversationDateTime) <
              const Duration(minutes: 30) &&
          todayConversationDateTime.weekday ==
              previousConversationDateTime.weekday &&
          _isSameUserWithPreviousMessage(currentChat, previousChat)) {
        return '';
      } else {
        return 'Not-Same';
      }
    }
  }

  bool _isSameUserWithPreviousMessage(
      Message? previousConversation, Message? currentConversation) {
    if (previousConversation?.senderId == currentConversation?.senderId &&
        previousConversation?.message != null &&
        currentConversation?.message != null) {
      return true;
    }
    return false;
  }

  void toggleOnClickMessage(int onMessageTimeShowID, {bool recall = true}) {
    _onImageOrFileTimeShowID = 0;
    _isClickedOnImageOrFile = false;
    if (_isClickedOnMessage && _onMessageTimeShowID != onMessageTimeShowID) {
      _onMessageTimeShowID = onMessageTimeShowID;
    } else if (_isClickedOnMessage &&
        _onMessageTimeShowID == onMessageTimeShowID) {
      _isClickedOnMessage = false;
      _onMessageTimeShowID = 0;
    } else {
      _isClickedOnMessage = true;
      _onMessageTimeShowID = onMessageTimeShowID;
    }
    update();
  }

  String? getOnPressChatTime(Message currentMessage) {
    if (currentMessage.id == _onMessageTimeShowID ||
        currentMessage.id == _onImageOrFileTimeShowID) {
      DateTime currentDate = DateTime.now();
      DateTime todayConversationDateTime =
          DateConverter.isoUtcStringToLocalTimeOnly(
              currentMessage.createdAt ?? "");

      if (currentDate.weekday != todayConversationDateTime.weekday &&
          DateConverter.countDays(todayConversationDateTime) <= 7) {
        return DateConverter.convertDateTimeToDate(todayConversationDateTime);
      } else if (currentDate.weekday == todayConversationDateTime.weekday &&
          DateConverter.countDays(todayConversationDateTime) <= 7) {
        return DateConverter.convertDateTimeToDate(todayConversationDateTime);
      } else {
        return DateConverter.isoStringToLocalDateAndTime(
            currentMessage.createdAt!);
      }
    } else {
      return null;
    }
  }

  void toggleOnClickImageAndFile(int onImageOrFileTimeShowID) {
    _onMessageTimeShowID = 0;
    _isClickedOnMessage = false;
    if (_isClickedOnImageOrFile &&
        _onImageOrFileTimeShowID != onImageOrFileTimeShowID) {
      _onImageOrFileTimeShowID = onImageOrFileTimeShowID;
    } else if (_isClickedOnImageOrFile &&
        _onImageOrFileTimeShowID == onImageOrFileTimeShowID) {
      _isClickedOnImageOrFile = false;
      _onImageOrFileTimeShowID = 0;
    } else {
      _isClickedOnImageOrFile = true;
      _onImageOrFileTimeShowID = onImageOrFileTimeShowID;
    }
    update();
  }
}
