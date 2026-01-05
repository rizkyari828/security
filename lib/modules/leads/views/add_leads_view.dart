import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:staffku/modules/leads/controllers/leads_controller.dart';
import 'package:staffku/shared/utils/utils.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/image_picker.dart';
import 'package:staffku/shared/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLeadsView extends GetView<LeadsController> {
  const AddLeadsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Tambah Leads'),
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
                CommonWidget.labelExpanded(
                  label: 'Lokasi dari GPS',
                  value: controller.locationDetail.value,
                ),
                SizedBox(height: 20.0),
                CustomDropDownSearch(
                  enabled: true,
                  selectedItem: controller.leadSource.value,
                  listItem: controller.listLeadSource.map((item) {
                    return item.nama.toString();
                  }).toList(),
                  labelText: "Sumber Lead",
                  onChanged: (value) async {
                    controller.leadSource.value = value;
                    for (var f in controller.listLeadSource) {
                      if (f.nama == value) {
                        controller.leadSourceId.value = f.id ?? 0;
                      }
                    }
                    controller.changeStatus(value);
                  },
                ),
                SizedBox(height: 10.0),
                if (controller.optionalText.value) ...[
                  InputInputField(
                    keyboardType: TextInputType.text,
                    controller: controller.agendaController,
                    labelText: "Input Kegiatan",
                    isRequired: true,
                    showError: controller.showInputError.value,
                  ),
                ],
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.nameController,
                  labelText: "Nama Orang / Perusahaan",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.emailController,
                  labelText: "Email Kontak",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.number,
                  controller: controller.noHpController,
                  labelText: "Nomor Telephone",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 20.0),
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
                    controller.changeStatus(value, type: 'gender');
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
                    controller.changeStatus(value);
                  },
                ),
                SizedBox(height: 20.0),
                InputInputField(
                  keyboardType: TextInputType.number,
                  controller: controller.ageController,
                  labelText: "Umur",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 20.0),
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
                  selectedItem: controller.leadCategory.value,
                  listItem: controller.listLeadCategory.map((item) {
                    return item.nama.toString();
                  }).toList(),
                  labelText: "Kategori Lead",
                  onChanged: (value) async {
                    controller.leadCategory.value = value;
                    for (var f in controller.listLeadCategory) {
                      if (f.nama == value) {
                        controller.leadCategoryId.value = f.id ?? 0;
                      }
                    }
                    controller.changeStatus(value);
                  },
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.minatProductController,
                  labelText: "Product Minat",
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 20.0),
                CustomDropDownSearch(
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
                    controller.changeStatus(value);
                  },
                ),
                SizedBox(height: 10.0),
                CommonWidget.bodyText(text: "Catatan"),
                SizedBox(height: 10.0),
                TextAreaField(
                  controller: controller.noteController,
                  isRequired: true,
                  showError: controller.showInputError.value,
                ),
                SizedBox(height: 10.0),
                CommonWidget.minSubtitleText(
                  text: "Silahkan upload bukti Foto patroli anda",
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
