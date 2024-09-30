import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/veg_filter_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> with TickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  final bool? _review = Get.find<ProfileController>().profileModel!.restaurants![0].reviewsSection;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _review! ? 2 : 1, initialIndex: 0, vsync: this);
    _tabController!.addListener(() {
      Get.find<RestaurantController>().setTabIndex(_tabController!.index);
    });
    Get.find<RestaurantController>().getProductList('1', 'all');
    Get.find<RestaurantController>().getRestaurantReviewList(Get.find<ProfileController>().profileModel!.restaurants![0].id, '');
    Get.find<RestaurantController>().getRestaurantCategories();

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return GetBuilder<ProfileController>(builder: (profileController) {


        if(profileController.profileModel!.restaurants![0].restaurantModel == 'subscription'){
        } else {
        }

        Restaurant? restaurant = profileController.profileModel != null ? profileController.profileModel!.restaurants![0] : null;

        return Scaffold(
          backgroundColor: Theme.of(context).cardColor,

          floatingActionButton: GetBuilder<RestaurantController>(
              builder: (restaurantController) {
                return restaurantController.isFabVisible ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [

                  InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getAnnouncementRoute(announcementStatus: restaurant!.isAnnouncementActive!, announcementMessage: restaurant.announcementMessage ?? '')),
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                        border: Border.all(color: Theme.of(context).cardColor, width: 4),
                        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                      ),
                      child: Image.asset(Images.announcementIcon, height: 25, width: 25, color: Theme.of(context).cardColor),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  InkWell(
                    onTap: () {
                      if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
                        if(Get.find<ProfileController>().profileModel!.subscriptionOtherData != null && Get.find<ProfileController>().profileModel!.subscriptionOtherData!.maxProductUpload == 0
                            && Get.find<ProfileController>().profileModel!.restaurants![0].restaurantModel == 'subscription'){
                          showCustomSnackBar('your_food_add_limit_is_over'.tr);
                        }else {
                          if (restaurant != null) {
                            Get.toNamed(RouteHelper.getAddProductRoute(null));
                          }
                        }
                      }else {
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                        border: Border.all(color: Theme.of(context).cardColor, width: 4),
                        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                      ),
                      child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 25),
                    ),
                  ),

                ]) : const SizedBox();
              }
          ),

          body: restaurant != null ? CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [

              SliverAppBar(
                expandedHeight: 230, toolbarHeight: 50,
                pinned: true, floating: false,
                surfaceTintColor: Theme.of(context).cardColor,
                //backgroundColor: Theme.of(context).primaryColor,

                /*leading: Container(
                    margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      border: Border.all(color: Theme.of(context).cardColor, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),*/

                /*actions: [IconButton(
                    icon: Container(
                      height: 50, width: 50, alignment: Alignment.center,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                      child: Image.asset(Images.edit),
                    ),
                    onPressed: () => Get.toNamed(RouteHelper.getRestaurantSettingsRoute(restaurant)),
                  )],*/
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(clipBehavior: Clip.none, children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
                      child: CustomImageWidget(
                        fit: BoxFit.cover, placeholder: Images.restaurantCover,
                        image: '${restaurant.coverPhotoFullUrl}',
                        height: 190, width: context.width,
                      ),
                    ),

                    Positioned(
                      bottom: -5, left: 0, right: 0,
                      child: Container(
                        margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: Row(children: [

                          ClipOval(
                            child: CustomImageWidget(
                              image: '${restaurant.logoFullUrl}',
                              height: 70, width: 70, fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text(
                              restaurant.name ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),

                            Text(
                              restaurant.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Row(children: [

                              Icon(Icons.star_rounded, color: Theme.of(context).primaryColor, size: 18),

                              Text(
                                restaurant.avgRating!.toStringAsFixed(1),
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall + 1),

                              Container(
                                height: 10, width: 1, color: Theme.of(context).disabledColor,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall + 1),

                              Text(
                                '${restaurant.ratingCount ?? 0} ${'ratings'.tr}',
                                style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor,
                                  height: 1.3, fontWeight: FontWeight.w600,
                                ),
                              ),

                            ]),


                          ])),
                          const SizedBox(width: Dimensions.paddingSizeDefault),

                          InkWell(
                            onTap: () => Get.toNamed(RouteHelper.getRestaurantSettingsRoute(restaurant)),
                            child: Container(
                              height: 40, width: 40, alignment: Alignment.center,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                              child: Icon(Icons.edit, color: Theme.of(context).cardColor, size: 20),
                            ),
                          ),

                        ]),
                      ),
                    ),
                  ]),
                ),
              ),

              SliverToBoxAdapter(child: Center(child: Container(
                width: 1170,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                color: Theme.of(context).cardColor,
                child: Column(children: [
                  restaurant.discount != null ? Container(
                    width: context.width,
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                      Text(
                        '${restaurant.discount!.discount}% ${'off'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ),

                      Text(
                        '${'enjoy'.tr} ${restaurant.discount!.discount}% ${'off_on_all_categories'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ),
                      SizedBox(height: (restaurant.discount!.minPurchase != 0 || restaurant.discount!.maxDiscount != 0) ? 5 : 0),

                      restaurant.discount!.minPurchase != 0 ? Text(
                        '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.minPurchase)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ) : const SizedBox(),

                      restaurant.discount!.maxDiscount != 0 ? Text(
                        '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.maxDiscount)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ) : const SizedBox(),

                    ]),
                  ) : const SizedBox(),

                  (restaurant.delivery! && restaurant.freeDelivery!) ? Text(
                    'free_delivery'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  ) : const SizedBox(),

                ]),
              ))),

              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                          Text('all_foods'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),

                          VegFilterWidget(type: restController.type, onSelected: (String type) {
                            Get.find<RestaurantController>().getProductList('1', type);
                          }),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      restController.categoryNameList != null ? SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: restController.categoryNameList!.length,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => restController.setCategory(index, restController.categoryNameList![index]),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall),
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                                  color: index == restController.categoryIndex ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                                ),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(
                                   index == 0 ? 'all'.tr : restController.categoryNameList![index],
                                    style: index == restController.categoryIndex ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor) : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  ),
                                ]),
                              ),
                            );
                          },
                        ),
                      ) : SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeExtraSmall),
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Container(
                                  height: 10, width: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).disabledColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),

                    ]),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: ProductViewWidget(scrollController: _scrollController, type: restController.type, onVegFilterTap: (String type) {
                  Get.find<RestaurantController>().getProductList('1', type);
                }),
              ),

            ],
          ) : const Center(child: CircularProgressIndicator()),
        );
      });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 100 || oldDelegate.minExtent != 100 || child != oldDelegate.child;
  }
}