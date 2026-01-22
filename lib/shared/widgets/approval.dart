import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/utils/size_config.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:staffku/shared/widgets/input_field.dart';

class ApprovalFlow {
  static Widget buttonApprovalCnC(controller) {
    final sw = SizeConfig().screenWidth;
    return Container(
      child: controller.detail.value.statusLabel == 'Waiting for approval'
          ? controller.groupId.toString() == '5'
                ? controller.detail.value.statusLabel == 'Waiting for approval'
                      ? Container(
                          child: CustomButton(
                            buttonText: 'SIMPAN',
                            width: sw,
                            onPressed: () {
                              controller.submit();
                            },
                          ),
                        )
                      : Container()
                : Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          buttonColor: Colors.red,
                          buttonText: 'REJECT',
                          width: sw / 2.5,
                          onPressed: () {
                            controller.approval(action: 'reject');
                          },
                        ),
                        CustomButton(
                          buttonColor: Colors.green,
                          buttonText: 'APPROVE',
                          width: sw / 2.5,
                          onPressed: () {
                            controller.approval(action: 'approve');
                          },
                        ),
                      ],
                    ),
                  )
          : Container(),
    );
  }

  static Widget buttonApprovalProspect(controller, condition, levelCondition) {
    final sw = SizeConfig().screenWidth;
    return Container(
      child:
          controller.detail.value.status == '1' ||
              controller.detail.value.statusLabel == 'Created'
          ? controller.groupId.toString() == '5'
                ? controller.detail.value.statusLabel == 'Created'
                      ? Container(
                          child: CustomButton(
                            buttonText: 'SIMPAN',
                            width: sw,
                            onPressed: () {
                              controller.submit();
                            },
                          ),
                        )
                      : Container()
                : condition == '1'
                ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          buttonColor: Colors.red,
                          buttonText: 'REJECT',
                          width: sw / 2.5,
                          onPressed: () {
                            controller.approval(action: 'reject');
                          },
                        ),
                        CustomButton(
                          buttonColor: Colors.green,
                          buttonText: 'APPROVE',
                          width: sw / 2.5,
                          onPressed: () {
                            controller.approval(action: 'approve');
                          },
                        ),
                      ],
                    ),
                  )
                : buttonLevelCondition(
                    controller,
                    levelCondition,
                    controller.groupId.toString(),
                  )
          : Container(),
    );
  }

  static Widget buttonApproval(controller) {
    return controller.groupId.value != '1'
        ? controller.approvalCondition.value == true
              ? buttonApprovalFlow(controller)
              : Container()
        : Container();
  }

  static Widget buttonApprovalFlow(controller) {
    final status = controller.statusApproval.toString().toLowerCase().trim();
    final canApprove = status == 'pengajuan' ||
        status == 'proses' ||
        status == 'waiting' ||
        status == 'waiting for approval' ||
        status == 'pending' ||
        status == 'menunggu' ||
        status == 'menunggu persetujuan' ||
        status == 'diproses';

    return canApprove
        ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1.0,
                color: ColorConstants.borderColor.withValues(alpha: 0.90),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 18.0,
                  spreadRadius: 0.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Approval',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tambahkan catatan jika diperlukan.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withValues(alpha: 0.60),
                  ),
                ),
                const SizedBox(height: 12),
                TextAreaField(
                  controller: controller.noteApprovalController,
                  hintText: 'Catatan (opsional)',
                  minLines: 3,
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        buttonColor: const Color(0xFFDC2626),
                        buttonText: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.close_rounded, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'TOLAK',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        height: 48,
                        elevation: 0,
                        onPressed: () => controller.approval(action: 'reject'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        buttonColor: const Color(0xFF16A34A),
                        buttonText: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_rounded, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'SETUJUI',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        height: 48,
                        elevation: 0,
                        onPressed: () => controller.approval(action: 'approve'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  static Widget buttonLevelCondition(controller, levelCondition, groupId) {
    final sw = SizeConfig().screenWidth;
    bool _showButton = false;
    if (groupId == '2') {
      if (levelCondition == '3') {
        _showButton = true;
      } else {}
    } else if (groupId == '3') {
      if (levelCondition == '2') {
        _showButton = true;
      } else {}
    } else if (groupId == '4') {
      if (levelCondition == '1') {
        _showButton = true;
      } else {}
    } else {}
    return _showButton
        ? Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonColor: Colors.red,
                  buttonText: 'REJECT',
                  width: sw / 2.5,
                  onPressed: () {
                    controller.approval(action: 'reject');
                  },
                ),
                CustomButton(
                  buttonColor: Colors.green,
                  buttonText: 'APPROVE',
                  width: sw / 2.5,
                  onPressed: () {
                    controller.approval(action: 'approve');
                  },
                ),
              ],
            ),
          )
        : Container();
  }

  static Widget buttonApprovalClient(controller) {
    final sw = SizeConfig().screenWidth;
    return Container(
      child:
          controller.detail.value.status == '1' ||
              controller.detail.value.statusLabel == 'Created'
          ? controller.groupId.toString() == '5' ||
                    controller.groupId.toString() == '2' ||
                    controller.groupId.toString() == '3'
                ? controller.detail.value.statusLabel == 'Created'
                      ? Container(
                          child: CustomButton(
                            buttonText: 'SIMPAN',
                            width: sw,
                            onPressed: () {
                              controller.submit();
                            },
                          ),
                        )
                      : Container()
                : Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          buttonColor: Colors.red,
                          buttonText: 'REJECT',
                          width: sw / 2.5,
                          onPressed: () {
                            controller.approval(action: 'reject');
                          },
                        ),
                        CustomButton(
                          buttonColor: Colors.green,
                          buttonText: 'APPROVE',
                          width: sw / 2.5,
                          onPressed: () {
                            controller.approval(action: 'approve');
                          },
                        ),
                      ],
                    ),
                  )
          : Container(),
    );
  }

  static Widget hideWidget({id, widget, hideId = '5'}) {
    return id != hideId ? widget : Container();
  }

  static Widget hideClientWidget({id, widget}) {
    return id == '2' || id == '3' ? Container() : widget;
  }

  static Widget hideClientKorlapWidget({id, widget}) {
    return id == '2' || id == '3' || id == '4' ? Container() : widget;
  }

  static Widget hideClientTadWidget({id, widget}) {
    return id == '2' || id == '3' || id == '5' ? Container() : widget;
  }

  static Widget notHideWidget({id, widget, hideId = '5'}) {
    return id == hideId ? widget : Container();
  }

  static Widget statusApproval_(data) {
    final sw = SizeConfig().screenWidth;
    final sh = SizeConfig().screenHeight;
    return Container(
      width: sw,
      height: sh * .05,
      child: Card(
        elevation: 0,
        color: data.status == '2' || data.statusLabel == 'Selesai'
            ? Colors.green
            : data.status == '1' ||
                  data.statusLabel == 'Created' ||
                  data.statusLabel == 'Rencana'
            ? Colors.yellow[800]
            : Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Center(
          child: CommonWidget.bodyText(
            text: data.statusLabel.toString(),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Widget statusApprovalProspect(label) {
    final sw = SizeConfig().screenWidth;
    final sh = SizeConfig().screenHeight;
    return Container(
      width: sw,
      height: sh * .05,
      child: Card(
        elevation: 0,
        color: label.toString().toLowerCase() == 'prospek'
            ? Colors.green
            : label.toString().toLowerCase() == 'tidak tertarik'
            ? Colors.red
            : Colors.yellow[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Center(
          child: CommonWidget.bodyText(
            text: label.toString(),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Widget statusApproval(label, levelApproval) {
    final statusRaw = label?.toString().trim() ?? '';
    final levelRaw = levelApproval?.toString().trim() ?? '';
    final statusLower = statusRaw.toLowerCase().trim();

    final isUnknown =
        statusLower.isEmpty || statusLower == 'null' || statusLower == '-';

    final isApproved = statusLower == 'approved' ||
        statusLower == 'approve' ||
        statusLower == 'ok' ||
        statusLower == 'disetujui' ||
        statusLower == 'setujui';
    final isPending = statusLower == 'proses' ||
        statusLower == 'pengajuan' ||
        statusLower == 'waiting' ||
        statusLower == 'waiting for approval' ||
        statusLower == 'pending' ||
        statusLower == 'menunggu' ||
        statusLower == 'menunggu persetujuan' ||
        statusLower == 'diproses';

    late final Color statusColor;
    late final IconData statusIcon;
    late final String subtitle;

    if (isUnknown) {
      statusColor = Colors.blueGrey;
      statusIcon = Icons.info_outline_rounded;
      subtitle = levelRaw.isNotEmpty && levelRaw != '-'
          ? 'Menunggu persetujuan ${levelRaw.toUpperCase()}.'
          : 'Status belum tersedia.';
    } else if (isApproved) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_rounded;
      subtitle = 'Pengajuan sudah disetujui.';
    } else if (isPending) {
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_top_rounded;
      subtitle = levelRaw.isNotEmpty && levelRaw != '-'
          ? 'Menunggu keputusan ${levelRaw.toUpperCase()}.'
          : 'Sedang diproses.';
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.cancel_rounded;
      subtitle = 'Pengajuan ditolak.';
    }

    Widget chip({required String text, required Color color}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.22)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            fontFamily: 'Poppins',
            letterSpacing: 0.2,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.0,
          color: ColorConstants.borderColor.withValues(alpha: 0.90),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18.0,
            spreadRadius: 0.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATUS',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                    height: 1.15,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withValues(alpha: 0.62),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: [
              if (levelRaw.isNotEmpty && levelRaw != '-')
                chip(text: levelRaw.toUpperCase(), color: ColorConstants.black),
              if (statusRaw.isNotEmpty && statusRaw != '-')
                chip(text: statusRaw.toUpperCase(), color: statusColor),
            ],
          ),
        ],
      ),
    );
  }

  static Widget statusApprovalProspectV2(label) {
    final sw = SizeConfig().screenWidth;
    final sh = SizeConfig().screenHeight;
    return Container(
      width: sw,
      height: sh * .05,
      child: Card(
        elevation: 0,
        color: label.toString().toLowerCase() == 'sudah order'
            ? Colors.green
            : label.toString().toLowerCase() == 'belum order'
            ? Colors.yellow[800]
            : Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Center(
          child: CommonWidget.bodyText(
            text: label.toString(),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Widget deleteButtonApproval({controller, name}) {
    return controller.groupId.toString() != '3'
        ? IconButton(
            onPressed: () {
              controller.deleteGoods(name: name);
            },
            icon: Icon(Icons.close_rounded),
            color: Colors.red,
          )
        : Container();
  }

  static Widget addButtonApproval({controller, name, onPressed, showId = '1'}) {
    return controller.groupId.toString() == showId
        ? IconButton(
            onPressed: onPressed,
            tooltip: 'Tambah',
            icon: Icon(Icons.add_box_rounded, size: 20),
          )
        : Container();
  }

  static Widget addButtonApprovalClient({
    controller,
    name,
    onPressed,
    showId = '5',
  }) {
    return controller.groupId.toString() == showId ||
            controller.groupId.toString() == '2'
        ? IconButton(
            onPressed: onPressed,
            tooltip: 'Tambah',
            icon: Icon(Icons.add_box_rounded, size: 20),
          )
        : Container();
  }
}
