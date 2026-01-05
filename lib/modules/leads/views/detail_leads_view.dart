import 'package:staffku/modules/leads/controllers/leads_detail_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/image_picker.dart';

class LeadsDetailView extends GetView<LeadsDetailController> {
  final data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Leads'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => controller.detail.value.nama == null
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ColorConstants.mainColor,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ApprovalFlow.statusApprovalProspect(
                        controller.detail.value.statusLead,
                      ),
                      SizedBox(height: 20.0),
                      if (controller.isEdit.value) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.9,
                              child: CustomDropDownSearch(
                                enabled: true,
                                selectedItem: controller.statusLead.value,
                                listItem: controller.listStatusLead.map((item) {
                                  return item.nama.toString();
                                }).toList(),
                                labelText: "Status Lead",
                                onChanged: (value) async {
                                  controller.statusLead.value = value;
                                  for (var f in controller.listStatusLead) {
                                    if (f.nama == value) {
                                      controller.statusLeadId.value = f.id ?? 0;
                                    }
                                  }
                                },
                              ),
                            ),
                            CustomButton(
                              buttonText: 'UPDATE',
                              width: MediaQuery.of(context).size.width / 3,
                              onPressed: () {
                                controller.submit();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Divider(color: ColorConstants.borderColor),
                        SizedBox(height: 10.0),
                      ],
                      CommonWidget.labelExpanded(
                        label: 'Sumber Leads',
                        value:
                            controller.detail.value.sumberLeadsId.toString() !=
                                ''
                            ? controller.detail.value.sumberLeadsValue
                                  .toString()
                            : controller.detail.value.sumberLeads2.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Nama',
                        value: controller.detail.value.nama.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Umur',
                        value: controller.detail.value.age.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Jenis Kelamin',
                        value: controller.detail.value.gender.toString() == ''
                            ? ''
                            : controller.detail.value.gender.toString() == 'L'
                            ? 'Laki-Laki'
                            : 'Perempuan',
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Email',
                        value: controller.detail.value.email.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Telephone',
                        value: controller.detail.value.telphone.toString(),
                      ),
                      // SizedBox(height: 10.0),
                      // CommonWidget.labelExpanded(
                      //     label: 'Alamat',
                      //     value: controller.detail.value.alamat.toString()),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Status Pekerjaan',
                        value: controller.detail.value.statusPekerjaanValue
                            .toString(),
                      ),
                      SizedBox(height: 10.0),
                      // CommonWidget.labelExpanded(
                      //     label: 'Titik Kordinat',
                      //     value: controller.detail.value.nama),
                      //      SizedBox(height: 10.0),
                      // CommonWidget.labelExpanded(
                      //     label: 'Kategori Lead',
                      //     value: controller.detail.value.),
                      //      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Product Minat',
                        value: controller.detail.value.productMinat.toString(),
                      ),
                      SizedBox(height: 10.0),
                      // CommonWidget.labelExpanded(
                      //     label: 'Status Lead',
                      //     value: controller.detail.value.nama),
                      // SizedBox(height: 10.0),
                      CommonWidget.bodyText(text: "Alamat"),
                      SizedBox(height: 10.0),
                      CommonWidget.bodyText(
                        text: controller.detail.value.alamat ?? '',
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.bodyText(text: "Catatan"),
                      SizedBox(height: 10.0),
                      CommonWidget.bodyText(
                        text: controller.detail.value.catatan ?? '',
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.bodyText(text: "Foto"),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Obx(
                          () => CustomImagePicker.previewGridImages(controller),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
