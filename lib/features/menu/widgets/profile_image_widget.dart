import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surties_food_restaurant/common/widgets/custom_image_widget.dart';
import 'package:surties_food_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:surties_food_restaurant/features/profile/controllers/profile_controller.dart';

class ProfileImageWidget extends StatelessWidget {
  final double size;
  const ProfileImageWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: Colors.white)),
        child: ClipOval(
          child: CustomImageWidget(
            image: (profileController.profileModel != null &&
                    Get.find<AuthController>().isLoggedIn())
                ? profileController.profileModel!.imageFullUrl ?? ''
                : '',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}
