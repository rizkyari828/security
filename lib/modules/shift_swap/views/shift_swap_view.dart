import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/widgets/button.dart';
import 'package:sales/shared/widgets/input_field.dart';
import '../controllers/shift_swap_controller.dart';

class ShiftSwapView extends GetView<ShiftSwapController> {
  const ShiftSwapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.lightGray,
      appBar: CommonWidget.appBar(title: 'Tukar Shift'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
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
                  InputInputField(
                    controller: controller.userIdController,
                    labelText: "user_id",
                    isDisabled: true,
                  ),
                  InputInputField(
                    isSuffixIcon: true,
                    suffixIcon: const Icon(Icons.calendar_today_rounded),
                    controller: controller.tglTukarController,
                    labelText: "tgl_tukar",
                    isDisabled: true,
                    isRequired: true,
                    showError: controller.showInputError.value,
                    onSuffixPressed: () => controller.selectTglTukar(context),
                  ),
                  const SizedBox(height: 10.0),
                  CustomDropDownSearch(
                    listItem: controller.shiftOptions,
                    labelText: "shift_tukar",
                    selectedItem: controller.shiftTukar.value.isEmpty
                        ? null
                        : controller.shiftTukar.value,
                    onChanged: (value) {
                      controller.shiftTukar.value = (value ?? '').toString();
                    },
                  ),
                  if (controller.showInputError.value &&
                      controller.shiftTukar.value.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                      child: Text(
                        'Harus diisi',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  InputInputField(
                    controller: controller.userIdPenggantiController,
                    labelText: "user_id_pengganti",
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    showError: controller.showInputError.value,
                  ),
                  const SizedBox(height: 24.0),
                  CustomButton(
                    buttonText: 'SUBMIT (DRAFT)',
                    width: MediaQuery.of(context).size.width,
                    isDisabled: !controller.canSubmit,
                    onPressed: controller.submitDraft,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
