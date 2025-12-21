import 'package:sales/modules/store/controllers/result_kunjungan_controller.dart';
import 'package:sales/shared/constants/constants.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ResultKunjunganView extends GetView<ResultKunjunganController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: ColorConstants.black //change your color here
                  ),
          centerTitle: false,
          title: Text(
            'Hasil Kunjungan',
            style: TextStyle(
              color: ColorConstants.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              fontFamily: 'Poppins',
            ),
          ),
          backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
          elevation: 0.0,
        ),
        body: Obx(() => _getItems(controller)));
  }

  SmartRefresher _getItems(ResultKunjunganController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: controller.listStore.length,
        itemBuilder: (context, i) => Column(
          children: [
            i == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _cardMenu("Hari Ini", () {}, ColorConstants.secondaryAppColor),
                          _cardMenu("Minggu Ini", () {}, Colors.grey),
                          _cardMenu("Bulan Ini", () {}, Colors.grey),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      summaryCard(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Row(
                          children: [
                            CommonWidget.subtitleText(
                                text: 'Jadwal ', color: ColorConstants.black),
                            CommonWidget.minHeadText(
                                text: 'Kunjungan', color: ColorConstants.black),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            customKunjungankExpandedCard(
              name: controller.listStore[i].namaToko ?? '',
              photo: controller.listStore[i].pathToko ?? '',
              type: '',
              address: controller.listStore[i].alamatToko ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardMenu(String title, onPressed, Color colorCircle) {
    return Container(
      decoration: BoxDecoration(
        color: CommonWidget.setOpacity(colorCircle, 0.9),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
      ),
      width: SizeConfig().screenWidth * .24,
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: CommonWidget.subtitleText(
                text: title.toUpperCase(),
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget summaryCard() {
    final sh = SizeConfig().screenHeight;
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      height: sh * .18,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            headerTextSummary('Total Kunjungan', '0', Colors.grey),
            Divider(
              color: ColorConstants.backgroundTextField,
            ),
            textSummary('Berhasil', '0', Colors.green),
            textSummary('Gagal', '0', Colors.orange),
            textSummary('Tidak Dikunjungi', '0', Colors.red)
          ],
        ),
      ),
    );
  }

  Widget headerTextSummary(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.data_usage,
              color: color,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            CommonWidget.subtitleText(
                text: title,
                fontWeight: FontWeight.bold,
                color: ColorConstants.mainColor),
          ],
        ),
        CommonWidget.minHeadText(text: value, color: ColorConstants.mainColor),
      ],
    );
  }

  Widget textSummary(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.circle,
              color: color,
              size: 10,
            ),
            SizedBox(
              width: 10,
            ),
            CommonWidget.subtitleText(
                text: title, color: ColorConstants.mainColor),
          ],
        ),
        CommonWidget.minHeadText(text: value, color: ColorConstants.mainColor),
      ],
    );
  }

  Widget customKunjungankExpandedCard({
    String photo = '',
    String name = '',
    String type = '',
    String address = '',
    VoidCallback? onPressed,
  }) {
    final sh = SizeConfig().screenHeight;
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      height: name == '' ? sh * .10 : sh * .11,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  photo == ''
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.red,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.store_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )
                      : Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.black,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage(
                                photo,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.minHeadText(text: name),
                      // CommonWidget.subtitleText(text: type),
                      Row(
                        children: [
                          CommonWidget.subtitleText(text: 'alamat : '),
                          CommonWidget.subtitleText(
                              text: address,
                              // fontWeight: FontWeight.bold,
                              color: ColorConstants.mainColor),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 3.0, top: 3, right: 5, left: 5),
                      child: CommonWidget.captionMultilineText(
                          text: 'Belum dikunjungi',
                          color: Colors.white,
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
