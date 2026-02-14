import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/models/response/user/users_response.dart';
import 'package:staffku/modules/home/home.dart';
import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/utils/network_checker.dart';
import 'package:staffku/shared/utils/size_config.dart';
import 'package:get/get.dart';

class MainTab extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    double scaleWidth = MediaQuery.of(context).size.width / 360;
    controller.context = context;
    // controller.showMoodDialogOncePerDay(context);
    return Obx(
      () => Scaffold(
        floatingActionButton: controller.isConnectedToInternetWidget.value
            ? Padding(
                padding: EdgeInsets.only(left: scaleWidth * 30),
                child: controller.internetConnection(),
              )
            : SizedBox(),
        backgroundColor: ColorConstants.lightGray,
        body: controller.tipeUser.value == '1'
            ? _buildGridView(scaleWidth, context, controller)
            : _getItems(controller, context),
      ),
    );
  }

  Widget _buildGridView(scaleWidth, context, HomeController controller) {
    final sw = SizeConfig().screenWidth;
    final menus = controller.visibleMenus;
    final cardsPerRow = _quickActionColumns(menus.length, sw);
    final contentWidth = sw * 0.92; // karena container margin kiri/kanan = 4%
    final spacing = (contentWidth * 0.022).clamp(8.0, 10.0);
    final tileWidth =
        (contentWidth - (spacing * (cardsPerRow - 1))) / cardsPerRow;

    final quickActionsGrid = Wrap(
      alignment: WrapAlignment.center,
      spacing: spacing,
      runSpacing: spacing,
      children: menus
          .map(
            (menu) => _cardMenu(
              menu['icon'],
              menu['title'],
              menu['onPressed'],
              menu['color'],
              width: tileWidth,
            ),
          )
          .toList(),
    );

    final showQuickActions =
        controller.homeMenuLoading.value || controller.visibleMenus.isNotEmpty;

    final sh = SizeConfig().screenHeight;
    return SingleChildScrollView(
      child: Stack(
        children: [
          controller.tipeUser.value == "1"
              ? Container(
                  margin: EdgeInsets.only(
                    left: sw * .04,
                    right: sw * .04,
                    top: 0,
                  ),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: _attendanceInfoCard(context),
                      ),
                      if (showQuickActions) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 6.0,
                              bottom: 10.0,
                            ),
                            child: CommonWidget.minHeadText(
                              text: 'Aksi Cepat',
                              color: ColorConstants.black,
                            ),
                          ),
                        ),
                        if (controller.homeMenuLoading.value &&
                            controller.visibleMenus.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else
                          quickActionsGrid,
                      ],
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
                      //     _cardMenu(Icons.store, "Patroli",
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
                          padding: const EdgeInsets.only(
                            bottom: 15.0,
                            left: 10,
                          ),
                          child: CommonWidget.minHeadText(
                            text: 'Ringkasan',
                            color: ColorConstants.black,
                          ),
                        ),
                      ),
                      _securitySummaryRow(),
                      CommonWidget.rowHeight(height: sh * 0.01),
                      // _statusTaskBar(),
                      CommonWidget.rowHeight(),
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                    left: sw * .04,
                    right: sw * .04,
                    top: 0,
                  ),
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
                      quickActionsGrid,
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  int _quickActionColumns(int menuCount, double screenWidth) {
    if (menuCount <= 0) return 1;
    final maxColumns = screenWidth < 350 ? 3 : 4;
    if (menuCount <= maxColumns) return menuCount;
    return maxColumns;
  }

  Widget header(HomeController controller) {
    final sh = SizeConfig().screenHeight;
    final sw = SizeConfig().screenWidth;
    return Container(
      margin: EdgeInsets.only(top: sh / 20),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  SizedBox(width: 10),
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
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
                          color: ColorConstants.black,
                        ),
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
                        width: 2.0,
                        color: ColorConstants.borderColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.notifications,
                        color: ColorConstants.white,
                        size: 27,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3),
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
                NetworkChecker.networkMeter(controller.qualityNetwork),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _securitySummaryRow() {
    final sw = SizeConfig().screenWidth;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _summaryCard(
            title: 'Patroli',
            icon: Icons.shield_rounded,
            color: ColorConstants.mainColor,
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${controller.dailyProgressCount.value}',
                    style: TextStyle(
                      color: ColorConstants.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: 0.2,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  CommonWidget.captionText(
                    text: 'Hari ini',
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${controller.montlyProgressCount.value}',
                    style: TextStyle(
                      color: ColorConstants.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 0.2,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  CommonWidget.captionText(
                    text: 'Bulan ini',
                    color: Colors.grey,
                  ),
                ],
              );
            }),
            onTap: controller.goToPatroliPages,
          ),
        ),
        CommonWidget.rowWidth(width: sw * .03),
        Expanded(
          child: Obx(() {
            final pendingCount = controller.pendingPatroliCount.value;
            final canSend = pendingCount > 0;
            final primaryColor = canSend
                ? ColorConstants.mainColor
                : Colors.grey.withValues(alpha: 0.55);
            return _summaryCard(
              title: 'Pending Upload Patroli',
              icon: Icons.cloud_upload_rounded,
              color: canSend ? Colors.orange : Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$pendingCount',
                    style: TextStyle(
                      color: ColorConstants.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: 0.2,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  CommonWidget.captionText(
                    text: 'data patroli belum terkirim',
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: CommonWidget.setOpacity(
                        primaryColor,
                        0.10,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 1,
                        color: CommonWidget.setOpacity(
                          primaryColor,
                          0.22,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'KIRIM',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.4,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: canSend ? () => controller.submitPendingPatroli() : null,
            );
          }),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 1.0, color: ColorConstants.borderColor),
          boxShadow: [
            BoxShadow(
              color: CommonWidget.setOpacity(Colors.black, 0.06),
              blurRadius: 14.0,
              spreadRadius: 1.0,
              offset: const Offset(0.0, 8.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 0.6,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: CommonWidget.setOpacity(color, 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _cardMenu(
    icon,
    String title,
    onPressed,
    Color colorCircle, {
    double? width,
  }) {
    final isCompact = (width ?? 0) > 0 && (width ?? 0) < 120;
    final iconBgSize = isCompact ? 40.0 : 46.0;
    final iconSize = isCompact ? 20.0 : 23.0;
    final fontSize = isCompact ? 9.6 : 10.8;
    final padding = isCompact ? 7.5 : 8.5;
    const gap = 6.0;
    final minHeight = (padding * 2) + iconBgSize + gap + (fontSize * 2.8);
    final baseHeight = (width ?? 0) > 0
        ? (width! * (isCompact ? 1.08 : 1.14))
        : SizeConfig().screenHeight * .14;
    final height = math.max(baseHeight, minHeight);

    return SizedBox(
      width: width ?? (SizeConfig().screenWidth * .20),
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(width: 1.0, color: ColorConstants.borderColor),
          boxShadow: [
            BoxShadow(
              color: CommonWidget.setOpacity(Colors.black, 0.06),
              blurRadius: 14.0,
              spreadRadius: 1.0,
              offset: const Offset(0.0, 8.0),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.0),
          onTap: () {
            onPressed();
          },
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: iconBgSize,
                        height: iconBgSize,
                        decoration: BoxDecoration(
                          color: CommonWidget.setOpacity(colorCircle, 0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Icon(icon, color: colorCircle, size: iconSize),
                    ],
                  ),
                  SizedBox(height: gap),
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorCircle,
                      fontWeight: FontWeight.w800,
                      fontSize: fontSize,
                      letterSpacing: isCompact ? 0.2 : 0.4,
                      fontFamily: 'Poppins',
                    ),
                  ),
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

  Widget _attendanceInfoCard(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Obx(() {
      final isLoading = controller.attendanceInfoLoading.value;
      final lateMinutes = controller.attendanceLateMinutes;
      final hasSchedule = controller.attendanceSchedule.value != null;
      final checkInDone = controller.attendanceCheckInLabel != '--:--';
      final checkOutDone = controller.attendanceCheckOutLabel != '--:--';
      final statusColor = !hasSchedule
          ? Colors.grey
          : (lateMinutes ?? 0) > 0
          ? Colors.red
          : (checkInDone && checkOutDone)
          ? Colors.green
          : ColorConstants.mainColor;
      final String ctaText = !hasSchedule
          ? 'Lihat Kehadiran'
          : !checkInDone
          ? 'Absen Masuk'
          : !checkOutDone
          ? 'Absen Pulang'
          : 'Lihat Kehadiran';
      final IconData ctaIcon = !hasSchedule
          ? Icons.calendar_today_rounded
          : !checkInDone
          ? Icons.login_rounded
          : !checkOutDone
          ? Icons.logout_rounded
          : Icons.arrow_forward_rounded;

      final shiftLabelRaw = controller.attendanceShiftLabel;
      final hasShiftTime = shiftLabelRaw != '--:-- - --:--';
      final inOfficeArea = controller.attendanceInOfficeArea.value;
      final distanceText = controller.attendanceDistanceToOffice.value.trim();
      final areaLabel = inOfficeArea
          ? 'Di area absensi'
          : 'Di luar area absensi';
      final shiftLabel = hasShiftTime
          ? shiftLabelRaw
          : (distanceText.isNotEmpty
                ? '$areaLabel ($distanceText)'
                : areaLabel);

      final checkInColor = hasSchedule ? Colors.green : Colors.grey;
      final checkOutColor = hasSchedule
          ? ColorConstants.mainColor
          : Colors.grey;
      final lateColor = !hasSchedule
          ? Colors.grey
          : (lateMinutes ?? 0) > 0
          ? Colors.red
          : Colors.green;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: controller.goToAbsensiPages,
          child: Container(
            width: sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
              border: Border.all(width: 1.0, color: ColorConstants.borderColor),
              boxShadow: [
                BoxShadow(
                  color: CommonWidget.setOpacity(Colors.black, 0.08),
                  blurRadius: 18.0,
                  spreadRadius: 2.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 6,
                        color: ColorConstants.mainColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: isLoading
                      ? SizedBox(
                          height: 110,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ColorConstants.mainColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              CommonWidget.subtitleText(
                                text: 'Memuat data kehadiran...',
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonWidget.captionText(
                                        text: 'Kehadiran',
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        controller.attendanceDateLabel,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: ColorConstants.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                          letterSpacing: 0.2,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: sw * 0.46,
                                  ),
                                  child: _pill(
                                    text: shiftLabel,
                                    color: hasShiftTime
                                        ? ColorConstants.mainColor
                                        : (inOfficeArea
                                              ? Colors.green
                                              : Colors.grey),
                                    icon: hasShiftTime
                                        ? Icons.schedule_rounded
                                        : Icons.location_on_rounded,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _refreshButton(
                                  isLoading: isLoading,
                                  onPressed: controller.getAttendanceInfo,
                                ),
                              ],
                            ),
                            if (hasSchedule) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 16,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      controller.attendanceStatusLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        letterSpacing: 0.2,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  if ((lateMinutes ?? 0) > 0) ...[
                                    const SizedBox(width: 8),
                                    _pill(
                                      text: controller.attendanceLateLabel,
                                      color: Colors.red,
                                      icon: Icons.warning_rounded,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(
                                  width: 1.0,
                                  color: ColorConstants.borderColor,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _attendanceMetric(
                                      icon: Icons.check_circle_rounded,
                                      color: checkInColor,
                                      label: 'Check In',
                                      value: controller.attendanceCheckInLabel,
                                      isDone: checkInDone,
                                    ),
                                  ),
                                  _metricDivider(),
                                  Expanded(
                                    child: _attendanceMetric(
                                      icon: Icons.access_time_filled_rounded,
                                      color: checkOutColor,
                                      label: 'Check Out',
                                      value: controller.attendanceCheckOutLabel,
                                      isDone: checkOutDone,
                                    ),
                                  ),
                                  _metricDivider(),
                                  Expanded(
                                    child: _attendanceMetric(
                                      icon: Icons.warning_rounded,
                                      color: lateColor,
                                      label: 'Terlambat',
                                      value: controller.attendanceLateLabel,
                                      isDone: lateMinutes != null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstants.mainColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: controller.goToKehadiranTab,
                                icon: Icon(ctaIcon, size: 18),
                                label: Text(
                                  ctaText.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    letterSpacing: 0.4,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
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
    });
  }

  Widget _pill({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: CommonWidget.setOpacity(color, 0.10),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 1.0,
          color: CommonWidget.setOpacity(color, 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.2,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricDivider() {
    return Container(
      width: 1,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: ColorConstants.borderColor,
    );
  }

  Widget _refreshButton({
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    final enabled = !isLoading;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: enabled ? onPressed : null,
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: CommonWidget.setOpacity(ColorConstants.mainColor, 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              width: 1,
              color: CommonWidget.setOpacity(ColorConstants.mainColor, 0.18),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorConstants.mainColor,
                  ),
                )
              : Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: ColorConstants.mainColor,
                ),
        ),
      ),
    );
  }

  Widget _attendanceMetric({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required bool isDone,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: CommonWidget.setOpacity(color, 0.12),
                shape: BoxShape.circle,
              ),
            ),
            Icon(icon, color: color, size: 22),
          ],
        ),
        const SizedBox(height: 6),
        CommonWidget.captionText(text: label, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isDone ? color : Colors.grey,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 0.2,
            fontFamily: 'Poppins',
          ),
        ),
      ],
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
        itemCount: controller.listPatroli.isEmpty
            ? 1
            : controller.listPatroli.length,
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
                              text: 'Jadwal ',
                              color: ColorConstants.black,
                            ),
                            CommonWidget.minHeadText(
                              text: 'Patroli',
                              color: ColorConstants.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            controller.listPatroli.isEmpty
                ? Column(
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
                            width: 2.0,
                            color: ColorConstants.borderColor,
                          ),
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
                              text: 'Belum ada jadwal patroli',
                              color: ColorConstants.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: () => controller.goToDetailPages(
                      controller.listPatroli[i],
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15.0,
                      ),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 2.0,
                          color: ColorConstants.borderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            controller.listPatroli[i].status == '1'
                                ? Icons.check_circle_rounded
                                : Icons.timelapse,
                            color: controller.listPatroli[i].status == '1'
                                ? Colors.green
                                : Colors.orange,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonWidget.minHeadText(
                                  text:
                                      controller.listPatroli[i].namaJadwal ??
                                      '-',
                                  color: ColorConstants.mainColor,
                                ),
                                const SizedBox(height: 6),
                                CommonWidget.captionText(
                                  text: controller.listPatroli[i].status == '1'
                                      ? 'Sudah patroli'
                                      : 'Belum patroli',
                                  color: ColorConstants.mainColor,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
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
            headerTextSummary('Total Patroli', '0', Colors.grey),
            Divider(color: ColorConstants.backgroundTextField),
            textSummary('Berhasil', '0', Colors.green),
            textSummary('Gagal', '0', Colors.orange),
            textSummary('Tidak Dipatroli', '0', Colors.red),
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
            Icon(Icons.data_usage, color: color, size: 20),
            SizedBox(width: 10),
            CommonWidget.subtitleText(
              text: title,
              fontWeight: FontWeight.bold,
              color: ColorConstants.mainColor,
            ),
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
            Icon(Icons.circle, color: color, size: 10),
            SizedBox(width: 10),
            CommonWidget.subtitleText(
              text: title,
              color: ColorConstants.mainColor,
            ),
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
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
                                        child: Icon(
                                          Icons.store_rounded,
                                          color: Colors.white,
                                          size: 65,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                        SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonWidget.subtitleText(
                              text: name,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: SizeConfig().screenWidth * .50,
                              child: CommonWidget.subtitleText(
                                text: 'Alamat : ' + address,
                                // fontWeight: FontWeight.bold,
                                color: ColorConstants.mainColor,
                              ),
                            ),
                            SizedBox(height: 5),
                            CommonWidget.subtitleText(
                              text: type,
                              // fontWeight: FontWeight.bold,
                              color: ColorConstants.mainColor,
                            ),
                            SizedBox(height: 5),
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
                                  child: Icon(
                                    Icons.store_rounded,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                  SizedBox(width: 20),
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
                          color: ColorConstants.mainColor,
                        ),
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
                        bottom: 3.0,
                        top: 3,
                        right: 5,
                        left: 5,
                      ),
                      child: CommonWidget.captionMultilineText(
                        text: 'Belum dikunjungi',
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  CommonWidget.rowHeight(),
                  Row(
                    children: [
                      CommonWidget.bigText(
                        text:
                            ' ${controller.detailDashboard.value.dailyActualProgress ?? 0} / ${controller.detailDashboard.value.dailyPlanProgress ?? 0}',
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      CommonWidget.subtitleText(
                        text: 'Patroli',
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
                ),
              ),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  CommonWidget.rowHeight(),
                  Row(
                    children: [
                      CommonWidget.bigText(
                        text:
                            ' ${controller.detailDashboard.value.monthlyActualAttendance ?? 0} / ${controller.detailDashboard.value.monthlyPlanAttendance ?? 0}',
                        color: Colors.black,
                      ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pendingTask() {
    final hasInternet = controller.isConnectedToInternet.value;
    final bgColor = hasInternet
        ? Colors.green[100]
        : ColorConstants.yellowBackground;
    final iconColor = hasInternet ? Colors.green : Colors.orange;
    final iconData = hasInternet
        ? Icons.cloud_done_rounded
        : Icons.warning_rounded;
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
                      text: '${controller.pendingAttendanceCount} Data Pending',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
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
        ),
      ),
    );
  }
}
