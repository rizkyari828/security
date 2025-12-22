import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/widgets/button.dart';
import '../controllers/payslip_controller.dart';

class PayslipView extends GetView<PayslipController> {
  const PayslipView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.lightGray,
      appBar: CommonWidget.appBar(title: 'Payslip'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 1.0, color: ColorConstants.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget.subtitleMultilineText(
                text: 'Sementara: hanya download file Excel dari backend.',
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonText: 'DOWNLOAD EXCEL',
                width: MediaQuery.of(context).size.width,
                onPressed: () async {
                  await controller.downloadExcel();
                  Get.snackbar(
                    'Draft',
                    'Endpoint download excel belum dihubungkan.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
