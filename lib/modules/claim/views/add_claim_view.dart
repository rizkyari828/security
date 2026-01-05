import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/modules/claim/controllers/claim_controller.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/input_field.dart';

class AddClaimView extends GetView<ClaimController> {
  const AddClaimView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Tambah Claim'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidget.labelExpanded(
                  label: 'Tanggal Pengajuan',
                  value: DateFormat(
                    'EEEE, d MMMM yyyy',
                    'id_ID',
                  ).format(DateTime.now()).toString(),
                ),
                const SizedBox(height: 10.0),
                InputInputField(
                  isSuffixIcon: true,
                  suffixIcon: const Icon(Icons.calendar_today_rounded),
                  controller: controller.tanggalClaimController,
                  labelText: 'Tanggal Claim',
                  isDisabled: true,
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onSuffixPressed: () => controller.selectTanggalClaim(context),
                ),
                const SizedBox(height: 10.0),
                InputInputField(
                  controller: controller.nominalController,
                  labelText: 'Nominal',
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                const SizedBox(height: 10.0),
                CommonWidget.bodyText(text: 'Keterangan'),
                const SizedBox(height: 10.0),
                TextAreaField(
                  controller: controller.keteranganController,
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                const SizedBox(height: 30.0),
                CustomButton(
                  buttonText: 'SIMPAN',
                  width: MediaQuery.of(context).size.width,
                  isDisabled: !controller.canSubmit,
                  onPressed: controller.submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
