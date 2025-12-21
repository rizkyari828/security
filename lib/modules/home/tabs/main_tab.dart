import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sales/models/response/user/users_response.dart';
import 'package:sales/modules/home/home.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/utils/network_checker.dart';
import 'package:sales/shared/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MainTab extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    double scaleWidth = MediaQuery.of(context).size.width / 360;
    controller.context = context;
    controller.showMoodDialogOncePerDay(context);
    return Obx(() => Scaffold(
        floatingActionButton: controller.isConnectedToInternetWidget.value
            ? Padding(
                padding: EdgeInsets.only(left: scaleWidth * 30),
                child: controller.internetConnection(),
              )
            : SizedBox(),
        backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
        body: controller.tipeUser.value == '1'
            ? _buildGridView(scaleWidth, context, controller)
            : _getItems(controller, context)));
  }

  Widget _buildGridView(scaleWidth, context, HomeController controller) {
    final sw = SizeConfig().screenWidth;
    List<Widget> rows = [];
    final menus = controller.visibleMenus;
    const cardsPerRow = 3;
    final spacing = CommonWidget.rowWidth(width: sw * .03);

    for (int i = 0; i < menus.length; i += cardsPerRow) {
      final rowMenus = menus.skip(i).take(cardsPerRow).toList();

      // Sisipkan spacer di antara card menu
      List<Widget> rowChildren = [];
      for (int j = 0; j < rowMenus.length; j++) {
        rowChildren.add(_cardMenu(
          rowMenus[j]['icon'],
          rowMenus[j]['title'],
          rowMenus[j]['onPressed'],
          rowMenus[j]['color'],
        ));
        // Tambahkan spacer kecuali setelah card terakhir
        if (j != rowMenus.length - 1) {
          rowChildren.add(spacing);
        }
      }

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowChildren,
        ),
      );
      rows.add(CommonWidget.rowHeight());
    }

    final sh = SizeConfig().screenHeight;
    return SingleChildScrollView(
      child: Stack(
        children: [
          controller.tipeUser.value == "1"
              ? Container(
                  margin:
                      EdgeInsets.only(left: sw * .04, right: sw * .04, top: 0),
                  child: Column(
                    children: [
                      CommonWidget.rowHeight(),
                      header(controller),
                      // CommonWidget.rowHeight(),
                      controller.pendingAttendanceCount != 0
                          ? pendingTask()
                          : SizedBox(),
                      // dailyProgress(),
                      // attendanceTask(),
                      // CommonWidget.rowHeight(),
                      Container(
                          height: sh * .26, child: _getSlideImage(controller)),
                      ...rows,
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     _cardMenu(Icons.airplane_ticket_rounded, "Leave",
                      //         controller.goToLeavePages, Colors.blue),
                      //     CommonWidget.rowWidth(width: sw * .03),
                      //     _cardMenu(Icons.handshake_rounded, "Prospek",
                      //         controller.goToProspekDialogPages, Colors.indigo),
                      //   ],
                      // ),
                      // CommonWidget.rowHeight(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     _cardMenu(Icons.edit, "Input",
                      //         controller.goToInputPages, Colors.green),
                      //     CommonWidget.rowWidth(width: sw * .03),
                      //     _cardMenu(Icons.attach_money_rounded, "Benefit",
                      //         controller.goToBenefitPages, Colors.orange),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     _cardMenu(Icons.store, "Kunjungan",
                      //         controller.goToStorePages, Colors.indigo),
                      //     CommonWidget.rowWidth(width: sw * .03),
                      //     _cardMenu(Icons.search_rounded, "Leads",
                      //         controller.goToLeadsPages, Colors.indigo),
                      //     CommonWidget.rowWidth(width: sw * .03),
                      //     _cardMenu(Icons.handshake_rounded, "Prospek",
                      //         controller.goToProspekV2, Colors.indigo),
                      //     CommonWidget.rowWidth(width: sw * .03),
                      //     _cardMenu(Icons.work_rounded, "Agent",
                      //         controller.goToOvertimePages, Colors.indigo),
                      //   ],
                      // ),
                      // CommonWidget.rowHeight(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     _cardMenu(Icons.attach_money_rounded, "Benefit",
                      //         controller.goToBenefitPages, Colors.orange),
                      //     CommonWidget.rowWidth(width: sw * .03),
                      //     _cardMenu(Icons.work_rounded, "Lembur",
                      //         controller.goToOvertimePages, Colors.indigo),
                      //     CommonWidget.rowWidth(width: sw * .03),
                      //     _cardMenu(Icons.airplane_ticket_rounded, "Cuti",
                      //         controller.goToCutiPages, Colors.indigo),
                      //     if (controller.groupId == '1') ...[
                      //       CommonWidget.rowWidth(width: sw * .03),
                      //       _cardMenu(Icons.assignment, "Kuisioner",
                      //           controller.goToKuisionerPages, Colors.indigo),
                      //     ]
                      //   ],
                      // ),
                      CommonWidget.rowHeight(height: sh * 0.01),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 10),
                          child: CommonWidget.minHeadText(
                              text: 'Ringkasan', color: ColorConstants.black),
                        ),
                      ),
                      controller.menuBenefit.value == false
                          ? _eventMenu(context, multipleColumn: false)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _benefitMenu(context),
                                _eventMenu(context),
                              ],
                            ),
                      CommonWidget.rowHeight(height: sh * 0.01),
                      // _statusTaskBar(),
                      CommonWidget.rowHeight(),
                    ],
                  ),
                )
              : Container(
                  margin:
                      EdgeInsets.only(left: sw * .04, right: sw * .04, top: 0),
                  child: Column(
                    children: [
                      CommonWidget.rowHeight(),
                      header(controller),
                      CommonWidget.rowHeight(),
                      controller.pendingAttendanceCount != 0
                          ? pendingTask()
                          : SizedBox(),
                      dailyProgress(),
                      attendanceTask(),
                      CommonWidget.rowHeight(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _cardMenu(Icons.store, "Kunjungan",
                              controller.goToStorePages, Colors.indigo),
                          CommonWidget.rowWidth(width: sw * .03),
                          _cardMenu(Icons.search_rounded, "Leads",
                              controller.goToLeadsPages, Colors.indigo),
                        ],
                      ),
                      CommonWidget.rowHeight(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _cardMenu(Icons.work_rounded, "Lembur",
                              controller.goToOvertimePages, Colors.indigo),
                          CommonWidget.rowWidth(width: sw * .03),
                          _cardMenu(Icons.airplane_ticket_rounded, "Cuti",
                              controller.goToCutiPages, Colors.indigo),
                          if (controller.groupId == '1') ...[
                            CommonWidget.rowWidth(width: sw * .03),
                            _cardMenu(Icons.assignment, "Kuisioner",
                                controller.goToKuisionerPages, Colors.indigo),
                          ]
                        ],
                      ),
                      CommonWidget.rowHeight(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget header(HomeController controller) {
    final sh = SizeConfig().screenHeight;
    final sw = SizeConfig().screenWidth;
    return Container(
      margin: EdgeInsets.only(
        top: sh / 20,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: ColorConstants.mainColor,
                    child: ClipOval(
                      child: Image.network(
                        controller.profilePhoto.value,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                              child: Icon(
                            Icons.person,
                            size: 32,
                            color: ColorConstants.white,
                          ));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: sw / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.name.value,
                          style: TextStyle(
                            color: ColorConstants.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 2, // maksimal 3 baris
                          overflow: TextOverflow
                              .ellipsis, // tambahkan "..." jika teks terlalu panjang
                        ),
                        CommonWidget.subtitleText(
                            text: controller.idPegawai.value,
                            color: ColorConstants.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                    onTap: controller.goToNotificationPages,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorConstants.mainColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            width: 2.0, color: ColorConstants.borderColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.notifications,
                            color: ColorConstants.white, size: 27),
                      ),
                    )),
                SizedBox(
                  width: 3,
                ),
                // controller.tipe.value == "2"
                //     ? InkWell(
                //         onTap: controller.dialogConfirmation,
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: controller.isConnectedToInternet.value
                //                 ? Colors.green
                //                 : Colors.grey,
                //             borderRadius: BorderRadius.circular(10.0),
                //             border: Border.all(
                //                 width: 2.0, color: ColorConstants.borderColor),
                //           ),
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Icon(Icons.sync,
                //                 color: ColorConstants.white, size: 27),
                //           ),
                //         ))
                //     : Container(),
                // SizedBox(
                //   width: 3,
                // ),
                NetworkChecker.networkMeter(
                  controller.qualityNetwork,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefitMenu(context) {
    final sw = SizeConfig().screenWidth;
    return InkWell(
      onTap: () => controller.goToBenefitPages(),
      child: Container(
          width: sw / 2.3,
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 2.0, color: ColorConstants.borderColor),
          ),
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                CommonWidget.bodyText(
                    text: 'Benefit'.toUpperCase(), color: ColorConstants.black),
                CommonWidget.rowHeight(),
                Icon(
                  Icons.attach_money_rounded,
                  size: 50,
                  color: Colors.orange,
                ),
                CommonWidget.rowHeight(),
                CommonWidget.subtitleText(
                    text: (controller.benefitDashboard.value?.nominal
                            .toString() ??
                        "0")),
                CommonWidget.rowHeight(height: 8.0),
                CommonWidget.subtitleText(
                  text:
                      '${DateFormat("MMMM, yyyy", "en_EN").format(DateTime.now())}',
                ),
                CommonWidget.rowHeight(),
              ]))),
    );
  }

  Widget _eventMenu(context, {bool multipleColumn = true}) {
    final sw = SizeConfig().screenWidth;
    return InkWell(
      onTap: () => controller.goToEventPages(),
      child: Container(
          width: !multipleColumn ? sw : sw / 2.3,
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 2.0, color: ColorConstants.borderColor),
          ),
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: multipleColumn == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          CommonWidget.bodyText(
                              text: 'Event'.toUpperCase(),
                              color: ColorConstants.black),
                          CommonWidget.rowHeight(),
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 50,
                            color: Colors.cyan,
                          ),
                          CommonWidget.rowHeight(),
                          CommonWidget.subtitleText(
                              text: controller.benefitDashboard.value?.event ==
                                      ""
                                  ? 'Tidak ada event'
                                  : controller.benefitDashboard.value?.event ??
                                      'Tidak ada event'),
                          CommonWidget.rowHeight(height: 8.0),
                          CommonWidget.subtitleText(
                              text: controller.dateNow.value),
                          CommonWidget.rowHeight(),
                        ])
                  : Column(
                      children: [
                        CommonWidget.bodyText(
                            text: 'Event'.toUpperCase(),
                            color: ColorConstants.black),
                        // CommonWidget.rowHeight(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    size: 50,
                                    color: Colors.cyan,
                                  ),
                                ],
                              ),
                              CommonWidget.rowWidth(),
                              Column(
                                children: [
                                  CommonWidget.rowHeight(),
                                  CommonWidget.subtitleText(
                                      text: controller.benefitDashboard.value
                                                  ?.event ==
                                              ""
                                          ? 'Tidak ada event'
                                          : controller.benefitDashboard.value
                                                  ?.event ??
                                              'Tidak ada event'),
                                  CommonWidget.rowHeight(height: 8.0),
                                  CommonWidget.subtitleText(
                                      text: controller.dateNow.value),
                                  CommonWidget.rowHeight(),
                                ],
                              ),
                            ]),
                      ],
                    ))),
    );
  }

  Widget _statusTaskBar() {
    return InkWell(
      onTap: () => controller.goToLemburPages(controller.monthInt, "now", '3',
          needBack: false),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 2.0, color: ColorConstants.borderColor),
        ),
        height: SizeConfig().screenHeight / 9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonWidget.rowHeight(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: CommonWidget.bodyText(
                  text: 'Data Booking'.toUpperCase(),
                  color: ColorConstants.black),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: ListTile(
                leading: Container(
                  decoration: new BoxDecoration(
                    color: ColorConstants.mainColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.library_books_rounded,
                      color: Colors.white,
                      size: SizeConfig().screenWidth * .06,
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    CommonWidget.headText(
                        text:
                            "${controller.benefitDashboard.value?.jumlahBoking ?? 0} ",
                        color: ColorConstants.mainColor),
                    CommonWidget.subtitleText(
                        text: "Dari bulan kemarin",
                        color: ColorConstants.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardMenu(icon, String title, onPressed, Color colorCircle) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CommonWidget.setOpacity(ColorConstants.cardColor, 0.9),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 2.0, color: ColorConstants.borderColor),
        ),
        width: SizeConfig().screenWidth * .20,
        height: SizeConfig().screenHeight * .13,
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: new BoxDecoration(
                      color: colorCircle,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: SizeConfig().screenWidth * .06,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig().screenHeight * .01),
                  CommonWidget.subtitleText(
                      text: title.toUpperCase(),
                      color: colorCircle,
                      fontWeight: FontWeight.w500),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Datum>? get data {
    return controller.users.value == null ? [] : controller.users.value!.data;
  }

  Widget _getSlideImage(HomeController controller) {
    final sw = SizeConfig().screenWidth;
    return CarouselSlider(
      options: CarouselOptions(
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        height: 400.0,
        viewportFraction: 1,
      ),
      items: controller.listEvent.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                controller.goToDetailEventPages(
                  id: i.id.toString(),
                );
              },
              child: Container(
                width: sw,
                // margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: sw,
                        height: sw * .5,
                        child: ClipRRect(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2.0,
                                  color: ColorConstants.borderColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.black,
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                // colorFilter: ColorFilter.mode(
                                //     CommonWidget.setOpacity(Colors.black, 0.4),
                                //     BlendMode.dstATop),
                                image: new NetworkImage(
                                  i.foto ?? '',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 40.0, left: 20),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       CommonWidget.bodyText(
                    //           text: i.namaEvent ?? '', color: Colors.white),
                    //       CommonWidget.bodyText(
                    //           text: DateFormat("MMMM dd, yyyy", "en_EN")
                    //               .format(i.tanggalAcara ?? DateTime.now())
                    //               .toString(),
                    //           color: Colors.white),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  SmartRefresher _getItems(HomeController controller, context) {
    double scaleWidth = MediaQuery.of(context).size.width / 360;
    final sh = SizeConfig().screenHeight;
    final sw = SizeConfig().screenWidth;
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGridView(scaleWidth, context, controller),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 15.0, right: 15),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       _cardMenuFilter(
                      //           "Hari Ini", () {}, ColorConstants.mainColor),
                      //       _cardMenuFilter("Minggu Ini", () {}, Colors.grey),
                      //       _cardMenuFilter("Bulan Ini", () {}, Colors.grey),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // summaryCard(),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
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
            controller.listStore[i].tokoId.toString() != "0"
                ? InkWell(
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
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.rowHeight(),
                      Container(
                        padding: const EdgeInsets.all(20),
                        height: sh * .13,
                        width: sw * .92,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              width: 2.0, color: ColorConstants.borderColor),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error,
                              color: ColorConstants.darkGray,
                              size: 40,
                            ),
                            CommonWidget.rowHeight(height: 5),
                            CommonWidget.subtitleText(
                                text: 'Belum ada jadwal kunjungan',
                                color: ColorConstants.black,
                                fontWeight: FontWeight.normal),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _cardMenuFilter(String title, onPressed, Color colorCircle) {
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
                            CommonWidget.subtitleText(
                                text: name, fontWeight: FontWeight.bold),
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
                          height: 35,
                          width: 35,
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
                                      color: Colors.white, size: 25),
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
                      CommonWidget.minHeadText(text: name),
                      // CommonWidget.subtitleText(text: type),
                      Container(
                        width: SizeConfig().screenWidth * .50,
                        child: CommonWidget.subtitleText(
                            text: 'Alamat : ' + address,
                            // fontWeight: FontWeight.bold,
                            color: ColorConstants.mainColor),
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

  Widget dailyProgress() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: ColorConstants.blueBackground,
          borderRadius: BorderRadius.circular(10.0),
          // border: Border.all(width: 2.0, color: ColorConstants.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                          color: ColorConstants.mainColor,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.assignment_turned_in,
                            color: Colors.white,
                            size: SizeConfig().screenWidth * .05,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      CommonWidget.subtitlePlusText(
                          text: 'Progress Harian',
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                  CommonWidget.rowHeight(),
                  Row(
                    children: [
                      CommonWidget.bigText(
                          text:
                              ' ${controller.detailDashboard.value.dailyActualProgress ?? 0} / ${controller.detailDashboard.value.dailyPlanProgress ?? 0}',
                          color: Colors.black),
                      SizedBox(width: 10),
                      CommonWidget.subtitleText(
                        text: 'Kunjungan',
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
              CircularPercentIndicator(
                  progressColor: ColorConstants.mainColor,
                  radius: 50.0,
                  lineWidth: 13.0,
                  animation: true,
                  percent: 0.7,
                  center: CommonWidget.subtitleText(
                    text:
                        '${controller.detailDashboard.value.monthlyPercentageAttendance ?? 0}%',
                    color: Colors.black,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget attendanceTask() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: SizeConfig().screenWidth * .05,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      CommonWidget.subtitlePlusText(
                          text: 'Absensi Bulanan',
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                  CommonWidget.rowHeight(),
                  Row(
                    children: [
                      CommonWidget.bigText(
                          text:
                              ' ${controller.detailDashboard.value.monthlyActualAttendance ?? 0} / ${controller.detailDashboard.value.monthlyPlanAttendance ?? 0}',
                          color: Colors.black),
                      SizedBox(width: 10),
                      CommonWidget.subtitleText(
                        text: 'Absensi',
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
              CircularPercentIndicator(
                  progressColor: Colors.green,
                  radius: 50.0,
                  lineWidth: 13.0,
                  animation: true,
                  percent: 0.7,
                  center: CommonWidget.subtitleText(
                    text:
                        '${controller.detailDashboard.value.monthlyPercentageAttendance ?? 0}%',
                    color: Colors.black,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget pendingTask() {
    final hasInternet = controller.isConnectedToInternet.value;
    final bgColor =
        hasInternet ? Colors.green[100] : ColorConstants.yellowBackground;
    final iconColor = hasInternet ? Colors.green : Colors.orange;
    final iconData =
        hasInternet ? Icons.cloud_done_rounded : Icons.warning_rounded;
    final infoText = hasInternet
        ? 'Koneksi internet tersedia, klik untuk kirim data pending.'
        : 'Segera periksa koneksi internet mu dan klik disini untuk mengirim kembali';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: InkWell(
          onTap: () async {
            await controller.submitPendingAttendance();
          },
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        iconData,
                        color: ColorConstants.white,
                        size: SizeConfig().screenWidth * .05,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.minSubtitleText(
                          text:
                              '${controller.pendingAttendanceCount} Data Pending',
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      Container(
                        width: SizeConfig().screenWidth * .70,
                        child: CommonWidget.captionMultilineText(
                          text: infoText,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
