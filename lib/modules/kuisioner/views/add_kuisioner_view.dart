import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/modules/kuisioner/controllers/kuisioner_controller.dart';
import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/utils/custom_pop_scope.dart';
import 'package:staffku/shared/utils/utils.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/custom_appbar.dart';
import 'package:staffku/shared/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/routes/app_pages.dart';

class AddKuisionerView extends GetView<KusionerController> {
  const AddKuisionerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.HOME);
        return false;
      },
      child: Obx(() => _buildWidget(context)),
    );
  }

  Widget _buildWidget(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Scaffold(
      appBar: CustomAppBarWithNetwork(
        title: 'Input Kuisioner',
        networkStatus: controller.qualityNetwork,
      ),
      resizeToAvoidBottomInset: true, // tambahkan ini
      body: Column(
        children: [
          Expanded(child: _getItems(context, controller)),
          Padding(
            padding: EdgeInsets.only(left: sw * .06, right: 20, bottom: 20),
            child: CustomButton(
              buttonText: controller.percentage.value >= 1.0
                  ? 'SIMPAN'
                  : 'SELANJUTNYA',
              width: MediaQuery.of(context).size.width,
              onPressed: () {
                if (controller.percentage.value >= 1.0) {
                  controller.submit(isLast: true);
                } else {
                  controller.submit(isLast: false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getItems(BuildContext context, KusionerController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 0,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 250,
      ),
      child: Column(
        children: [
          ...List.generate(controller.listKuisioner.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
              child: Column(
                children: [
                  if (i == 0)
                    Column(
                      children: [
                        SizedBox(height: 20.0),
                        CommonWidget.progressLiniar(
                          controller.currentProgress.value,
                          controller.allProgress.value,
                          controller.percentage.value,
                          Get.context!,
                        ),
                      ],
                    ),
                  controller.listKuisioner[i].idKategori == 2
                      ? soalEssay(
                          context,
                          controller.currentProgress.value + i + 1,
                          controller.listKuisioner[i].soal ?? '',
                          controller.listKuisioner[i].idSoal ?? 0,
                          controller.listKuisioner[i].idKategori ?? 0,
                          controller.listKuisioner[i].isUpload ?? 0,
                          controller,
                          initialValue:
                              controller.answers[controller
                                      .listKuisioner[i]
                                      .idSoal
                                      ?.toString() ??
                                  ""] ??
                              "",
                        )
                      : SingleChoice(
                          no: controller.currentProgress.value + i + 1,
                          question: controller.listKuisioner[i].soal ?? '',
                          idSoal: controller.listKuisioner[i].idSoal ?? 0,
                          idKategori:
                              controller.listKuisioner[i].idKategori ?? 0,
                          options: [
                            controller.listKuisioner[i].pilihan1 ?? '',
                            controller.listKuisioner[i].pilihan2 ?? '',
                            controller.listKuisioner[i].pilihan3 ?? '',
                            controller.listKuisioner[i].pilihan4 ?? '',
                          ],
                          isUpload: controller.listKuisioner[i].isUpload ?? 0,
                        ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

Widget uploadFile(
  BuildContext context,
  KusionerController controller,
  String idSoal,
) {
  final sw = SizeConfig().screenWidth;
  final imageFiles = controller.imageFileMap[idSoal] ?? [];

  return Column(
    children: [
      SizedBox(height: 10.0),
      Divider(color: ColorConstants.borderColor),
      SizedBox(height: 20.0),
      CommonWidget.minSubtitleText(text: "Silahkan upload disini"),
      SizedBox(height: 10.0),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Obx(() {
          final files = controller.imageFileMap[idSoal] ?? [];
          if (files.isEmpty) return SizedBox();
          return Wrap(
            spacing: 8,
            children: files.map((file) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(
                    File(file.path),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  GestureDetector(
                    onTap: () {
                      files.remove(file);
                      controller.imageFileMap[idSoal] = List<XFile>.from(files);
                      controller.imageFileMap.refresh();
                    },
                    child: Icon(Icons.cancel, color: Colors.red, size: 20),
                  ),
                ],
              );
            }).toList(),
          );
        }),
      ),
      imageFiles.length < 1
          ? InkWell(
              onTap: () async {
                await controller.onImageButtonPressed(
                  ImageSource.camera,
                  context: context,
                  isMultiImage: false,
                  idSoal: idSoal,
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
                      Icon(Icons.camera_alt, color: Colors.grey, size: 30),
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
    ],
  );
}

Widget soalEssay(
  BuildContext context,
  int no,
  String question,
  int idSoal,
  int idKategori,
  int isUpload,
  KusionerController controller, {
  String initialValue = "",
}) {
  final idSoalStr = idSoal.toString();
  if (!controller.essayControllers.containsKey(idSoalStr)) {
    controller.essayControllers[idSoalStr] = TextEditingController(
      text: controller.answers[idSoalStr] ?? "",
    );
  }
  final textController = controller.essayControllers[idSoalStr]!;
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(width: 2.0, color: ColorConstants.borderColor),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.bodyMultilineText(text: "${no}. $question"),
          SizedBox(height: 10.0),
          TextAreaField(
            controller: textController,
            onChanged: (val) {
              controller.setAnswer(idSoalStr, idKategori.toString(), val);
            },
          ),
          SizedBox(height: 20.0),
          if (isUpload == 1) ...[
            uploadFile(context, controller, idSoal.toString()),
          ],
        ],
      ),
    ),
  );
}

class SingleChoice extends GetView<KusionerController> {
  final int no;
  final String question;
  final int idSoal;
  final int idKategori;
  final List<String> options;
  final int isUpload;

  const SingleChoice({
    Key? key,
    required this.no,
    required this.question,
    required this.idSoal,
    required this.idKategori,
    required this.options,
    required this.isUpload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final answer = controller.answers[idSoal.toString()] ?? '';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question != '') ...[
              CommonWidget.bodyMultilineText(text: "${no}. $question"),
              const SizedBox(height: 10),
              // Hanya tampilkan pilihan jika answer masih kosong
              if (answer == '')
                Obx(() {
                  return RadioGroup<String>(
                    groupValue: controller.answers[idSoal.toString()],
                    onChanged: (value) {
                      if (value == null) return;
                      controller.setAnswer(
                        idSoal.toString(),
                        idKategori.toString(),
                        value,
                      );
                    },
                    child: Column(
                      children: options
                          .where((option) => option.trim().isNotEmpty)
                          .map((option) {
                            return RadioListTile<String>(
                              title: CommonWidget.bodyText(text: option),
                              value: option,
                            );
                          })
                          .toList(),
                    ),
                  );
                }),
              // Jika sudah ada jawaban, bisa tampilkan info jawaban atau kosongkan saja
              if (answer != '')
                CommonWidget.bodyText(
                  text: "Jawaban: $answer",
                  color: ColorConstants.mainColor,
                ),
            ],
            if (isUpload == 1) ...[
              uploadFile(context, controller, idSoal.toString()),
            ],
          ],
        ),
      ),
    );
  }
}
