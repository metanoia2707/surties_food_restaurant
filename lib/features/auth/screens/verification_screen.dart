import 'dart:async';
import 'package:surties_food_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:surties_food_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:surties_food_restaurant/common/widgets/custom_button_widget.dart';
import 'package:surties_food_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:surties_food_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:surties_food_restaurant/features/auth/controllers/forgot_password_controller.dart';
import 'package:surties_food_restaurant/features/business/screens/subscription_payment_screen.dart';
import 'package:surties_food_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:surties_food_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:surties_food_restaurant/helper/route_helper.dart';
import 'package:surties_food_restaurant/util/dimensions.dart';
import 'package:surties_food_restaurant/util/images.dart';
import 'package:surties_food_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final String? number;
  final String? firebaseSession;
  final bool fromSignUp;

  const VerificationScreen(
      {super.key,
      required this.number,
      this.firebaseSession,
      required this.fromSignUp});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  String? _number;
  Timer? _timer;
  int _seconds = 0;
  AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();

    Get.find<ForgotPasswordController>()
        .updateVerificationCode('', canUpdate: false);
    _number = widget.number!.startsWith('+')
        ? widget.number
        : '+${widget.number!.substring(1, widget.number!.length)}';
    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if (_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'otp_verification'.tr),
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(
            child: SizedBox(
                width: 1170,
                child: GetBuilder<ForgotPasswordController>(
                    builder: (forgotPasswordController) {
                  return Column(children: [
                    Get.find<SplashController>().configModel!.demo!
                        ? Text(
                            'for_demo_purpose'.tr,
                            style: robotoRegular,
                          )
                        : RichText(
                            text: TextSpan(children: [
                            TextSpan(
                                text: 'enter_the_verification_sent_to'.tr,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).disabledColor)),
                            TextSpan(
                                text: ' $_number',
                                style: robotoMedium.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color)),
                          ])),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: 35),
                      child: PinCodeTextField(
                        length: 6,
                        appContext: context,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.slide,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          fieldHeight: 60,
                          fieldWidth: 50,
                          borderWidth: 1,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          selectedColor:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          selectedFillColor: Colors.white,
                          inactiveFillColor:
                              Theme.of(context).disabledColor.withOpacity(0.2),
                          inactiveColor:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          activeColor:
                              Theme.of(context).primaryColor.withOpacity(0.4),
                          activeFillColor:
                              Theme.of(context).disabledColor.withOpacity(0.2),
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        onChanged:
                            forgotPasswordController.updateVerificationCode,
                        beforeTextPaste: (text) => true,
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'did_not_receive_the_code'.tr,
                        style: robotoRegular.copyWith(
                            color: Theme.of(context).disabledColor),
                      ),
                      !forgotPasswordController.isLoading
                          ? TextButton(
                              onPressed: _seconds < 1
                                  ? () async {
                                      ///Firebase OTP
                                      if (widget.firebaseSession != null) {
                                        await forgotPasswordController
                                            .firebaseVerifyPhoneNumber(_number!,
                                                canRoute: false);
                                        _startTimer();
                                      }
                                    }
                                  : null,
                              child: Text(
                                  '${'resent'.tr}${_seconds > 0 ? ' ($_seconds)' : ''}'),
                            )
                          : Container(
                              height: 20,
                              width: 20,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeLarge),
                              child: const CircularProgressIndicator(),
                            ),
                    ]),
                    forgotPasswordController.verificationCode.length == 6
                        ? !forgotPasswordController.isLoading
                            ? CustomButtonWidget(
                                buttonText: 'verify'.tr,
                                onPressed: () {
                                  if (widget.fromSignUp) {
                                    forgotPasswordController
                                        .verifyFirebaseOtp(
                                            isLogin: widget.fromSignUp,
                                            phoneNumber: _number!,
                                            session: widget.firebaseSession!,
                                            otp: forgotPasswordController
                                                .verificationCode)
                                        .then((value) {
                                      if (value.statusCode == 200) {
                                        _handleVerifyResponse(value, _number);
                                      } else {
                                        showCustomSnackBar(
                                            value.body["message"]);
                                      }
                                    });
                                  } else {
                                    forgotPasswordController
                                        .verifyToken(_number)
                                        .then((value) {
                                      if (value.isSuccess) {
                                        Get.toNamed(
                                            RouteHelper.getResetPasswordRoute(
                                                _number,
                                                forgotPasswordController
                                                    .verificationCode,
                                                'reset-password'));
                                      } else {
                                        showCustomSnackBar(value.message);
                                      }
                                    });
                                  }
                                },
                              )
                            : const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink(),
                  ]);
                }))),
      ))),
    );
  }

  void _handleVerifyResponse(Response response, String? number) async {
    if (response.body['subscribed'] != null) {
      int? restaurantId = response.body['subscribed']['restaurant_id'];
      int? packageId = response.body['subscribed']['package_id'];

      if (packageId == null) {
        authController.saveUserToken(response.body['subscribed']['token'],
            response.body['subscribed']['zone_wise_topic']);
        await authController.updateToken();
        await Get.find<ProfileController>().getProfile();

        Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true));
      } else {
        Get.to(() => SubscriptionPaymentScreen(
            restaurantId: restaurantId!, packageId: packageId));
      }
    } else {
      authController.saveUserToken(
          response.body['token'], response.body['zone_wise_topic']);
      await authController.updateToken();
      Get.find<ProfileController>().getProfile();
      Get.offAllNamed(RouteHelper.getInitialRoute());
    }
  }
}
