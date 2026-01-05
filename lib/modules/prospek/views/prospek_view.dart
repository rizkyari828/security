import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:staffku/modules/prospek/controllers/prospek_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/custom_card.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/shared/widgets/input_field.dart';

import '../../../shared/utils/common_widget.dart';

class ProspekView extends GetView<ProspekController> {
  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstants.black, //change your color here
        ),
        centerTitle: false,
        title: Text(
          'List Prospek',
          style: TextStyle(
            color: ColorConstants.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          Obx(
            () => controller.type.value == "now"
                ? IconButton(
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 1, 5),
                        lastDate: DateTime(DateTime.now().year + 1, 9),
                        initialDate: controller.selectedDate ?? DateTime.now(),
                      ).then((date) {
                        if (date != null) {
                          controller.listProspek.clear();
                          controller.selectedDate = date;
                          controller.monthV.value = DateFormat(
                            "MMMM yyyy",
                            "id_ID",
                          ).format(date).toString();
                          controller.getProspek(1);
                        }
                      });
                    },
                    tooltip: 'Pilih Bulan',
                    icon: Icon(Icons.calendar_month_rounded, size: 20),
                  )
                : Container(),
          ),
          Obx(
            () => controller.type.value == "now"
                ? ApprovalFlow.addButtonApproval(
                    controller: controller,
                    onPressed: controller.goToAddPages,
                  )
                : Container(),
          ),
          // IconButton(
          //   onPressed: controller.goToAddPages,
          //   tooltip: 'Tambah',
          //   icon: Icon(Icons.add_box_rounded, size: 20),
          // )
        ],
      ),
      body: Obx(() => _getItems(controller)),
    );
  }

  SmartRefresher _getItems(ProspekController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: controller.listProspek.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CommonWidget.minHeadText(
                    text: controller.monthLabel.value,
                    color: ColorConstants.black,
                  ),
                  SizedBox(height: 20.0),
                  controller.type.value == "now"
                      ? CustomDropDownSearch(
                          listItem: controller.listStatusOrder.map((item) {
                            return item.namaCat.toString();
                          }).toList(),
                          labelText: "Filter Status",
                          onChanged: (value) async {
                            if (value == "All") {
                              controller.status.value = "";
                              controller.listProspek.clear();
                              controller.getProspek(1);
                            } else {
                              // controller.nameItem.value = value;
                              for (var f in controller.listStatusOrder) {
                                if (f.namaCat == value) {
                                  controller.status.value = f.id.toString();
                                  controller.listProspek.clear();
                                  controller.getProspek(1);
                                }
                              }
                            }
                          },
                        )
                      : Container(),
                ],
              ),
            )
          : ListView.builder(
              itemCount: controller.listProspek.length,
              itemBuilder: (context, i) => Column(
                children: [
                  i == 0
                      ? Obx(
                          () => Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                CommonWidget.minHeadText(
                                  text: controller.monthLabel.value,
                                  color: ColorConstants.black,
                                ),
                                controller.type.value == "now"
                                    ? Column(
                                        children: [
                                          SizedBox(height: 20.0),
                                          CustomDropDownSearch(
                                            listItem: controller.listStatusOrder
                                                .map((item) {
                                                  return item.namaCat
                                                      .toString();
                                                })
                                                .toList(),
                                            labelText: "Filter Status",
                                            onChanged: (value) async {
                                              // controller.nameItem.value = value;
                                              for (var f
                                                  in controller
                                                      .listStatusOrder) {
                                                if (f.namaCat == value) {
                                                  controller.status.value = f.id
                                                      .toString();
                                                  controller.listProspek
                                                      .clear();
                                                  controller.getProspek(1);
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  InkWell(
                    onTap: () {
                      if (controller.groupId.value == "1") {
                        controller.goToDetailPages(
                          id: controller.listProspek[i].noTrans.toString(),
                        );
                      }
                    },
                    child: CustomExpandedCardView(
                      firstParagraf: controller.listProspek[i].noTrans
                          .toString(),
                      secondParagrafLabel: "Nickname",
                      secondParagrafValue: controller.listProspek[i].nama
                          .toString(),
                      thirdParagrafLabel: "Pengajuan",
                      thirdParagrafValue:
                          '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.listProspek[i].cdate ?? DateTime.now())}',
                      // forthParagraf: controller.listOvertime[i].branchName.toString(),
                      approval: controller.listProspek[i].status.toString(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
