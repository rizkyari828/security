import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/utils/utils.dart';

class AvailabilityChecker {
  static Widget IconNetwork(RxBool value) {
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

  static Widget _buildNetworkIcon(bool quality) {
    switch (quality) {
      case true:
        return Column(
          children: [
            Icon(Icons.signal_cellular_alt, color: Colors.green, size: 27),
            CommonWidget.captionText(text: 'Online'),
          ],
        );
      default:
        return Column(
          children: [
            Icon(Icons.signal_wifi_off, color: Colors.red, size: 27),
            CommonWidget.captionText(text: 'Offline'),
          ],
        );
    }
  }
}
