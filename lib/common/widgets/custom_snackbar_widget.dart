import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_toast.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

Future<void> showCustomSnackBar(String? message, {bool isError = true, bool isWarning = false, bool showToaster = false}) async {
  if(message != null && message.isNotEmpty){
    if(isWarning){
      Flushbar(
        titleText: Text(isError ? 'warning'.tr : '${'success'.tr}!', style: robotoMedium.copyWith(fontWeight: FontWeight.w600, color: Theme.of(Get.context!).textTheme.bodyLarge?.color, fontSize: 16)),
        messageText: Text(message, style: robotoRegular.copyWith(color: Theme.of(Get.context!).disabledColor)),
        icon: Icon(
          isError ? Icons.warning_amber_rounded : Icons.check_circle,
          size: 32,
          color: isError ? Theme.of(Get.context!).primaryColor : Colors.green,
        ),
        borderColor: Theme.of(Get.context!).disabledColor.withOpacity(0.15),
        margin: const EdgeInsets.all(6.0),
        backgroundColor: Theme.of(Get.context!).cardColor,
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.BOTTOM,
        textDirection: Directionality.of(Get.context!),
        borderRadius: BorderRadius.circular(12),
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: isError ? Theme.of(Get.context!).primaryColor : Colors.green,
      ).show(Get.context!);
    }else {
      if(showToaster && !GetPlatform.isWeb){
        await Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: isError ? Colors.red : Colors.green,
          textColor: Colors.white,
          fontSize: Dimensions.fontSizeDefault,
          webShowClose: true,
          webPosition: "left",
        );
      } else {
        ScaffoldMessenger.of(Get.context!)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(
            dismissDirection: DismissDirection.endToStart,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            content: CustomToast(text: message, isError: isError),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ));
      }
    }
  }
}