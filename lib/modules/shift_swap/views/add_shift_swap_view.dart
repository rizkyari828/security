import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sales/modules/shift_swap/controllers/shift_swap_controller.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/widgets/button.dart';
import 'package:sales/shared/widgets/input_field.dart';

class AddShiftSwapView extends GetView<ShiftSwapController> {
  const AddShiftSwapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Tambah Tukar Shift'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidget.labelExpanded(
                  label: 'Tanggal Pengajuan',
                  value: DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                      .format(DateTime.now())
                      .toString(),
                ),
                const SizedBox(height: 10.0),
                InputInputField(
                  isSuffixIcon: true,
                  suffixIcon: const Icon(Icons.calendar_today_rounded),
                  controller: controller.tglTukarController,
                  labelText: 'Tanggal Tukar',
                  isDisabled: true,
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onSuffixPressed: () => controller.selectTglTukar(context),
                ),
                const SizedBox(height: 10.0),
                CustomDropDownSearch(
                  listItem: controller.shiftOptions,
                  labelText: 'Shift Tukar',
                  selectedItem: controller.shiftTukar.value.isEmpty
                      ? null
                      : controller.shiftTukar.value,
                  onChanged: (value) {
                    controller.shiftTukar.value = (value ?? '').toString();
                  },
                ),
                if (controller.showInputError.value &&
                    controller.shiftTukar.value.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0, left: 4.0),
                    child: Text(
                      'Harus diisi',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                InputInputField(
                  controller: controller.userIdPenggantiController,
                  labelText: 'User ID Pengganti',
                  keyboardType: TextInputType.number,
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
