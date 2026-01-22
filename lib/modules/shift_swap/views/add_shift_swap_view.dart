import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/models/response/shift_swap/get_shift_response.dart';
import 'package:staffku/modules/shift_swap/controllers/shift_swap_controller.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/input_field.dart';

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
                  value: DateFormat(
                    'EEEE, d MMMM yyyy',
                    'id_ID',
                  ).format(DateTime.now()).toString(),
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
                if (controller.isLoadingShiftOptions.value)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
                CustomDropDownSearch(
                  listItem: controller.shiftOptions,
                  labelText: 'Shift',
                  enabled: !controller.isLoadingShiftOptions.value,
                  selectedItem: controller.selectedShift.value,
                  onChanged: (value) {
                    controller.selectedShift.value = value as ShiftOption?;
                    controller.markFormDirty();
                  },
                ),
                if (controller.showInputError.value &&
                    controller.selectedShift.value == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0, left: 4.0),
                    child: Text(
                      'Harus diisi',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    'Catatan / alasan',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      letterSpacing: 0.5,
                      color: Color.fromARGB(255, 20, 22, 24),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                TextAreaField(
                  controller: controller.noteController,
                  hintText: 'Tulis catatan / alasan',
                  isRequired: true,
                  showError: controller.showInputError.value,
                  minLines: 3,
                  maxLines: 5,
                  onChanged: (_) => controller.markFormDirty(),
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
