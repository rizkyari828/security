import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sales/modules/store/controllers/store_add_controller.dart';
import 'package:sales/shared/utils/utils.dart';
import 'package:sales/shared/widgets/button.dart';
import 'package:sales/shared/widgets/custom_appbar.dart';
import 'package:sales/shared/widgets/image_picker.dart';
import 'package:sales/shared/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStoreView extends GetView<StoreAddController> {
  const AddStoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarWithNetwork(
          title: 'Tambah Patroli',
          networkStatus: controller.qualityNetwork,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.labelExpanded(
                        label: 'Tanggal Pengajuan',
                        value: DateFormat("EEEE, d MMMM yyyy", "id_ID")
                            .format(DateTime.now())
                            .toString()),
                    SizedBox(height: 10.0),
                    CommonWidget.labelExpanded(
                        label: 'Lokasi dari GPS',
                        value: controller.locationDetail.value),
                    SizedBox(height: 20.0),
                    InputInputField(
                      keyboardType: TextInputType.text,
                      controller: controller.nameController,
                      labelText: "Nama yang dipatroli",
                      isRequired: true,
                      showError: controller.showInputError.value,
                    ),
                    SizedBox(height: 10.0),
                    CommonWidget.bodyText(text: "Detail Alamat"),
                    SizedBox(height: 10.0),
                    TextAreaField(
                      controller: controller.alamatController,
                      isRequired: true,
                      showError: controller.showInputError.value,
                    ),
                    SizedBox(height: 20.0),
                    CustomDropDownSearch(
                      enabled: true,
                      selectedItem: controller.agenda.value,
                      listItem: controller.listAgenda.map((item) {
                        return item.nama.toString();
                      }).toList(),
                      labelText: "Aktivitas Patroli",
                      onChanged: (value) async {
                        controller.agenda.value = value;
                        controller.agendaId.value = value;
                        controller.changeStatus(value);
                      },
                    ),
                    SizedBox(height: 20.0),
                    CustomDropDownSearch(
                      enabled: true,
                      selectedItem: controller.status.value,
                      listItem: controller.listStatus.map((item) {
                        return item.nama.toString();
                      }).toList(),
                      labelText: "Status Patroli",
                      onChanged: (value) async {
                        controller.status.value = value;
                        controller.statusId.value = value;
                        controller.changeStatus(value);
                      },
                    ),
                    SizedBox(height: 10.0),
                    CommonWidget.bodyText(text: "Catatan Patroli"),
                    SizedBox(height: 10.0),
                    TextAreaField(
                      controller: controller.visitNoteController,
                      isRequired: true,
                      showError: controller.showInputError.value,
                    ),
                    SizedBox(height: 10.0),
                    CommonWidget.bodyText(text: "Rencana Tindak Lanjut"),
                    SizedBox(height: 10.0),
                    TextAreaField(
                      controller: controller.planExecutionController,
                      isRequired: true,
                      showError: controller.showInputError.value,
                    ),
                    SizedBox(height: 10.0),
                    CommonWidget.minSubtitleText(
                        text: "Silahkan upload bukti Foto patroli anda"),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Obx(() =>
                          CustomImagePicker.previewGridImages(controller)),
                    ),
                    controller.imageFileList.length < 3
                        ? InkWell(
                            onTap: () {
                              controller.onImageButtonPressed(
                                  ImageSource.camera,
                                  context: context);
                            },
                            child: DottedBorder(
                              options: RectDottedBorderOptions(
                                color: Colors.grey,
                                dashPattern: [8, 4],
                                strokeWidth: 1,
                              ),
                              child: Container(
                                height: 50,
                                width: sw,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                    SizedBox(width: 10.0),
                                    CommonWidget.bodyText(
                                        text: "Ambil Photos",
                                        color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(height: 10.0),
                    CommonWidget.captionText(
                        text: "Maksimal melampirkan 3 Foto", color: Colors.red),
                    SizedBox(height: 30.0),
                    CustomButton(
                      buttonText: 'SIMPAN',
                      width: MediaQuery.of(context).size.width,
                      onPressed: () {
                        controller.submit();
                      },
                    ),
                  ],
                )),
          ),
        ));
  }
}
