import 'package:intl/intl.dart';
import 'package:staffku/modules/cuti/controllers/cuti_controller.dart';
import 'package:staffku/shared/utils/utils.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCutiView extends GetView<CutiController> {
  const AddCutiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Tambah Cuti'),
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
                  controller: controller.startDateController,
                  labelText: "Tanggal Mulai",
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onSuffixPressed: () {
                    controller.selectDateStart(
                      context,
                      controller.startDateController,
                    );
                  },
                ),
                InputInputField(
                  isSuffixIcon: true,
                  suffixIcon: Icon(Icons.calendar_today_rounded),
                  controller: controller.endDateController,
                  labelText: "Tanggal Selesai",
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onSuffixPressed: () {
                    controller.selectDateStart(
                      context,
                      controller.endDateController,
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
