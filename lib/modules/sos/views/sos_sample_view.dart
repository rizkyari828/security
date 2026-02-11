import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/utils/size_config.dart';

class SosSampleView extends StatelessWidget {
  const SosSampleView({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS'),
        backgroundColor: ColorConstants.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidget.minHeadText(text: 'Halaman Sample SOS'),
            const SizedBox(height: 8),
            CommonWidget.subtitleMultilineText(
              text:
                  'Menu SOS masih sementara. Di sini nanti bisa ditaruh fitur emergency / panic button.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: sw,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.mainColor,
                ),
                onPressed: () => Get.back(),
                child: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

