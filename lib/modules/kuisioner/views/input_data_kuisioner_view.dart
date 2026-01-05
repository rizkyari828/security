import 'package:staffku/modules/kuisioner/controllers/input_data_kuisioner_controller.dart';
import 'package:staffku/shared/utils/utils.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InputDataKuisionerView extends GetView<InputDataKuisionerController> {
  const InputDataKuisionerView({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: sw * .08),
        child: CustomButton(
          buttonText: 'SELANJUTNYA',
          width: MediaQuery.of(context).size.width,
          onPressed: () {
            controller.submitDataForm();
          },
        ),
      ),
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Input Kuisioner'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget.labelExpanded(
                label: 'Tanggal Kuisioner',
                value: DateFormat(
                  "EEEE, d MMMM yyyy",
                  "id_ID",
                ).format(DateTime.now()).toString(),
              ),
              SizedBox(height: 20.0),
              InputInputField(
                keyboardType: TextInputType.text,
                controller: controller.namaController,
                labelText: "Nama",
              ),
              SizedBox(height: 10),
              CommonWidget.bodyText(text: "Keterangan"),
              SizedBox(height: 10.0),
              TextAreaField(
                controller: controller.keteranganController,
                isDisabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
