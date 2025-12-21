import 'package:sales/modules/store/controllers/store_list_controller.dart';
import 'package:sales/shared/constants/constants.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sales/shared/widgets/approval.dart';
import 'package:sales/shared/widgets/custom_appbar.dart';

class StoreView extends GetView<StoreListController> {
  @override
  Widget build(BuildContext context) {
    double scaleWidth = MediaQuery.of(context).size.width / 360;
    return Obx(() => Scaffold(
        appBar: CustomAppBarWithNetwork(
          title: 'Kunjungan',
          networkStatus: controller.qualityNetwork,
          addButton: ApprovalFlow.addButtonApproval(
              controller: controller, onPressed: controller.goToAddPages),
        ),
        floatingActionButton: controller.isConnectedToInternetWidget.value
            ? Padding(
                padding: EdgeInsets.only(left: scaleWidth * 30),
                child: controller.internetConnection(),
              )
            : SizedBox(),
        body: _getItems(controller)));
  }

  SmartRefresher _getItems(StoreListController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
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
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => pendingTask(
                                  '${controller.dailyProgressCount.value}',
                                  'Kunjungan hari ini',
                                )),
                          ),
                          Expanded(
                            child: Obx(() => pendingTask(
                                  '${controller.montlyProgressCount.value}',
                                  'Kunjungan bulan ini',
                                )),
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, bottom: 10, top: 10),
                        child: Divider(
                          color: ColorConstants.borderColor,
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            InkWell(
              onTap: () {
                controller.goToDetailPages(
                    id: controller.listStore[i].tokoId.toString(),
                    type: controller.listStore[i].typList.toString(),
                    storeName: controller.listStore[i].namaToko ?? '',
                    statusKunjungan:
                        controller.listStore[i].statusKunjungan ?? '');
              },
              child: customStockExpandedCard(
                  name: controller.listStore[i].namaToko ?? '',
                  photo: controller.listStore[i].pathToko ?? '',
                  type: controller.listStore[i].typList == '1'
                      ? 'Kunjungan Terjadwal'
                      : 'Kunjungan Tidak Terjadwal',
                  address: controller.listStore[i].alamatToko ?? '',
                  statusKunjungan:
                      controller.listStore[i].statusKunjungan ?? ''),
            ),
          ],
        ),
      ),
    );
  }

  Widget pendingTask(String value, String title) {
    // Pilih icon sesuai jenis kunjungan
    IconData iconData;
    Color iconColor;
    if (title.toLowerCase().contains('bulan')) {
      iconData = Icons.calendar_month;
      iconColor = Colors.deepPurple;
    } else {
      iconData = Icons.assignment_turned_in;
      iconColor = ColorConstants.secondaryAppColor;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 10, top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: iconColor.withAlpha((0.2 * 255).toInt()),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 2.0, color: ColorConstants.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: SizeConfig().screenWidth * .05,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonWidget.minHeadText(text: value, color: Colors.black),
                  CommonWidget.subtitleText(
                      text: ' $title', color: Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customStockExpandedCard({
    String photo = '',
    String name = '',
    String type = '',
    String address = '',
    String statusKunjungan = '',
    VoidCallback? onPressed,
  }) {
    final sh = SizeConfig().screenHeight;
    final sw = SizeConfig().screenWidth;
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      height: name == '' ? sh * .15 : sh * .16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        photo == ''
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.red,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.store_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              )
                            : Container(
                                height: 70,
                                width: 70,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   color: ColorConstants.secondaryAppColor,
                                 ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    photo,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(Icons.store_rounded,
                                            color: Colors.white, size: 65),
                                      );
                                    },
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
                            Container(
                              child: CommonWidget.subtitleText(
                                  text: name, fontWeight: FontWeight.bold),
                            ),
                            // CommonWidget.subtitleText(text: type),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: SizeConfig().screenWidth * .50,
                              child: CommonWidget.subtitleText(
                                  text: 'Alamat : ' + address,
                                  // fontWeight: FontWeight.bold,
                                  color: ColorConstants.mainColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CommonWidget.subtitleText(
                                text: type,
                                // fontWeight: FontWeight.bold,
                                color: ColorConstants.mainColor),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      width: sw * .85,
                      decoration: BoxDecoration(
                        color: statusKunjungan == '1'
                            ? Colors.green[100]
                            : Colors.yellow[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            statusKunjungan == '1'
                                ? Icons.check_circle
                                : Icons.warning_amber_rounded,
                            color: statusKunjungan == '1'
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          CommonWidget.captionText(
                            text: statusKunjungan == '1'
                                ? 'Sudah dikunjungi'
                                : 'Belum dikunjungi',
                            color: ColorConstants.mainColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
