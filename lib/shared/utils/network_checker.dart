import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/constants/colors.dart';

class NetworkChecker {
  static Widget networkMeter(RxString value) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 2.0, color: ColorConstants.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildNetworkIcon(value.value),
        ),
      ),
    );
  }

  static Widget _buildNetworkIcon(String quality) {
    switch (quality) {
      case "excellent":
        return Icon(
          Icons.signal_cellular_alt_rounded,
          color: Colors.green,
          size: 27,
        );
      case "good":
        return Icon(
          Icons.signal_cellular_alt_rounded,
          color: Colors.green,
          size: 27,
        );
      case "moderate":
        return Icon(
          Icons.signal_cellular_alt_2_bar_rounded,
          color: Colors.yellow,
          size: 27,
        );
      case "poor":
        return Icon(
          Icons.signal_cellular_alt_1_bar_rounded,
          color: Colors.red,
          size: 27,
        );
      default:
        return Icon(
          Icons.signal_cellular_0_bar_rounded,
          color: Colors.red,
          size: 27,
        );
    }
  }
}
