import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/modules/claim/controllers/claim_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/input_field.dart';

class AddClaimView extends GetView<ClaimController> {
  const AddClaimView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Ajukan Claim'),
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
                    'EEEE, d MMMM yyyy',
                    'id_ID',
                  ).format(DateTime.now()).toString(),
                ),
                const SizedBox(height: 10.0),
                CommonWidget.bodyText(text: 'Nominal Claim'),
                InputInputField(
                  controller: controller.nominalController,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onChanged: controller.markFormDirty,
                ),
                const SizedBox(height: 10.0),
                CommonWidget.bodyText(text: 'Keterangan'),
                const SizedBox(height: 10.0),
                TextAreaField(
                  controller: controller.keteranganController,
                  isRequired: true,
                  showError: controller.showInputError.value,
                  onChanged: (_) => controller.markFormDirty(),
                ),
                const SizedBox(height: 16.0),
                CommonWidget.bodyText(text: 'Bukti (Foto)'),
                const SizedBox(height: 10.0),
                _photoPicker(context),
                if (controller.showInputError.value &&
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
                const SizedBox(height: 30.0),
                CustomButton(
                  buttonText: 'SIMPAN',
                  width: MediaQuery.of(context).size.width,
                  isDisabled:
                      !controller.canSubmit || controller.isSubmitting.value,
                  onPressed: controller.submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoPicker(BuildContext context) {
    final file = controller.selectedPhoto.value;

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
              border: Border.all(color: ColorConstants.borderColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload foto bukti claim',
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
        if (file != null) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => controller.selectedPhoto.value = null,
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              label: const Text(
                'Hapus foto',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
