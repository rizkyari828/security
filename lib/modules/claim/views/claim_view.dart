import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/widgets/button.dart';
import '../controllers/claim_controller.dart';

class ClaimView extends GetView<ClaimController> {
  const ClaimView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.lightGray,
      appBar: CommonWidget.appBar(title: 'List Claim'),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Icon(Icons.medical_services_rounded, size: 64, color: Colors.grey),
              const SizedBox(height: 10),
              CommonWidget.subtitleText(
                text: 'Claim kesehatan (new)',
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              CommonWidget.subtitleMultilineText(
                text:
                    'Belum ada data untuk ditampilkan.\nNanti akan berisi list claim + status + detail.',
                color: Colors.grey,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              CustomButton(
                buttonText: 'AJUKAN CLAIM (DRAFT)',
                width: MediaQuery.of(context).size.width,
                onPressed: () {
                  Get.snackbar(
                    'Draft',
                    'Form claim belum dibuat.\n'
                        'Field rencana: tanggal, provider, nominal, lampiran.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
