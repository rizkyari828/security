import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/utils/network_checker.dart';

class CustomAppBarWithNetwork extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final RxString networkStatus;
  final Widget? addButton;

  const CustomAppBarWithNetwork({
    required this.title,
    required this.networkStatus,
    this.addButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text(
        title,
        style: TextStyle(
          color: ColorConstants.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          fontFamily: 'Poppins',
        ),
      ),
      actions: [
        NetworkChecker.networkMeter(networkStatus),
        addButton != null ? addButton! : SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
