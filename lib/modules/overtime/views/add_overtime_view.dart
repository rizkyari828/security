import 'package:intl/intl.dart';
import 'package:staffku/modules/overtime/controllers/overtime_controller.dart';
import 'package:staffku/shared/utils/utils.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOvertimeView extends GetView<OvertimeController> {
  const AddOvertimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Tambah Lembur'),
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
                    "EEEE, d MMMM yyyy",
                    "id_ID",
                  ).format(DateTime.now()).toString(),
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  isSuffixIcon: true,
                  suffixIcon: Icon(Icons.calendar_today_rounded),
                  controller: controller.dateController,
                  labelText: "Tanggal Lembur",
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onSuffixPressed: () {
                    controller.selectDateStart(context);
                  },
                ),
                InputInputField(
                  isSuffixIcon: true,
                  suffixIcon: Icon(Icons.access_time),
                  controller: controller.startTimeController,
                  labelText: "Jam Mulai",
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onSuffixPressed: () {
                    controller.selectTime(
                      context,
                      controller.startTimeController,
                    );
                  },
                ),
                InputInputField(
                  isSuffixIcon: true,
                  suffixIcon: Icon(Icons.access_time),
                  controller: controller.endTimeController,
                  labelText: "Jam Selesai",
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onSuffixPressed: () {
                    controller.selectTime(
                      context,
                      controller.endTimeController,
                    );
                  },
                ),
                controller.validationDate.value != ""
                    ? CommonWidget.captionText(
                        text: controller.validationDate.value,
                        color: Colors.red,
                      )
                    : SizedBox(height: 0),
                SizedBox(height: 10.0),
                CommonWidget.bodyText(text: "Keperluan"),
                SizedBox(height: 10.0),
                TextAreaField(
                  controller: controller.noteController,
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 30.0),
                CustomButton(
                  buttonText: 'SIMPAN',
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    controller.submit();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
