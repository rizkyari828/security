import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/utils/size_config.dart';
import 'package:sales/shared/widgets/button.dart';

class FaceRecognitionWiget {
  static Widget faceCameraRecognizer(controller, String status) {
    return Builder(builder: (context) {
      final sw = SizeConfig().screenWidth;
      return Obx(() => controller.faceCameraCapture?.value.path != ''
          ? Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.file(
                    controller.faceCameraCapture?.value ?? File(''),
                    width: double.maxFinite,
                    fit: BoxFit.fitWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        buttonColor: ColorConstants.white,
                        buttonTextColor: ColorConstants.black,
                        buttonText: 'BATALKAN',
                        width: sw * .4,
                        onPressed: () async {
                          await controller.faceCameraController
                              .startImageStream();
                          controller.faceCameraCapture?.value = File('');
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      CustomButton(
                        buttonColor: ColorConstants.white,
                        buttonTextColor: ColorConstants.black,
                        buttonText: 'SIMPAN',
                        width: sw * .4,
                        onPressed: () async {
                          // final face = controller
                          //     .lastDetectedFace; // getter di controller

                          // if (face == null) {
                          //   Get.snackbar('Gagal', 'Wajah tidak terdeteksi');
                          //   return;
                          // }
                          // if (!(face.wellPositioned)) {
                          //   Get.snackbar('Gagal', 'Posisi wajah belum benar');
                          //   return;
                          // }

                          await controller.faceCameraController
                              .startImageStream();
                          if (status.toLowerCase() == 'clock out') {
                            controller.submitOut(status);
                          } else {
                            controller.submit(status);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          : SmartFaceCamera(
              autoDisableCaptureControl: false,
              controller: controller.faceCameraController,
              showCameraLensControl: false,
              messageBuilder: (context, face) {
                if (face == null) {
                  return _message('Absensi (Face Detected)\nTempatkan wajah Anda di kamera');
                }
                if (!face.wellPositioned) {
                  return _message('Absensi (Face Detected)\nTempatkan wajah Anda di kotak');
                }
                return const SizedBox.shrink();
              }));
    });
  }

  static Widget _message(String msg) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 55),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          // Stroked text as border.
          Text(
            msg,
            style: TextStyle(
              fontSize: 16,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = Colors.black,
            ),
          ),
          // Solid text as fill.
          Text(
            msg,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[300],
            ),
          ),
        ],
      ));
}
