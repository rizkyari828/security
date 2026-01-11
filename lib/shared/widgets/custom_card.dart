// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/shared.dart';

class CustomCardView extends StatelessWidget {
  final String code;
  final String date;
  final String tipe;
  final String approval;
  final String dateStartEnd;
  final bool updateDelete;
  final VoidCallback? onPressedEdit;
  final VoidCallback? onPressedDelete;

  CustomCardView({
    this.code = '',
    this.date = '',
    this.tipe = '',
    this.approval = '',
    this.dateStartEnd = '',
    this.updateDelete = false,
    this.onPressedEdit,
    this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        // BorderSide(color: ColorConstants.borderColor, width: 1)
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
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
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  code == ''
                      ? SizedBox(height: 0)
                      : CommonWidget.subtitleText(
                          text: code,
                          fontWeight: FontWeight.bold,
                        ),
                  date == ''
                      ? SizedBox(height: 0)
                      : CommonWidget.minSubtitleText(text: date),
                  tipe == ''
                      ? SizedBox(height: 0)
                      : CommonWidget.minSubtitleText(text: tipe),
                  dateStartEnd == ''
                      ? SizedBox(height: 0)
                      : CommonWidget.minSubtitleText(text: dateStartEnd),
                ],
              ),
            ),
            updateDelete
                ? Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.create,
                              color: Colors.orange,
                              size: 30,
                            ),
                            onPressed: onPressedEdit,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.restore_from_trash_rounded,
                              color: Colors.red,
                              size: 30,
                            ),
                            onPressed: onPressedDelete,
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            (approval == "approved")
                                ? Icons.check_circle_outlined
                                : (approval == "pengajuan" ||
                                        approval == "proses")
                                    ? Icons.access_time_outlined
                                    : Icons.close,
                            color: (approval == "approved")
                                ? Colors.green
                                : (approval == "pengajuan" ||
                                        approval == "proses")
                                    ? Colors.orange
                                    : Colors.red,
                            size: 30,
                          ),
                          CommonWidget.captionText(
                            text: approval,
                            color: (approval == "approved")
                                ? Colors.green
                                : (approval == "pengajuan" ||
                                        approval == "proses")
                                    ? Colors.orange
                                    : Colors.red,
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
}

class CustomExpandedCardView extends StatelessWidget {
  final String name;
  final String firstParagraf;
  final String secondParagrafLabel;
  final String secondParagrafValue;
  final String thirdParagrafLabel;
  final String thirdParagrafValue;
  final String forthParagraf;
  final String approval;
  final String levelApproval;
  final bool updateDelete;
  final VoidCallback? onPressedEdit;
  final VoidCallback? onPressedDelete;

  CustomExpandedCardView({
    this.name = '',
    this.firstParagraf = '',
    this.secondParagrafLabel = '',
    this.secondParagrafValue = '',
    this.thirdParagrafLabel = '',
    this.thirdParagrafValue = '',
    this.approval = '',
    this.levelApproval = '',
    this.forthParagraf = '',
    this.updateDelete = false,
    this.onPressedEdit,
    this.onPressedDelete,
  });

  bool _hasText(String value) => value.trim().isNotEmpty;

  IconData? _iconForName(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.contains('@')) return Icons.mail_outline_rounded;

    final looksLikeDate =
        RegExp(r'\\d{4}').hasMatch(trimmed) && trimmed.contains(',');
    if (looksLikeDate) return Icons.calendar_today_outlined;
    return null;
  }

  IconData? _iconForLabel(String label) {
    final lower = label.trim().toLowerCase();
    if (lower.contains('mulai') || lower.contains('awal')) {
      return Icons.calendar_today_outlined;
    }
    if (lower.contains('selesai') || lower.contains('akhir')) {
      return Icons.event_outlined;
    }
    if (lower.contains('tanggal') || lower.contains('date')) {
      return Icons.calendar_month_outlined;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final normalizedApproval = approval.trim().toLowerCase();
    final tone = _ApprovalTone.from(normalizedApproval);

    final titleStyle = const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: ColorConstants.black,
      height: 1.15,
    );

    final subtitleStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: Colors.black.withValues(alpha: 0.68),
      height: 1.2,
    );

    final detailLabelStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.5,
      fontWeight: FontWeight.w600,
      color: Colors.black.withValues(alpha: 0.72),
      height: 1.2,
    );

    final detailValueStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: Colors.black.withValues(alpha: 0.78),
      height: 1.2,
    );

    Widget leadingIcon(IconData icon, {Color? color}) {
      final fg = color ?? Colors.black.withValues(alpha: 0.60);
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: fg),
      );
    }

    Widget infoLine({required String label, required String value}) {
      final trimmedLabel = label.trim();
      final icon = _iconForLabel(trimmedLabel);
      final iconColor = Colors.black.withValues(alpha: 0.55);

      if (trimmedLabel.isEmpty) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              leadingIcon(icon, color: iconColor),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: detailValueStyle,
              ),
            ),
          ],
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            leadingIcon(icon, color: iconColor),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$trimmedLabel: ', style: detailLabelStyle),
                  TextSpan(text: value, style: detailValueStyle),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    Widget headline({
      required String text,
      required TextStyle style,
      IconData? icon,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            leadingIcon(icon),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      );
    }

    Widget pill({
      required String text,
      required Color bg,
      required Color fg,
      IconData? icon,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: fg.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                color: fg,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          width: 1.0,
          color: ColorConstants.borderColor.withValues(alpha: 0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18.0,
            spreadRadius: 0.0,
            offset: const Offset(0.0, 8.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_hasText(firstParagraf))
              headline(
                text: firstParagraf,
                style: titleStyle,
              ),
            if (_hasText(firstParagraf) && _hasText(name))
              const SizedBox(height: 6),
            if (_hasText(name))
              headline(
                text: name,
                style: subtitleStyle,
                icon: _iconForName(name),
              ),
            if (_hasText(secondParagrafValue) ||
                _hasText(thirdParagrafValue) ||
                _hasText(forthParagraf))
              const SizedBox(height: 12),
            if (_hasText(secondParagrafValue))
              infoLine(label: secondParagrafLabel, value: secondParagrafValue),
            if (_hasText(secondParagrafValue) && _hasText(thirdParagrafValue))
              const SizedBox(height: 8),
            if (_hasText(thirdParagrafValue))
              infoLine(label: thirdParagrafLabel, value: thirdParagrafValue),
            if ((_hasText(secondParagrafValue) ||
                    _hasText(thirdParagrafValue)) &&
                _hasText(forthParagraf))
              const SizedBox(height: 8),
            if (_hasText(forthParagraf))
              Text(
                forthParagraf,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: detailValueStyle,
              ),
            if (updateDelete || _hasText(approval))
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: updateDelete
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.create_outlined,
                              color: Colors.orange,
                              size: 22,
                            ),
                            onPressed: onPressedEdit,
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                              size: 22,
                            ),
                            onPressed: onPressedDelete,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          if (_hasText(levelApproval))
                            pill(
                              text: levelApproval.toUpperCase(),
                              bg: Colors.black.withValues(alpha: 0.04),
                              fg: Colors.black.withValues(alpha: 0.62),
                            ),
                          const Spacer(),
                          pill(
                            text: approval.toUpperCase(),
                            bg: tone.bg,
                            fg: tone.fg,
                            icon: tone.icon,
                          ),
                        ],
                      ),
              ),
          ],
        ),
      ),
    );
  }

  //   Widget bottomApproval(String approval, String levelApproval) {
  //     final sw = SizeConfig().screenWidth;
  //     return Column(
  //       children: [
  //         Spacer(),
  //         Container(
  //           width: sw * .85,
  //           decoration: BoxDecoration(
  //             color:
  //                 statusKunjungan == '1' ? Colors.green[100] : Colors.yellow[100],
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           padding: const EdgeInsets.all(5),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(
  //                 statusKunjungan == '1'
  //                     ? Icons.check_circle
  //                     : Icons.warning_amber_rounded,
  //                 color: statusKunjungan == '1' ? Colors.green : Colors.orange,
  //               ),
  //               const SizedBox(width: 10),
  //               CommonWidget.captionText(
  //                 text: statusKunjungan == '1'
  //                     ? 'Sudah dikunjungi'
  //                     : 'Belum dikunjungi',
  //                 color: ColorConstants.mainColor,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     );
  //   }
}

class _ApprovalTone {
  const _ApprovalTone({required this.bg, required this.fg, required this.icon});

  final Color bg;
  final Color fg;
  final IconData icon;

  static _ApprovalTone from(String normalizedApproval) {
    final approval = normalizedApproval.trim();
    final isApproved =
        approval == 'approved' || approval == 'approve' || approval == 'ok';
    final isPending = approval == 'pengajuan' ||
        approval == 'proses' ||
        approval == 'process' ||
        approval == 'waiting' ||
        approval == 'pending' ||
        approval == 'new';

    if (isApproved) {
      return _ApprovalTone(
        bg: const Color(0xFFE7F7EE),
        fg: const Color(0xFF1B7F3B),
        icon: Icons.check_circle_outline_rounded,
      );
    }

    if (isPending) {
      return _ApprovalTone(
        bg: const Color(0xFFFFF3E6),
        fg: const Color(0xFFB54708),
        icon: Icons.access_time_rounded,
      );
    }

    return _ApprovalTone(
      bg: const Color(0xFFFDECEC),
      fg: const Color(0xFFB42318),
      icon: Icons.cancel_outlined,
    );
  }
}

class CustomExpandedImageCardView extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String location;
  final String image;
  final String time;

  CustomExpandedImageCardView({
    this.title = '',
    this.description = '',
    this.date = '',
    this.location = '',
    this.image = '',
    this.time = '',
  });

  @override
  Widget build(BuildContext context) {
    final sw = SizeConfig().screenWidth;
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
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
      child: Row(
        children: [
          Container(
            width: sw * .3,
            height: sw * .3,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage(image),
                  ),
                ),
              ),
            ),
          ),
          CommonWidget.rowWidth(width: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: sw * .5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidget.subtitleText(
                    text: title,
                    fontWeight: FontWeight.bold,
                  ),
                  CommonWidget.labelRowIcon(
                    icon: Icons.access_alarms_rounded,
                    widget: CommonWidget.subtitleText(text: time),
                  ),
                  CommonWidget.labelRowIcon(
                    icon: Icons.place_rounded,
                    widget: CommonWidget.subtitleText(text: description),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: CommonWidget.labelExpanded(
                        label: location,
                        value: date,
                        fontWeight2: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomStockExpandedCardView extends StatelessWidget {
  final String name;
  final String type;
  final String price;
  final String stock;
  final VoidCallback? onPressedAdd;
  final VoidCallback? onPressedRemove;

  CustomStockExpandedCardView({
    this.name = '',
    this.type = '',
    this.price = '',
    this.stock = '',
    this.onPressedAdd,
    this.onPressedRemove,
  });

  @override
  Widget build(BuildContext context) {
    // final sw = SizeConfig().screenWidth;
    final sh = SizeConfig().screenHeight;
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      height: name == '' ? sh * .15 : sh * .16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
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
                  name == ''
                      ? SizedBox(height: 0)
                      : Row(
                          children: [
                            stock != '0'
                                ? Icon(
                                    Icons.timelapse,
                                    color: Colors.orange,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                            SizedBox(width: 5),
                            CommonWidget.minHeadText(
                              text: name,
                              // fontWeight: FontWeight.bold,
                              color: ColorConstants.mainColor,
                            ),
                          ],
                        ),
                  SizedBox(height: 10),
                  CommonWidget.subtitleText(text: type),
                  Row(
                    children: [
                      CommonWidget.subtitleText(text: 'Rp. '),
                      CommonWidget.minHeadText(
                        text: price,
                        // fontWeight: FontWeight.bold,
                        color: ColorConstants.mainColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: onPressedRemove,
                ),
                Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonWidget.subtitleText(text: 'Stok'),
                      CommonWidget.bigText(
                        text: stock,
                        color: ColorConstants.mainColor,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                  onPressed: onPressedAdd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
