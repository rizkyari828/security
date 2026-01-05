import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:staffku/modules/agent/controllers/agent_controller.dart';
import 'package:staffku/shared/utils/utils.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/image_picker.dart';
import 'package:staffku/shared/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class AddAgentView extends GetView<AgentController> {
  const AddAgentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Tambah Agent'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidget.labelExpanded(
                  label: 'Tanggal Pendaftaran',
                  value: DateFormat(
                    "EEEE, d MMMM yyyy",
                    "id_ID",
                  ).format(DateTime.now()).toString(),
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.fullNameController,
                  labelText: "Nama Lengkap",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.agentNameController,
                  labelText: "Nama Agent",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.emailController,
                  labelText: "Email",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                CommonWidget.bodyText(text: "Alamat Lengkap"),
                SizedBox(height: 10.0),
                TextAreaField(
                  controller: controller.alamatController,
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.placementController,
                  labelText: "Wilayah Penempatan",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  isSuffixIcon: true,
                  suffixIcon: Icon(Icons.calendar_today_rounded),
                  controller: controller.joinDateController,
                  labelText: "Tanggal Bergabung",
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onSuffixPressed: () {
                    controller.selectDate(context, controller.dateCalled);
                  },
                ),
                SizedBox(height: 20.0),
                CustomDropDownSearch(
                  enabled: true,
                  selectedItem: controller.typeAgent.value,
                  listItem: controller.listTypeAgent.map((item) {
                    return item.nama.toString();
                  }).toList(),
                  labelText: "Jenis Agent",
                  onChanged: (value) async {
                    controller.typeAgent.value = value;
                    for (var f in controller.listTypeAgent) {
                      if (f.nama == value) {
                        controller.typeAgentId.value = f.id.toString();
                      }
                    }
                    controller.changeStatus(value);
                  },
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.registerByController,
                  labelText: "Didaftarkan Oleh",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 20.0),
                CustomDropDownSearch(
                  enabled: true,
                  selectedItem: controller.statusActive.value,
                  listItem: controller.listStatusActive.map((item) {
                    return item.nama.toString();
                  }).toList(),
                  labelText: "Status Aktif",
                  onChanged: (value) async {
                    controller.statusActive.value = value;
                    for (var f in controller.listStatusActive) {
                      if (f.nama == value) {
                        controller.statusActiveId.value = f.id.toString();
                      }
                    }
                    controller.changeStatus(value);
                  },
                ),
                SizedBox(height: 20.0),
                CommonWidget.bodyText(text: "Tanda Tangan Disini"),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Signature(
                    controller: controller.signatureController,
                    height: 150,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                CommonWidget.minSubtitleText(
                  text: "Silahkan upload bukti Foto",
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Obx(
                    () => CustomImagePicker.previewGridImages(controller),
                  ),
                ),
                controller.imageFileList.length < 3
                    ? InkWell(
                        onTap: () {
                          controller.onImageButtonPressed(
                            ImageSource.camera,
                            context: context,
                          );
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
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 10.0),
                CommonWidget.captionText(
                  text: "Maksimal melampirkan 3 Foto",
                  color: Colors.red,
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
