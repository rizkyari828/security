import 'package:staffku/modules/agent/controllers/agent_detail_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/image_picker.dart';

class AgentDetailView extends GetView<AgentDetailController> {
  final data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Agent'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => controller.detail.value.fullName == null
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ColorConstants.mainColor,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.labelExpanded(
                        label: 'Nama Lengkap',
                        value: controller.detail.value.fullName,
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Nama Agent',
                        value: controller.detail.value.email.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Email',
                        value: controller.detail.value.email.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Alamat Lengkap',
                        value: controller.detail.value.alamat.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Wilayah Penempatan',
                        value: controller.detail.value.placement.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Tanggal Bergabung',
                        value: controller.detail.value.joinDate,
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Jenis Agent',
                        value: controller.detail.value.typeAgentId,
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Didaftarkan Oleh',
                        value: controller.detail.value.registerBy.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.bodyText(text: "Status Aktif"),
                      SizedBox(height: 10.0),
                      CommonWidget.bodyText(
                        text: controller.detail.value.alamat ?? '',
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.bodyText(text: "Tanda Tangan"),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Obx(
                          () => CustomImagePicker.previewGridImages(
                            controller.signatureFile,
                          ),
                        ),
                      ),
                      CommonWidget.bodyText(text: "Foto"),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Obx(
                          () => CustomImagePicker.previewGridImages(
                            controller.imageFileList,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      CustomButton(
                        buttonText: 'SIMPAN',
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {
                          // controller.submit();
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
