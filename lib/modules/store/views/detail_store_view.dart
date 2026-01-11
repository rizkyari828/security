import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/modules/store/controllers/store_detail_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/utils/utils.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/custom_appbar.dart';
import 'package:staffku/shared/widgets/input_field.dart';

class StoreDetailView extends GetView<StoreDetailController> {
  const StoreDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaleWidth = MediaQuery.of(context).size.width / 360;
    final sw = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarWithNetwork(
          title: controller.namaJadwal.value.isEmpty
              ? 'Detail Patroli'
              : controller.namaJadwal.value,
          networkStatus: controller.qualityNetwork,
        ),
        floatingActionButton: controller.isConnectedToInternetWidget.value
            ? Padding(
                padding: EdgeInsets.only(left: scaleWidth * 30),
                child: controller.internetConnection(),
              )
            : const SizedBox(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: ColorConstants.mainColor,
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidget.labelExpanded(
                    label: 'Status',
                    value: controller.isDone ? 'Sudah patroli' : 'Belum patroli',
                  ),
                  const SizedBox(height: 10.0),
                  CommonWidget.bodyText(text: 'Keterangan'),
                  const SizedBox(height: 10.0),
                  TextAreaField(
                    controller: controller.keteranganController,
                    isRequired: true,
                    showError: controller.showInputError.value,
                    isDisabled: controller.isDone,
                  ),
                  const SizedBox(height: 16.0),
                  CommonWidget.bodyText(text: 'Bukti (Foto)'),
                  const SizedBox(height: 10.0),
                  _photoPicker(context),
                  if (!controller.isDone &&
                      controller.showInputError.value &&
                      controller.selectedPhoto.value == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Foto wajib diisi',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  if (!controller.isDone) ...[
                    const SizedBox(height: 30.0),
                    CustomButton(
                      buttonText: controller.isSubmitting.value
                          ? 'MENGIRIM...'
                          : 'SIMPAN',
                      width: sw,
                      isDisabled: controller.isSubmitting.value,
                      onPressed: controller.submit,
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _photoPicker(BuildContext context) {
    final file = controller.selectedPhoto.value;
    final url = (controller.detail.value?.foto ?? '').trim();
    final hasPhoto = file != null || url.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPhoto)
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 190,
              width: double.infinity,
              color: ColorConstants.backgroundTextField,
              child: file != null
                  ? (kIsWeb
                      ? Image.network(file.path, fit: BoxFit.cover)
                      : Image.file(File(file.path), fit: BoxFit.cover))
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _emptyPhoto(),
                    ),
            ),
          )
        else
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.backgroundTextField,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ColorConstants.borderColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera_rounded,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload foto patroli',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.60),
                  ),
                ),
              ],
            ),
          ),
        if (!controller.isDone) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => controller.pickPhoto(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('Kamera'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => controller.pickPhoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('Galeri'),
                ),
              ),
            ],
          ),
          if (file != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => controller.selectedPhoto.value = null,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                label: const Text(
                  'Hapus foto',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _emptyPhoto() {
    return Container(
      color: ColorConstants.backgroundTextField,
      child: Icon(
        Icons.broken_image_outlined,
        color: Colors.black.withValues(alpha: 0.30),
      ),
    );
  }
}
