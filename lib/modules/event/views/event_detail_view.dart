import 'package:staffku/modules/event/controllers/event_detail_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReliverDetailView extends GetView<ReliverDetailController> {
  final data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Event'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: sw,
                  height: sw * .5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new NetworkImage(
                            controller.detail.value.foto ?? '',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                CommonWidget.minHeadText(
                  text: controller.detail.value.namaEvent ?? '',
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonWidget.labelRowIcon(
                      icon: Icons.place_rounded,
                      widget: CommonWidget.subtitleText(
                        text: controller.detail.value.lokasiAcara ?? '',
                      ),
                    ),
                    CommonWidget.subtitleText(
                      text: controller.detail.value.kotaAcara ?? '',
                    ),
                  ],
                ),
                CommonWidget.labelRowIcon(
                  icon: Icons.access_alarms_rounded,
                  widget: CommonWidget.subtitleText(
                    text:
                        '${DateFormat("MMMM dd, yyyy", "en_EN").format(controller.detail.value.tanggalAcara ?? DateTime.now())}  ${controller.detail.value.jamMulai} - ${controller.detail.value.jamSelesai}',
                  ),
                ),
                SizedBox(height: 10.0),
                CommonWidget.subtitleText(
                  textAlign: TextAlign.justify,
                  text: controller.detail.value.keterangan ?? '',
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
