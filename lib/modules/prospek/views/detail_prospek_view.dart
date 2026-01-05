import 'package:staffku/modules/prospek/controllers/prospek_detail_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProspekDetailView extends GetView<ProspekDetailController> {
  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Prospek'),
      body: SingleChildScrollView(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                stepsIcon(controller.detail.value.status),
                SizedBox(height: 20.0),
                ApprovalFlow.statusApprovalProspect(controller.status),
                SizedBox(height: 20.0),
                CommonWidget.bodyText(
                  text: 'Data Pribadi',
                  color: ColorConstants.black,
                ),
                SizedBox(height: 10.0),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.nicknameController,
                  isDisabled: true,
                  labelText: "Nickname",
                ),
                SizedBox(height: 10.0),
                // CustomDropDownSearch(
                //   enabled: controller.enabled.value,
                //   selectedItem: controller.source.value,
                //   listItem: controller.listSourceOfOrder.map((item) {
                //     return item.nama;
                //   }).toList(),
                //   labelText: "Source of Order",
                //   onChanged: (value) async {
                //     controller.source.value = value;
                //   },
                // ),
                InputInputField(
                  keyboardType: TextInputType.text,
                  controller: controller.sourceController,
                  isDisabled: true,
                  labelText: "Source of Order",
                ),
                SizedBox(height: 10.0),
                CommonWidget.bodyText(text: "Keterangan"),
                SizedBox(height: 10.0),
                TextAreaField(
                  controller: controller.keterangan,
                  isDisabled: true,
                ),
                SizedBox(height: 20.0),
                CommonWidget.bodyText(
                  text: 'Data Prospek',
                  color: ColorConstants.black,
                ),
                SizedBox(height: 20.0),
                CustomDropDownSearch(
                  enabled: controller.enabled.value,
                  selectedItem: controller.actionStatus.value,
                  listItem: controller.listAction.map((item) {
                    return item.name.toString();
                  }).toList(),
                  labelText: "Status",
                  onChanged: (value) async {
                    controller.actionStatus.value = value;
                    controller.changeStatus();
                  },
                ),
                SizedBox(height: 20.0),
                Column(
                  children: [
                    controller.actionStatus.value == 'Cancle'
                        ? CustomDropDownSearch(
                            enabled: controller.enabled.value,
                            selectedItem: controller.reason.value,
                            listItem: controller.listReasonCancle.map((item) {
                              return item.nama.toString();
                            }).toList(),
                            labelText: "Action",
                            onChanged: (value) async {
                              controller.reason.value = value;
                            },
                          )
                        : controller.actionStatus.value == 'Reject'
                        ? CustomDropDownSearch(
                            enabled: controller.enabled.value,
                            selectedItem: controller.reason.value,
                            listItem: controller.listReasonReject.map((item) {
                              return item.nama.toString();
                            }).toList(),
                            labelText: "Action",
                            onChanged: (value) async {
                              controller.reason.value = value;
                            },
                          )
                        : controller.actionStatus.value == 'Accepted'
                        ? Column(
                            children: [
                              CustomDropDownSearch(
                                enabled: controller.enabled.value,
                                selectedItem: controller.reason.value,
                                listItem: controller.listActivity.map((item) {
                                  return item.nama.toString();
                                }).toList(),
                                labelText: "Action",
                                onChanged: (value) async {
                                  controller.reason.value = value;
                                },
                              ),
                              SizedBox(height: 20.0),
                              controller.status.value == 'Order'
                                  ? CustomDropDownSearch(
                                      selectedItem:
                                          controller.typeController.text,
                                      listItem: controller.listType.map((item) {
                                        return item.name.toString();
                                      }).toList(),
                                      labelText: "Type",
                                      onChanged: (value) async {
                                        controller.typeController.text = value;
                                      },
                                    )
                                  : Container(),
                              controller.status.value == 'Order'
                                  ? SizedBox(height: 20.0)
                                  : Container(),
                            ],
                          )
                        : Container(),
                  ],
                ),
                // controller.status.value == 'Order'
                //     ? Column(
                //         children: [
                //           CustomDropDownSearch(
                //             selectedItem: controller.actualTimeController.text,
                //             listItem: controller.arrayFive.map((item) {
                //               return item.toString();
                //             }).toList(),
                //             labelText: "Bisnis Unit",
                //             onChanged: (value) async {
                //               controller.actualTimeController.text = value;
                //             },
                //           ),
                //           SizedBox(height: 20.0),
                //         ],
                //       )
                //     : Container(),
                // controller.status.value == 'Order'
                //     ? Column(
                //         children: [
                //           CustomDropDownSearch(
                //             selectedItem: controller.actualTimeController.text,
                //             listItem: controller.arrayFive.map((item) {
                //               return item.toString();
                //             }).toList(),
                //             labelText: "Nominal",
                //             onChanged: (value) async {
                //               controller.actualTimeController.text = value;
                //             },
                //           ),
                //           SizedBox(height: 20.0),
                //         ],
                //       )
                //     : Container(),
                controller.status.value == 'Booking' &&
                        controller.vehicleType.text != ''
                    ? InputInputField(
                        keyboardType: TextInputType.text,
                        controller: controller.vehicleType,
                        isDisabled: true,
                        labelText: "Tipe",
                      )
                    : Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.bodyText(text: "Reason"),
                    SizedBox(height: 10.0),
                    TextAreaField(
                      isDisabled: controller.disabled.value,
                      controller: controller.noteController,
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),

                SizedBox(height: 20.0),
                controller.disabled.value
                    ? Container()
                    : CustomButton(
                        buttonText: 'SIMPAN',
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {
                          controller.approval();
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stepsIcon(status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        step(status == '1' ? true : false, 'Prospek', Icons.handshake_rounded),
        divLine(),
        step(status == '2' ? true : false, 'Order', Icons.playlist_add_circle),
        divLine(),
        Divider(color: Colors.black),
        step(
          status == '3' ? true : false,
          'Booking',
          Icons.playlist_add_check_circle,
        ),
      ],
    );
  }

  Widget divLine() {
    final sw = SizeConfig().screenWidth;
    return Padding(
      padding: EdgeInsets.only(left: sw * .01, right: sw * .01),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.grey,
        ),
        width: sw * .09,
        height: sw * .02,
      ),
    );
  }

  Widget step(bool active, String status, IconData icon) {
    final sw = SizeConfig().screenWidth;
    return Container(
      height: active ? sw * .23 : sw * .21,
      width: active ? sw * .23 : sw * .21,
      decoration: BoxDecoration(
        color: active ? ColorConstants.mainColor : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
        // boxShadow: [
        //   active
        //       ? BoxShadow(
        //           color: CommonWidget.setOpacity(Colors.black, 0.3),
        //           blurRadius: 20.0,
        //           spreadRadius: 4.0,
        //           offset: Offset(
        //             -10.0,
        //             10.0,
        //           ),
        //         )
        //       : BoxShadow(
        //           color: CommonWidget.setOpacity(Colors.grey, 0.0),
        //         ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: ColorConstants.white, size: active ? 35 : 33),
            CommonWidget.captionText(text: status, color: ColorConstants.white),
          ],
        ),
      ),
    );
  }
}
