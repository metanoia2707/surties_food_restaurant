import 'dart:io';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/controllers/chat_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/widgets/conversation_details_shimmer_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/widgets/message_bubble_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/user_type.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final NotificationBodyModel? notificationBody;
  final User? user;
  final int? conversationId;
  const ChatScreen({super.key, required this.notificationBody, required this.user, this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputMessageController = TextEditingController();
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    Get.find<ChatController>().getMessages(1, widget.notificationBody!, widget.user, widget.conversationId, firstLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {

      // String? baseUrl = '';
      // if(widget.notificationBody!.customerId != null) {
      //   baseUrl = Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl;
      // }else {
      //   baseUrl = Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl;
      // }

      return Scaffold(

        appBar: AppBar(
          /*title: Text(
            chatController.messageModel != null ? '${chatController.messageModel!.conversation!.receiver!.fName}'
            ' ${chatController.messageModel!.conversation!.receiver!.lName}' : 'receiver_name'.tr,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40, height: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 2,color: Theme.of(context).cardColor),
                  color: Theme.of(context).cardColor,
                ),
                child: ClipOval(child: Image.network(
                  '$baseUrl/${chatController.messageModel != null ? chatController.messageModel!.conversation!.receiver!.image : ''}',
                  errorBuilder: (context, error, stackTrace) => Image.asset(Images.placeholder, fit: BoxFit.cover, height: 40, width: 40,),
                  fit: BoxFit.cover, height: 40, width: 40),
                ),
              ),
            ),
          ],*/

          titleSpacing: 0,
          elevation: 2,
          backgroundColor: Theme.of(context).cardColor,
          surfaceTintColor: Theme.of(context).cardColor,
          shadowColor: Theme.of(context).disabledColor.withOpacity(0.3),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Row(children: [

            ClipOval(
              child: Image.network(
                '${chatController.messageModel != null ? chatController.messageModel!.conversation!.receiver!.imageFullUrl : ''}',
                errorBuilder: (context, error, stackTrace) => Image.asset(Images.placeholder, fit: BoxFit.cover, height: 40, width: 40,),
                fit: BoxFit.cover, height: 40, width: 40,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              chatController.messageModel != null ? Text(
                '${chatController.messageModel!.conversation!.receiver!.fName}'' ${chatController.messageModel!.conversation!.receiver!.lName}',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              ) : Container(
                height: 15, width: 100, color: Theme.of(context).disabledColor.withOpacity(0.2),
              ),

              (chatController.messageModel != null && chatController.messageModel!.conversation!.receiver!.phone != null) ? Text(
                '${chatController.messageModel!.conversation!.receiver!.phone}',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),

            ]),

          ]),

        ),

        body: _isLoggedIn ? SafeArea(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(children: [

                /*GetBuilder<ChatController>(builder: (chatController) {
                  return Expanded(child: chatController.messageModel != null ? chatController.messageModel!.messages!.isNotEmpty ? SingleChildScrollView(
                    controller: _scrollController,
                    reverse: true,
                    child: PaginatedListViewWidget(
                      scrollController: _scrollController,
                      totalSize: chatController.messageModel?.totalSize,
                      offset: chatController.messageModel?.offset,
                      onPaginate: (int? offset) async => await chatController.getMessages(
                        offset!, widget.notificationBody!, widget.user, widget.conversationId,
                      ),
                      productView: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: chatController.messageModel!.messages!.length,
                        itemBuilder: (context, index) {
                          return MessageBubbleWidget(
                            message: chatController.messageModel!.messages![index],
                            user: chatController.messageModel!.conversation!.receiver,
                            sender: chatController.messageModel!.conversation!.sender,
                            userType: widget.notificationBody!.customerId != null ? UserType.customer : UserType.delivery_man,
                          );
                        },
                      ),
                    )) : const SizedBox() : const Center(child: CircularProgressIndicator()));
                  }
                ),*/

                GetBuilder<ChatController>(builder: (chatController) {
                  return Expanded(child: chatController.messageModel != null ? chatController.messageModel!.messages!.isNotEmpty ? SingleChildScrollView(
                    controller: _scrollController,
                    reverse: true,
                    child: PaginatedListViewWidget(
                      scrollController: _scrollController,
                      reverse: true,
                      totalSize: chatController.messageModel?.totalSize,
                      offset: chatController.messageModel?.offset,
                      onPaginate: (int? offset) async => await chatController.getMessages(
                        offset!, widget.notificationBody!, widget.user, widget.conversationId,
                      ),
                      productView: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: chatController.messageModel!.messages!.length,
                        itemBuilder: (context, index) {
                          return MessageBubbleWidget(
                            previousMessage: index == 0 ? null : chatController.messageModel?.messages?.elementAt(index-1),
                            currentMessage: chatController.messageModel!.messages![index],
                            nextMessage: index == (chatController.messageModel!.messages!.length - 1) ? null : chatController.messageModel?.messages?.elementAt(index+1),
                            user: chatController.messageModel!.conversation!.sender,
                            userType: widget.notificationBody!.deliveryManId != null ? UserType.delivery_man : UserType.customer,
                          );
                        },
                      ),
                    ),
                  ) : Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const CustomAssetImageWidget(
                      image: Images.messageEmpty,
                      height: 70, width: 70,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      'no_message_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ],
                  )) : const ConversationDetailsShimmer());
                }),

                (chatController.messageModel != null && (chatController.messageModel!.status! || chatController.messageModel!.messages!.isEmpty)) ?  Container(
                  color: Theme.of(context).cardColor,
                  child: Column(children: [

                    /*GetBuilder<ChatController>(builder: (chatController) {
                      return chatController.chatImage!.isNotEmpty ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: chatController.chatImage!.length,
                          itemBuilder: (BuildContext context, index) {
                            return chatController.chatImage!.isNotEmpty ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(children: [

                                Container(width: 100, height: 100,
                                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                    child: ResponsiveHelper.isWeb() ? Image.network(
                                      chatController.chatImage![index].path, width: 100, height: 100, fit: BoxFit.cover,
                                    ) : Image.file(
                                      File(chatController.chatImage![index].path), width: 100, height: 100, fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                Positioned(top:0, right:0,
                                  child: InkWell(
                                    onTap : () => chatController.removeImage(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(Icons.clear, color: Theme.of(context).colorScheme.error, size: 15),
                                      ),
                                    ),
                                  ),
                                )],
                              ),
                            ) : const SizedBox();
                          },
                        ),
                      ) : const SizedBox();
                    }),*/
                    GetBuilder<ChatController>(builder: (chatController) {

                      return chatController.chatImage!.isNotEmpty ? SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: chatController.chatImage!.length,
                          itemBuilder: (BuildContext context, index){
                            return  chatController.chatImage!.isNotEmpty ? Padding(
                              padding: const EdgeInsets.only(
                                left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeSmall,
                                top: Dimensions.paddingSizeDefault,
                              ),
                              child: Stack(clipBehavior: Clip.none, children: [

                                Container(width: 50, height: 60,
                                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                                    child: Image.file(
                                      File(chatController.chatImage![index].path), width: 50, height: 60, fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: -5, right: -10,
                                  child: InkWell(
                                    onTap : () => chatController.removeImage(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Icon(Icons.clear, color: Theme.of(context).cardColor, size: 15),
                                      ),
                                    ),
                                  ),
                                )],
                              ),
                            ) : const SizedBox();
                          },
                        ),
                      ) : const SizedBox();
                    }),


                   /* Row(children: [

                      InkWell(
                        onTap: () async {
                          Get.find<ChatController>().pickImage(false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Image.asset(Images.image, width: 25, height: 25, color: Theme.of(context).hintColor),
                        ),
                      ),

                      SizedBox(
                        height: 25,
                        child: VerticalDivider(width: 0, thickness: 1, color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Expanded(
                        child: TextField(
                          inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.messageInputLength)],
                          controller: _inputMessageController,
                          textCapitalization: TextCapitalization.sentences,
                          style: robotoRegular,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'type_here'.tr,
                            hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),
                          ),
                          onSubmitted: (String newText) {
                            if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }
                          },
                          onChanged: (String newText) {
                            if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }
                          },
                        ),
                      ),

                      GetBuilder<ChatController>(builder: (chatController) {
                        return InkWell(
                          onTap: () async {
                            if(chatController.isSendButtonActive) {
                              await chatController.sendMessage(
                                message: _inputMessageController.text, notificationBody: widget.notificationBody, conversationId: widget.conversationId,
                              ).then((value) {
                                if(value!.statusCode == 200){
                                  Future.delayed(const Duration(seconds: 2),() {
                                    chatController.getMessages(1, widget.notificationBody!, widget.user, widget.conversationId);
                                  });
                                }
                              });
                              _inputMessageController.clear();
                            }else{
                              showCustomSnackBar('write_somethings'.tr);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: chatController.isLoading ? const SizedBox(
                              width: 25, height: 25,
                              child: CircularProgressIndicator(),
                            ) : Image.asset(
                              Images.send, width: 25, height: 25,
                              color: chatController.isSendButtonActive ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                            ),
                          ),
                        );
                      }),

                    ]),*/

                    // (chatController.isLoading && chatController.chatImage!.isNotEmpty) ? Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Padding(
                    //   padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeExtraSmall),
                    //   child: Text(
                    //     '${'uploading'.tr} ${chatController.chatImage?.length} ${'images'.tr}',
                    //     style: robotoMedium.copyWith(color: Theme.of(context).hintColor),
                    //     ),
                    //   ),
                    // ) : const SizedBox(),

                    Container(
                      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5), width: 1),
                            ),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Expanded(
                                child: TextField(
                                  inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.messageInputLength)],
                                  controller: _inputMessageController,
                                  textCapitalization: TextCapitalization.sentences,
                                  style: robotoRegular,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type_a_massage'.tr,
                                    hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),
                                  ),
                                  onSubmitted: (String newText) {
                                    if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                                      Get.find<ChatController>().toggleSendButtonActivity();
                                    }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                                      Get.find<ChatController>().toggleSendButtonActivity();
                                    }
                                  },
                                  onChanged: (String newText) {
                                    if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                                      Get.find<ChatController>().toggleSendButtonActivity();
                                    }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                                      Get.find<ChatController>().toggleSendButtonActivity();
                                    }
                                  },
                                ),
                              ),

                              InkWell(
                                onTap: () async {
                                  Get.find<ChatController>().pickImage(false);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                  child: CustomAssetImageWidget(image: Images.image, width: 25, height: 25, color: Theme.of(context).hintColor),
                                ),
                              ),

                            ]),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5), width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: GetBuilder<ChatController>(builder: (chatController) {
                            return chatController.isLoading ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator()),
                            ) : InkWell(
                              onTap: () async {
                                if(chatController.isSendButtonActive) {
                                  await chatController.sendMessage(
                                    message: _inputMessageController.text, notificationBody: widget.notificationBody, conversationId: widget.conversationId,
                                  ).then((value) {
                                    if(value!.statusCode == 200){
                                      Future.delayed(const Duration(seconds: 2),() {
                                        chatController.getMessages(1, widget.notificationBody!, widget.user, widget.conversationId);
                                      });
                                    }
                                  });
                                  _inputMessageController.clear();
                                }else{
                                  showCustomSnackBar('write_somethings'.tr);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                child: chatController.isLoading ? const SizedBox(
                                  //width: 25, height: 25,
                                  child: CircularProgressIndicator(),
                                ) : Image.asset(
                                  Images.send, width: 25, height: 25,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                          }
                          ),
                        ),

                      ]),
                    ),

                  ]),
                ) : const SizedBox(),
              ]),
            ),
          ),
        ) : Center(child: Text('not_login'.tr)),
      );
    });
  }
}