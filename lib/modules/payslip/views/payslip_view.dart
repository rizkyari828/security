import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales/modules/payslip/controllers/payslip_controller.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/widgets/button.dart';
import 'package:sales/shared/widgets/input_field.dart';

class PayslipView extends GetView<PayslipController> {
  const PayslipView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.lightGray,
      appBar: CommonWidget.appBar(title: 'Payslip'),
      body: SingleChildScrollView(
        child: Padding(
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
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: ColorConstants.secondaryColor
                              .withAlpha((0.15 * 255).toInt()),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: ColorConstants.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonWidget.subtitleText(
                              text: 'Download Payslip (PDF)',
                              color: ColorConstants.black,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(height: 2),
                            CommonWidget.subtitleMultilineText(
                              text:
                                  'Pilih bulan & tahun, lalu download file PDF payslip.',
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 18),
                  InputInputField(
                    isSuffixIcon: true,
                    suffixIcon: const Icon(Icons.calendar_today_rounded),
                    controller: controller.periodeController,
                    labelText: 'Periode',
                    isDisabled: true,
                    isRequired: true,
                    onSuffixPressed: () => controller.pickPeriode(context),
                  ),
                  const SizedBox(height: 14),
                  if (controller.isDownloading.value)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: LinearProgressIndicator(minHeight: 6),
                    ),
                  CustomButton(
                    width: MediaQuery.of(context).size.width,
                    isDisabled: controller.isDownloading.value,
                    buttonText: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          controller.isDownloading.value
                              ? Icons.downloading_rounded
                              : Icons.download_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          controller.isDownloading.value
                              ? 'MENGUNDUH...'
                              : 'DOWNLOAD PDF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.25,
                          ),
                        ),
                      ],
                    ),
                    onPressed: controller.downloadPdf,
                  ),
                  if ((controller.lastSavedPath.value ?? '').isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Divider(color: ColorConstants.borderColor),
                    const SizedBox(height: 10),
                    CommonWidget.subtitleText(
                      text: 'File terakhir',
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    CommonWidget.subtitleMultilineText(
                      text: controller.lastSavedPath.value ?? '',
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      width: MediaQuery.of(context).size.width,
                      buttonColor: Colors.white,
                      borderColor: ColorConstants.borderColor,
                      buttonTextColor: ColorConstants.black,
                      buttonText: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.open_in_new_rounded,
                              color: ColorConstants.black),
                          SizedBox(width: 10),
                          Text('BUKA FILE'),
                        ],
                      ),
                      onPressed: controller.openLastFile,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
