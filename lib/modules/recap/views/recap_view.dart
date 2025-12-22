import 'package:sales/shared/utils/size_config.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/recap_controller.dart';

class RecapView extends GetView<RecapController> {
  @override
  Widget build(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    final sh = SizeConfig().screenHeight;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: ColorConstants.black //change your color here
                ),
        title: Text(
          'Rekap',
          style: TextStyle(
            color: ColorConstants.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        elevation: 0,
        backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          // CustomContinuesAppBar(
          //     type: "large", textLabel: "Profile", textSubtitle: "Januari"),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border:
                    Border.all(width: 2.0, color: ColorConstants.borderColor),
                // boxShadow: [
                //   BoxShadow(
                //     color: CommonWidget.setOpacity(Colors.black, 0.3),
                //     blurRadius: 20.0,
                //     spreadRadius: 4.0,
                //     offset: Offset(
                //       -10.0,
                //       10.0,
                //     ),
                //   ),
                // ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Container(
                        color: ColorConstants.blueBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonWidget.subtitleText(text: 'Absen'),
                                  CommonWidget.minHeadText(
                                      text: controller.month.value),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  showMonthPicker(
                                    context: context,
                                    firstDate:
                                        DateTime(DateTime.now().year - 1, 5),
                                    lastDate:
                                        DateTime(DateTime.now().year + 1, 9),
                                    initialDate: controller.selectedDate ??
                                        DateTime.now(),
                                  ).then((date) {
                                    if (date != null) {
                                      controller.selectedDate = date;
                                      controller.month.value =
                                          DateFormat("MMMM yyyy", "id_ID")
                                              .format(date)
                                              .toString();
                                      controller.getData();
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: ColorConstants.mainColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2.0, color: ColorConstants.borderColor),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: CommonWidget.setOpacity(
                                    //         Colors.black, 0.3),
                                    //     blurRadius: 20.0,
                                    //     spreadRadius: 4.0,
                                    //     offset: Offset(
                                    //       -10.0,
                                    //       10.0,
                                    //     ),
                                    //   ),
                                    // ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.calendar_today_rounded,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                    color:
                        CommonWidget.setOpacity(ColorConstants.secondaryAppColor, 0.25),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: sw * .13,
                                child: CommonWidget.minSubtitleText(
                                    text: 'Hari', fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: sw * .01,
                            ),
                            Container(
                                width: sw * .2,
                                child: CommonWidget.minSubtitleText(
                                    text: 'Tanggal',
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: sw * .01,
                            ),
                            Container(
                                width: sw * .12,
                                child: CommonWidget.minSubtitleText(
                                    text: 'Masuk',
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: sw * .01,
                            ),
                            Container(
                                width: sw * .13,
                                child: CommonWidget.minSubtitleText(
                                    text: 'Pulang',
                                    fontWeight: FontWeight.bold)),
                            // SizedBox(
                            //   width: sw * .01,
                            // ),
                            // Container(
                            //     width: sw * .13,
                            //     child: CommonWidget.minSubtitleText(
                            //         text: 'Terlambat',
                            //         fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: sw * .01,
                            )
                            // Container(
                            //     width: sw * .12,
                            //     child: CommonWidget.minSubtitleText(
                            //         text: 'Durasi',
                            //         fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Obx(() => Container(
                        height: sh * .70,
                        child: ListView.builder(
                            itemCount: controller.historyData.length,
                            itemBuilder: (context, i) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 5.0,
                                      left: 10.0,
                                      right: 10.0,
                                      top: 5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: sw * .13,
                                            child: CommonWidget.minSubtitleText(
                                                text:
                                                    DateFormat("EEEE", "id_ID")
                                                        .format(controller
                                                                .historyData[i]
                                                                .tanggal ??
                                                            DateTime.now())
                                                        .toString()),
                                          ),
                                          SizedBox(
                                            width: sw * .01,
                                          ),
                                          Container(
                                            width: sw * .2,
                                            child: CommonWidget.minSubtitleText(
                                                text: DateFormat(
                                                        "dd/MM/yyyy", "id_ID")
                                                    .format(controller
                                                            .historyData[i]
                                                            .tanggal ??
                                                        DateTime.now())
                                                    .toString()),
                                          ),
                                          SizedBox(
                                            width: sw * .01,
                                          ),
                                          Container(
                                            width: sw * .12,
                                            child: CommonWidget.minSubtitleText(
                                                text: controller.historyData[i]
                                                            .absenIn ==
                                                        null
                                                    ? "--:--"
                                                    : controller
                                                        .historyData[i].absenIn
                                                        .toString()),
                                          ),
                                          SizedBox(
                                            width: sw * .01,
                                          ),
                                          Container(
                                            width: sw * .12,
                                            child: CommonWidget.minSubtitleText(
                                                text: controller.historyData[i]
                                                            .absenOut ==
                                                        null
                                                    ? "--:--"
                                                    : controller
                                                        .historyData[i].absenOut
                                                        .toString()),
                                          ),
                                          SizedBox(
                                            width: sw * .01,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: sw * .02,
                                      ),
                                      Divider(
                                        color: ColorConstants.borderColor,
                                      ),
                                    ],
                                  ),
                                )),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
