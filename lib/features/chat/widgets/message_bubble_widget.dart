/*
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/message_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/widgets/image_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/user_type.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Message message;
  final User? user;
  final User? sender;
  final UserType userType;
  const MessageBubbleWidget({super.key, required this.message, required this.user, required this.userType, required this.sender});

  @override
  Widget build(BuildContext context) {

    BaseUrls? baseUrl = Get.find<SplashController>().configModel!.baseUrls;
    bool isReply = message.senderId == user!.id;

    return (isReply) ? Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text('${user!.fName} ${user!.lName}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: CustomImageWidget(
              fit: BoxFit.cover, width: 40, height: 40,
              image: '${userType == UserType.customer ? baseUrl!.customerImageUrl : baseUrl!.deliveryManImageUrl}/${user!.image}',
            ),
          ),
          const SizedBox(width: 10),

          Flexible(
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

              if(message.message != null)  Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(Dimensions.radiusDefault),
                      topRight: Radius.circular(Dimensions.radiusDefault),
                      bottomLeft: Radius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                  padding: EdgeInsets.all(message.message != null ? Dimensions.paddingSizeDefault : 0),
                  child: Text(message.message ?? ''),
                ),
              ),
              const SizedBox(height: 8.0),

              message.files != null ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: message.files!.length,
                itemBuilder: (BuildContext context, index){
                  return  message.files!.isNotEmpty ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      onTap: () => showDialog(context: context, builder: (ctx) => ImageDialogWidget(imageUrl: '${baseUrl.chatImageUrl}/${message.files![index]}')),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        child: CustomImageWidget(
                          height: 100, width: 100, fit: BoxFit.cover,
                          image: '${baseUrl.chatImageUrl}/${message.files![index]}',
                        ),
                      ),
                    ),
                  ) : const SizedBox();
                }) : const SizedBox(),
            ]),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(
          DateConverter.localDateToIsoStringAMPM(DateTime.parse(message.createdAt!)),
          style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
        ),

      ]),

    ) : Container(
      padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault, vertical: Dimensions.fontSizeLarge),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

        Text(
          '${sender!.fName} ${sender!.lName}',
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [

          Flexible(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [

              (message.message != null && message.message!.isNotEmpty) ? Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusDefault),
                      bottomRight: Radius.circular(Dimensions.radiusDefault),
                      bottomLeft: Radius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(message.message != null ? Dimensions.paddingSizeDefault : 0),
                    child: Text(message.message??''),
                  ),
                ),
              ) : const SizedBox(),

              message.files != null ? Directionality(
                textDirection: TextDirection.rtl,
                child: GridView.builder(
                  reverse: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: message.files!.length,
                  itemBuilder: (BuildContext context, index){
                    return  message.files!.isNotEmpty ? InkWell(
                      onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialogWidget(imageUrl: '${baseUrl.chatImageUrl}/${message.files![index]}' )),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Dimensions.paddingSizeSmall , right:  0,
                          top: (message.message != null && message.message!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0,                                       ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: CustomImageWidget(
                            height: 100, width: 100, fit: BoxFit.cover,
                            image: '${baseUrl!.chatImageUrl}/${message.files![index]}',
                          ),
                        ),
                      ),
                    ) : const SizedBox();
                  }),
              ) : const SizedBox(),

            ]),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: CustomImageWidget(
              fit: BoxFit.cover, width: 40, height: 40,
              image: '${baseUrl!.vendorImageUrl}/${sender!.image}',
            ),
          ),

        ]),

        Icon(
          message.isSeen == 1 ? Icons.done_all : Icons.check,
          size: 12,
          color: message.isSeen == 1 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(
          DateConverter.localDateToIsoStringAMPM(DateTime.parse(message.createdAt!)),
          style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

      ]),
    );
  }
}*/

import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/controllers/chat_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/message_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/widgets/image_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/user_type.dart';
import 'package:stackfood_multivendor_restaurant/util/color_resources.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Message currentMessage;
  final Message? previousMessage;
  final Message? nextMessage;
  final User? user;
  final UserType userType;
  const MessageBubbleWidget({super.key, required this.currentMessage, required this.user, required this.userType, required this.previousMessage, required this.nextMessage});

  @override
  Widget build(BuildContext context) {

    bool isRightMessage = currentMessage.senderId == user!.id;
    bool isLTR = Get.find<LocalizationController>().isLtr;

    return GetBuilder<ChatController>(builder: (chatController) {

      String chatTime = chatController.getChatTime(currentMessage.createdAt!, nextMessage?. createdAt);
      String previousMessageHasChatTime = previousMessage != null ? chatController.getChatTime(previousMessage!.createdAt!, currentMessage.createdAt) : "";
      bool isSameUserWithPreviousMessage = _isSameUserWithPreviousMessage(previousMessage, currentMessage);
      bool isSameUserWithNextMessage = _isSameUserWithNextMessage(currentMessage, nextMessage);
      bool canShowSeenIcon = isRightMessage && currentMessage.isSeen == 0 && currentMessage.filesFullUrl == null;
      bool canShowImageSeenIcon = isRightMessage && currentMessage.isSeen == 0 && currentMessage.filesFullUrl != null && currentMessage.filesFullUrl!.isNotEmpty;

      return Column(crossAxisAlignment: isRightMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start , children: [

        if(chatTime != "")
          Align(alignment: Alignment.center,
            child: Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: 5),
              child: Text(
                chatController.getChatTime(currentMessage.createdAt!, nextMessage?.createdAt),
                style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
              ),
            ),
          ),

        Padding(
          padding: isRightMessage
              ? EdgeInsets.fromLTRB(20, (currentMessage.message != null && isSameUserWithNextMessage) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall,
              (isSameUserWithNextMessage || isSameUserWithPreviousMessage) && (currentMessage.message != null && previousMessageHasChatTime == "") ? 0 : Dimensions.paddingSizeSmall)

              : EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, isSameUserWithNextMessage? 5 : 10, 20, (isSameUserWithNextMessage || isSameUserWithPreviousMessage) && currentMessage.message != null ? 5 : 10),

          child: Column(
              crossAxisAlignment: isRightMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [

                Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, mainAxisAlignment: isRightMessage ? MainAxisAlignment.end : MainAxisAlignment.start, children: [

                  isRightMessage ? const SizedBox() :
                  (!isRightMessage && !isSameUserWithPreviousMessage) || ((!isRightMessage && isSameUserWithPreviousMessage) && chatController.getChatTimeWithPrevious(currentMessage, previousMessage).isNotEmpty)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge * 2),
                    child: CustomImageWidget(
                      fit: BoxFit.cover, width: 40, height: 40,
                      image: '${user!.imageFullUrl}',
                    ),
                  ) : !isRightMessage ? const SizedBox(width: Dimensions.paddingSizeExtraLarge + 15) : const SizedBox() ,
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Flexible(child: Column(crossAxisAlignment: isRightMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                    if(currentMessage.message != null) Flexible(child: Container(
                      decoration: BoxDecoration(
                        color: isRightMessage ? ColorResources.getRightBubbleColor() : ColorResources.getLeftBubbleColor(),

                        borderRadius: isRightMessage && (isSameUserWithNextMessage || isSameUserWithPreviousMessage) ? BorderRadius.only(
                          topRight: Radius.circular(isSameUserWithNextMessage && isLTR && chatTime =="" ? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                          bottomRight: Radius.circular(isSameUserWithPreviousMessage && isLTR && previousMessageHasChatTime =="" ? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                          topLeft: Radius.circular(isSameUserWithNextMessage && !isLTR && chatTime ==""? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                          bottomLeft: Radius.circular(isSameUserWithPreviousMessage && !isLTR && previousMessageHasChatTime ==""? Dimensions.radiusSmall :Dimensions.radiusExtraLarge + 5),

                        ) : !isRightMessage && (isSameUserWithNextMessage || isSameUserWithPreviousMessage) ? BorderRadius.only(
                          topLeft: Radius.circular(isSameUserWithNextMessage && isLTR && chatTime ==""? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                          bottomLeft: Radius.circular( isSameUserWithPreviousMessage && isLTR && previousMessageHasChatTime == "" ? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                          topRight: Radius.circular(isSameUserWithNextMessage && !isLTR && chatTime ==""? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                          bottomRight: Radius.circular(isSameUserWithPreviousMessage && !isLTR && previousMessageHasChatTime =="" ? Dimensions.radiusSmall :Dimensions.radiusExtraLarge + 5),

                        ) : BorderRadius.circular(Dimensions.radiusExtraLarge + 5),
                      ),

                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 10),
                      child: InkWell(
                        onTap: () {
                          chatController.toggleOnClickMessage(currentMessage.id!);
                        },
                        child: Text(
                          currentMessage.message??'',
                          style: robotoRegular.copyWith(
                            color: !Get.isDarkMode && !isRightMessage ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),

                    )),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 500),
                        height: chatController.onMessageTimeShowID == currentMessage.id ? 25.0 : 0.0,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: chatController.onMessageTimeShowID == currentMessage.id ? Dimensions.paddingSizeExtraSmall : 0.0,
                          ),
                          child: Text(
                            chatController.getOnPressChatTime(currentMessage) ?? "",
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      canShowSeenIcon ? Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          currentMessage.isSeen == 1 ? Icons.done_all : Icons.check,
                          size: 12,
                          color: currentMessage.isSeen == 1 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                        ),
                      ) : const SizedBox(),
                    ]),


                    currentMessage.filesFullUrl != null && currentMessage.filesFullUrl!.isNotEmpty ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

                    currentMessage.filesFullUrl != null && currentMessage.filesFullUrl!.isNotEmpty ? Column(
                        crossAxisAlignment: isRightMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [

                          currentMessage.filesFullUrl!.isNotEmpty ? Directionality(
                            textDirection: isRightMessage && isLTR ? TextDirection.rtl : !isLTR && !isRightMessage ? TextDirection.rtl : TextDirection.ltr,
                            child: SizedBox(width: 300,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: currentMessage.filesFullUrl!.length > 3 ? 4 : currentMessage.filesFullUrl!.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                                  crossAxisSpacing: Dimensions.paddingSizeSmall,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => showDialog(context: context, builder: (ctx) => ImageDialogWidget(imageUrl: currentMessage.filesFullUrl![index])),
                                    onLongPress: () => chatController.toggleOnClickImageAndFile(currentMessage.id!),
                                    child: Hero(
                                      tag: currentMessage.filesFullUrl![index],
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                                        child: CustomImageWidget(image: currentMessage.filesFullUrl![index], height: 80, width: 80, fit: BoxFit.cover,),
                                      ),
                                    ),
                                  );

                                },
                              ),
                            ),
                          ): const SizedBox(),

                          Row(mainAxisSize: MainAxisSize.min, children: [
                            AnimatedContainer(
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(milliseconds: 500),
                              height: chatController.onImageOrFileTimeShowID == currentMessage.id ? 25.0 : 0.0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: chatController.onMessageTimeShowID == currentMessage.id ? Dimensions.paddingSizeExtraSmall : 0.0,
                                ),
                                child: Text(
                                  chatController.getOnPressChatTime(currentMessage) ?? "",
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            canShowImageSeenIcon ? Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                currentMessage.isSeen == 1 ? Icons.done_all : Icons.check,
                                size: 12,
                                color: currentMessage.isSeen == 1 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                              ),
                            ) : const SizedBox(),
                          ]),


                        ]) :const SizedBox.shrink(),
                  ]),
                  )
                ]),

              ]),
        ),


      ]);
    });
  }

  bool _isSameUserWithPreviousMessage(Message? previousConversation, Message? currentConversation){
    if(previousConversation?.senderId == currentConversation?.senderId && previousConversation?.message != null && currentConversation?.message !=null){
      return true;
    }
    return false;
  }

  bool _isSameUserWithNextMessage(Message? currentConversation, Message? nextConversation){
    if(currentConversation?.senderId == nextConversation?.senderId && nextConversation?.message != null && currentConversation?.message !=null){
      return true;
    }
    return false;
  }

}
