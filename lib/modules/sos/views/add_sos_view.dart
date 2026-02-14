import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/modules/sos/controllers/sos_form_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/input_field.dart';

class AddSosView extends GetView<SosFormController> {
  const AddSosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Buat Laporan SOS'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoBanner(),
                const SizedBox(height: 16),
                CommonWidget.bodyText(text: 'Keterangan'),
                const SizedBox(height: 10.0),
                TextAreaField(
                  controller: controller.keteranganController,
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onChanged: (_) => controller.markFormDirty(),
                  hintText: 'Contoh: Ada kejadian di area parkir, butuh bantuan segera.',
                  minLines: 4,
                  maxLines: 7,
                ),
                const SizedBox(height: 16.0),
                CommonWidget.bodyText(text: 'Foto'),
                const SizedBox(height: 10.0),
                _photoPicker(),
                const SizedBox(height: 30.0),
                CustomButton(
                  buttonText: 'SIMPAN',
                  width: MediaQuery.of(context).size.width,
                  isDisabled: !controller.canSubmit || controller.isSubmitting.value,
                  onPressed: controller.submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: ColorConstants.blueBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorConstants.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: ColorConstants.mainColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.info_outline_rounded, color: ColorConstants.mainColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Isi keterangan singkat dan unggah foto sebagai bukti, lalu kirim ke server.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.black.withValues(alpha: 0.70),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPicker() {
    final file = controller.selectedPhoto.value;
    final isError = controller.showInputError.value && file == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (file != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 190,
              width: double.infinity,
              color: ColorConstants.backgroundTextField,
              child: kIsWeb
                  ? Image.network(file.path, fit: BoxFit.cover)
                  : Image.file(File(file.path), fit: BoxFit.cover),
            ),
          )
        else
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.backgroundTextField,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isError ? Colors.red : ColorConstants.borderColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera_rounded, color: Colors.black.withValues(alpha: 0.45)),
                const SizedBox(height: 8),
                Text(
                  'Upload foto kejadian',
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
        if (isError)
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
        if (file != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => controller.selectedPhoto.value = null,
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              label: const Text('Hapus foto', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ],
    );
  }
}
