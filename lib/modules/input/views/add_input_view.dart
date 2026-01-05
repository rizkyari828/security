import 'package:staffku/modules/input/controllers/input_controller.dart';
import 'package:staffku/shared/utils/utils.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddInputView extends GetView<InputController> {
  const AddInputView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Input Data'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
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
                keyboardType: TextInputType.text,
                controller: controller.nipAdira,
                labelText: "NIP Adira",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.totalBahanCRM,
                labelText: "Total Bahan CRM hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumlahFuWalk,
                labelText: "Jumlah Follow Up Walk hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumlahFuCRM,
                labelText: "Jumlah Follow up CRM by Telepon hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumahBerminat,
                labelText: "Jumlah Konsumen yang berminat hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumlahPikirPikir,
                labelText: "Jumlah Konsumen yang pikir-pikir hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumlahBelumBerminat,
                labelText: "Jumlah Konsumen yang belum berminat hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumlahTidakBisaDihubungi,
                labelText: "Jumlah Konsumen yang tidak bisa dihubungi hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumlah3n,
                labelText: "Jumlah Agen 3N yang didapatkan hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumlahOrder,
                labelText: "Jumlah Order in hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumlahMCY,
                labelText: "Jumlah Booking MCY hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.jumlahCAR,
                labelText: "Jumlah Booking CAR hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.totalMCYCAR,
                labelText: "Total Booking MCY dan CAR hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.totalMCY,
                labelText: "Total Booking MCY dari tanggal 1 hari ini",
              ),
              InputInputField(
                keyboardType: TextInputType.number,
                controller: controller.totalCAR,
                labelText: "Total Booking CAR dari tanggal 1 hari ini",
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
    );
  }
}
