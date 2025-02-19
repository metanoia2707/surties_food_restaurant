import 'package:country_code_picker/country_code_picker.dart';
import 'package:surties_food_restaurant/common/models/response_model.dart';
import 'package:surties_food_restaurant/common/widgets/custom_button_widget.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:surties_food_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:surties_food_restaurant/features/auth/widgets/restaurant_registartion_success_bottom_sheet.dart';
import 'package:surties_food_restaurant/features/language/controllers/localization_controller.dart';
import 'package:surties_food_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:surties_food_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:surties_food_restaurant/helper/custom_validator.dart';
import 'package:surties_food_restaurant/helper/responsive_helper.dart';
import 'package:surties_food_restaurant/helper/route_helper.dart';
import 'package:surties_food_restaurant/util/dimensions.dart';
import 'package:surties_food_restaurant/util/images.dart';
import 'package:surties_food_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();

  String? countryDialCode;

  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty
        ? Get.find<AuthController>().getUserCountryCode()
        : CountryCode.fromCountryCode(
                Get.find<SplashController>().configModel!.country!)
            .dialCode;
    _phoneController.text = Get.find<AuthController>().getUserNumber();

    _showRegistrationSuccessBottomSheet();
  }

  _showRegistrationSuccessBottomSheet() {
    bool canShowBottomSheet =
        Get.find<AuthController>().getIsRestaurantRegistrationSharedPref();
    if (canShowBottomSheet) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => const RestaurantRegistrationSuccessBottomSheet(),
        ).then((value) {
          Get.find<AuthController>()
              .saveIsRestaurantRegistrationSharedPref(false);
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Align(
        alignment: Alignment.center,
        child: Container(
          width: context.width > 700 ? 500 : context.width,
          padding: context.width > 700
              ? const EdgeInsets.all(50)
              : const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraLarge),
          margin:
              context.width > 700 ? const EdgeInsets.all(50) : EdgeInsets.zero,
          decoration: context.width > 700
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  boxShadow: ResponsiveHelper.isDesktop(context)
                      ? null
                      : [
                          BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                )
              : null,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Column(children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Image.asset(Images.logo, height: 80, width: 80),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('sign_in'.tr,
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeExtraLarge)),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          Text(
                            'only_for_restaurant_owner'.tr,
                            textAlign: TextAlign.center,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    CustomTextFieldWidget(
                      hintText: 'xxx-xxx-xxxxx'.tr,
                      showLabelText: false,
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      inputType: TextInputType.phone,
                      isPhone: true,
                      onCountryChanged: (CountryCode countryCode) {
                        countryDialCode = countryCode.dialCode;
                      },
                      countryDialCode: countryDialCode != null
                          ? CountryCode.fromCountryCode(
                                  Get.find<SplashController>()
                                      .configModel!
                                      .country!)
                              .code
                          : Get.find<LocalizationController>()
                              .locale
                              .countryCode,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                        child: ListTile(
                          onTap: () => authController.toggleRememberMe(),
                          leading: Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            value: authController.isActiveRememberMe,
                            onChanged: (bool? isChecked) =>
                                authController.toggleRememberMe(),
                          ),
                          title: Text('remember_me'.tr),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          horizontalTitleGap: 0,
                        ),
                      ),
                     /* TextButton(
                        onPressed: () =>
                            Get.toNamed(RouteHelper.getForgotPassRoute()),
                        child: Text('${'forgot_password'.tr}?'),
                      ),*/
                    ]),
                    const SizedBox(height: 50),
                    !authController.isLoading
                        ? CustomButtonWidget(
                            buttonText: 'sign_in'.tr,
                            onPressed: () => _login(authController,
                                _phoneController, countryDialCode!, context),
                          )
                        : const Center(child: CircularProgressIndicator()),
                    SizedBox(
                        height: Get.find<SplashController>()
                                .configModel!
                                .toggleRestaurantRegistration!
                            ? Dimensions.paddingSizeSmall
                            : 0),
                    Get.find<SplashController>()
                            .configModel!
                            .toggleRestaurantRegistration!
                        ? TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(1, 40),
                            ),
                            onPressed: () async {
                              Get.toNamed(
                                  RouteHelper.getRestaurantRegistrationRoute());
                            },
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '${'join_as'.tr} ',
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context).disabledColor)),
                              TextSpan(
                                  text: 'restaurant'.tr,
                                  style: robotoMedium.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color)),
                            ])),
                          )
                        : const SizedBox(),
                  ]);
                }),
              ),
            ),
          ),
        ),
      )),
    );
  }

  void _login(AuthController authController, TextEditingController phoneCtlr,
      String countryCode, BuildContext context) async {
    String phone = phoneCtlr.text.trim();

    String numberWithCountryCode = countryCode + phone;
    PhoneValid phoneValid =
    await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      authController
          .otpLogin(
        phone: numberWithCountryCode,
        otp: '',
        verified: '',
      )
          .then((status) async {
        if (status.isSuccess) {
          _processOtpSuccessSetup(status, authController, phone, countryCode);
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }

  void _processOtpSuccessSetup(
      ResponseModel response,
      AuthController authController,
      String phone,
      String countryDialCode) async {
    if (authController.isActiveRememberMe) {
      authController.saveUserNumberAndPassword(phone, countryDialCode);
    } else {
      authController.clearUserNumberAndPassword();
    }
    if (response.authResponseModel != null &&
        !response.authResponseModel!.isPhoneVerified!) {
      if (Get.find<SplashController>().configModel!.firebaseOtpVerification!) {
        Get.find<AuthController>()
            .firebaseVerifyPhoneNumber(countryDialCode + phone, '');
      } else {
        Get.toNamed(RouteHelper.getVerificationRoute(
            countryDialCode + phone, null, 'signUp'));
      }
    } else {
      Get.back();
    }
  }
}
