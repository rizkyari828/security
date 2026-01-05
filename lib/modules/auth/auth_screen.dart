import 'package:flutter/material.dart';
import 'package:staffku/modules/auth/auth.dart';
import 'package:staffku/routes/routes.dart';
import 'package:staffku/shared/shared.dart';
import 'package:get/get.dart';

import '../../shared/utils/custom_pop_scope.dart';

class AuthScreen extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onWillPop: () async => false,
      child: Scaffold(body: Center(child: _buildItems(context))),
    );
  }

  Widget _buildItems(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      children: [
        Icon(
          Icons.home,
          size: SizeConfig().screenWidth * 0.26,
          color: Colors.blueGrey,
        ),
        SizedBox(height: 20.0),
        Text(
          'Welcome',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: CommonConstants.largeText,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Let\'s start now!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: CommonConstants.normalText,
            color: Theme.of(context).textTheme.titleMedium!.color,
          ),
        ),
        SizedBox(height: 50.0),
        GradientButton(
          text: 'Sign In',
          onPressed: () {
            Get.toNamed(Routes.AUTH + Routes.LOGIN, arguments: controller);
          },
        ),
        SizedBox(height: 20.0),
        BorderButton(
          text: 'Sign Up',
          onPressed: () {
            Get.toNamed(Routes.AUTH + Routes.REGISTER, arguments: controller);
          },
        ),
        SizedBox(height: 62.0),
        Text(
          'Alpha Version 0.0.1',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: CommonConstants.smallText,
            color: ColorConstants.tipColor,
          ),
        ),
      ],
    );
  }
}
