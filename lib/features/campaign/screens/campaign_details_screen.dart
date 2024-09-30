import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/widgets/join_campaign_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/domain/models/campaign_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignDetailsScreen extends StatelessWidget {
  final CampaignModel campaignModel;
  const CampaignDetailsScreen({super.key, required this.campaignModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'campaign_details'.tr),
      body: Column(children: [

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: CustomImageWidget(
                  fit: BoxFit.cover, placeholder: Images.restaurantCover,
                  image: '${campaignModel.imageFullUrl}',
                  height: 160,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                campaignModel.title ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                campaignModel.description ?? 'no_description_found'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.5)),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text('activate'.tr, style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.5),
                      )),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        child: Column(children: [

                          Row(children: [

                            Text('${'date'.tr}: ', style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
                            )),

                            Text(
                              DateConverter.convertDateToDate(campaignModel.availableDateStarts!),
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                            ),

                          ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Row(children: [

                            Text('${'daily'.tr}: ', style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
                            )),

                            Text(
                              '${DateConverter.convertStringTimeToTime(campaignModel.startTime!)}'' - ${DateConverter.convertStringTimeToTime(campaignModel.endTime!)}',
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                            ),

                          ]),

                        ]),
                      ),

                    ]),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text('end_date'.tr, style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.5),
                    )),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Column(children: [

                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeSmall),
                          child: Column(children: [

                            Text(
                              DateConverter.stringToLocalDateDayOnly(campaignModel.availableDateEnds!),
                              style: robotoBold.copyWith(fontSize: 20),
                            ),

                            Text(
                              DateConverter.stringToLocalDateMonthAndYearOnly(campaignModel.availableDateEnds!),
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.5)),
                            ),

                          ]),
                        ),

                      ]),
                    ),

                  ]),

                ]),
              ),
              SizedBox(height: campaignModel.isJoined! ? Dimensions.paddingSizeLarge : 0),

              campaignModel.isJoined! ? Row(children: [

                const CustomAssetImageWidget(
                  image: Images.campaignJoinIcon, height: 40, width: 40,
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                
                Text(
                  'you_have_already_joined_this_campaign'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.green.withOpacity(0.5)),
                ),

              ]) : const SizedBox(),

            ]),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeExtraLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
          ),
          child: CustomButtonWidget(
            buttonText: campaignModel.isJoined! ? 'leave_now'.tr : 'join_now'.tr,
            color: campaignModel.isJoined! ? Theme.of(context).disabledColor.withOpacity(0.5) : Theme.of(context).primaryColor,
            textColor: campaignModel.isJoined! ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).cardColor,
            onPressed: () {
              showCustomBottomSheet(
                child: JoinCampaignBottomSheetWidget(
                  isJoined: campaignModel.isJoined!,
                  campaignID: campaignModel.id,
                ),
              );
            },
          ),
        ),

      ]),
    );
  }
}