import 'package:staffku/modules/prospek_v2/controllers/prospek_add_controller.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:staffku/shared/shared.dart';
import 'package:staffku/shared/utils/custom_pop_scope.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProspekV2AddView extends GetView<ProspekV2AddController> {
  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.PROSPEK_V2);
        return false;
      },
      child: Obx(() => _buildWidget(context)),
    );
  }

  Widget _buildWidget(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(
        title: controller.isEdit.value ? 'Edit Prospek' : 'Tambah Prospek',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stepsIcon(controller.statusBar.value),
              SizedBox(height: 20.0),
              if (controller.isEdit.value) ...[
                ApprovalFlow.statusApprovalProspectV2(
                  controller.detail.value.sourceOrderValue ??
                      'Belum ada Status',
                ),
                SizedBox(height: 20.0),
                controller.detail.value.idLead != 0
                    ? CommonWidget.labelExpanded(
                        label: 'ID Leads',
                        value: controller.detail.value.idLead.toString(),
                      )
                    : Container(),
                SizedBox(height: 10.0),
                CommonWidget.labelExpanded(
                  label: 'Nama Prospek',
                  value: controller.prospectNameController.text,
                ),
                SizedBox(height: 20.0),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!controller.isEdit.value) ...[
                    SizedBox(height: 10.0),
                    InputInputField(
                      isDisabled: controller.disabled.value,
                      keyboardType: TextInputType.text,
                      controller: controller.prospectNameController,
                      labelText: "Nama Prospek",
                      isRequired: true,
                      showError: controller.showInputError.value,
                    ),
                    SizedBox(height: 20.0),
                  ],
                  CustomDropDownSearch(
                    listItem: controller.listGender.map((item) {
                      return item.nama;
                    }).toList(),
                    selectedItem: controller.genderValue.value,
                    labelText: "Jenis Kelamin",
                    onChanged: (value) async {
                      controller.genderValue.value = value;
                      // for (var f in controller.listGender) {
                      //   if (f.nama == value) {
                      //     controller.idGender.value = f.id ?? 0;
                      //   }
                      // }
                      controller.changeStatus(value, 'gender');
                    },
                  ),
                  SizedBox(height: 40.0),
                  CustomDropDownSearch(
                    listItem: controller.listStatusPekerjaan.map((item) {
                      return item.nama;
                    }).toList(),
                    selectedItem: controller.statusPekerjaan.value,
                    labelText: "Status Pekerjaan",
                    onChanged: (value) async {
                      controller.statusPekerjaan.value = value;
                      for (var f in controller.listStatusPekerjaan) {
                        if (f.nama == value) {
                          controller.statusPekerjaanId.value = f.id ?? 0;
                        }
                      }
                      controller.changeStatus(value, 'status pekerjaan');
                    },
                  ),
                  SizedBox(height: 20.0),
                  InputInputField(
                    isDisabled: controller.disabled.value,
                    keyboardType: TextInputType.number,
                    controller: controller.ageController,
                    labelText: "Umur",
                    isRequired: true,
                    showError: controller.showInputError.value,
                  ),
                  SizedBox(height: 20.0),
                  CustomDropDownSearch(
                    enabled: !controller.disabled.value,
                    selectedItem: controller.minatProduct.value,
                    listItem: controller.listMinatProduct.map((item) {
                      return item.nama.toString();
                    }).toList(),
                    labelText: "Minat Product",
                    onChanged: (value) async {
                      controller.minatProduct.value = value;
                      for (var f in controller.listMinatProduct) {
                        if (f.nama == value) {
                          controller.minatProductId.value = f.id ?? 0;
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  if (controller.optionalTextProduk.value) ...[
                    CommonWidget.bodyText(text: "Minat Product"),
                    SizedBox(height: 10.0),
                    TextAreaField(
                      controller: controller.otherProduct,
                      isRequired: true,
                      showError: controller.showInputError.value,
                      isDisabled: controller.disabled.value,
                    ),
                  ],
                  InputInputField(
                    keyboardType: TextInputType.text,
                    controller: controller.totalTransaction,
                    labelText: "Estimasi Nilai Transaksi",
                    isRequired: true,
                    showError: controller.showInputError.value,
                    isDisabled: controller.disabled.value,
                  ),
                  SizedBox(height: 20.0),
                  CustomDropDownSearch(
                    listItem: controller.listStatusProspect.map((item) {
                      return item.nama;
                    }).toList(),
                    labelText: "Status Prospek",
                    selectedItem: controller.statusProspectValue.value,
                    onChanged: (value) async {
                      controller.statusProspectValue.value = value;
                      for (var f in controller.listStatusProspect) {
                        if (f.nama == value) {
                          controller.idStatusProspect.value = f.id ?? 0;
                        }
                      }
                      controller.changeStatus(value, 'produk');
                    },
                  ),
                  // SizedBox(height: 20.0),
                  // InputInputField(
                  //   isSuffixIcon: true,
                  //   suffixIcon: Icon(Icons.calendar_today_rounded),
                  //   controller: controller.dateCalled,
                  //   labelText: "Tanggal Dihubungi",
                  //   isRequired: true,
                  //   showError: controller.showInputError.value,
                  //   onSuffixPressed: () {
                  //     controller.selectDate(context, controller.dateCalled);
                  //   },
                  //   isDisabled: controller.disabled.value,
                  // ),
                  SizedBox(height: 20.0),
                  CustomDropDownSearch(
                    listItem: controller.listMediaCommuncation.map((item) {
                      return item.nama;
                    }).toList(),
                    labelText: "Media Komunikasi",
                    selectedItem: controller.mediaCommunicationValue.value,
                    onChanged: (value) async {
                      controller.mediaCommunicationValue.value = value;
                      for (var f in controller.listMediaCommuncation) {
                        if (f.nama == value) {
                          controller.idMediaCommunication.value = f.id ?? 0;
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  InputInputField(
                    isSuffixIcon: true,
                    suffixIcon: Icon(Icons.calendar_today_rounded),
                    controller: controller.dateFu,
                    labelText: "Tanggal Follow Up",
                    isRequired: true,
                    showError: controller.showInputError.value,
                    onSuffixPressed: () {
                      controller.selectDate(context, controller.dateFu);
                    },
                    isDisabled: controller.disabled.value,
                  ),
                  SizedBox(height: 10.0),
                  CommonWidget.bodyText(text: "Catatan Komunikasi"),
                  SizedBox(height: 10.0),
                  TextAreaField(
                    controller: controller.noteCommunication,
                    isRequired: true,
                    showError: controller.showInputError.value,
                    isDisabled: controller.disabled.value,
                  ),
                  SizedBox(height: 20.0),
                  CustomDropDownSearch(
                    listItem: controller.listSourceOfOrder.map((item) {
                      return item.nama;
                    }).toList(),
                    selectedItem: controller.sourceOrderValue.value,
                    labelText: "Status Order",
                    onChanged: (value) async {
                      controller.sourceOrderValue.value = value;
                      for (var f in controller.listSourceOfOrder) {
                        if (f.nama == value) {
                          controller.idSource.value = f.id ?? 0;
                        }
                      }
                      controller.changeStatus(value, 'status order');
                    },
                  ),
                  SizedBox(height: 20.0),
                  if (controller.optionalTextOrder.value) ...[
                    CommonWidget.bodyText(text: "Alasan Tidak Order"),
                    SizedBox(height: 10.0),
                    TextAreaField(
                      controller: controller.reasonNotOrder,
                      isRequired: true,
                      showError: controller.showInputError.value,
                      isDisabled: controller.disabled.value,
                    ),
                  ],
                  SizedBox(height: 100.0),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: controller.disabled.value
          ? Container()
          : Padding(
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

  Widget divLine() {
    final sw = SizeConfig().screenWidth;
    return Padding(
      padding: EdgeInsets.only(left: sw * .01, right: sw * .01),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.grey,
        ),
        width: sw * .09,
        height: sw * .02,
      ),
    );
  }

  Widget stepsIcon(String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        step(
          status.toLowerCase() == 'lead' || status.toLowerCase() == 'prospek'
              ? true
              : false,
          'Lead',
          Icons.person_add_alt_1,
        ),
        divLine(),
        step(
          status.toLowerCase() == 'prospek' ? true : false,
          'Prospek',
          Icons.handshake_rounded,
        ),
        divLine(),
        Divider(color: Colors.black),
        step(
          status.toLowerCase() == 'order' ? true : false,
          'Order',
          Icons.assignment_turned_in,
        ),
      ],
    );
  }

  Widget step(bool active, String status, IconData icon) {
    final sw = SizeConfig().screenWidth;
    return Container(
      height: active ? sw * .22 : sw * .21,
      width: active ? sw * .22 : sw * .21,
      decoration: BoxDecoration(
        color: active ? ColorConstants.mainColor : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: ColorConstants.white, size: active ? 35 : 33),
            CommonWidget.captionText(text: status, color: ColorConstants.white),
          ],
        ),
      ),
    );
  }
}
