import 'package:staffku/modules/prospek/controllers/prospek_add_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProspekAddView extends GetView<ProspekAddController> {
  // final CnCController controller = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Tambah Prospek'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidget.labelExpanded(
                  label: 'Tanggal',
                  value: DateFormat(
                    "EEEE, d MMMM yyyy",
                    "id_ID",
                  ).format(DateTime.now()).toString(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    InputInputField(
                      keyboardType: TextInputType.text,
                      controller: controller.nickname,
                      labelText: "Nickname",
                    ),
                    SizedBox(height: 10.0),
                    CustomDropDownSearch(
                      listItem: controller.listSourceOfOrder.map((item) {
                        return item.nama;
                      }).toList(),
                      labelText: "Source of Order",
                      onChanged: (value) async {
                        // controller.nameItem.value = value;
                        for (var f in controller.listSourceOfOrder) {
                          if (f.nama == value) {
                            controller.idSource.value = f.id ?? 0;
                          }
                        }
                      },
                    ),
                    SizedBox(height: 10.0),
                    CommonWidget.bodyText(text: "Keterangan"),
                    SizedBox(height: 10.0),
                    TextAreaField(controller: controller.noteController),
                  ],
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: sw * .08),
        child: CustomButton(
          buttonText: 'SIMPAN',
          width: MediaQuery.of(context).size.width,
          onPressed: () {
            controller.submitProspek();
          },
        ),
      ),
    );
  }
}
