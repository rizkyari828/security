import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:staffku/shared/shared.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CommonWidget {
  static AppBar appBar({
    String title = "",
    bool backIcon = true,
    bool centerTextAlign = false,
    void Function()? callback,
    bool actionIcon = false,
    VoidCallback? onPressedActionIcon,
  }) {
    return AppBar(
      iconTheme: IconThemeData(
        color: ColorConstants.black, //change your color here
      ),
      // toolbarHeight: 50,
      automaticallyImplyLeading: backIcon,
      centerTitle: centerTextAlign,
      title: Text(
        title,
        style: TextStyle(
          color: ColorConstants.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          fontFamily: 'Poppins',
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      actions: [
        actionIcon == true
            ? IconButton(
                onPressed: onPressedActionIcon,
                tooltip: 'Tambah CnC',
                icon: Icon(Icons.add_box_rounded, size: 20),
              )
            : Container(),
      ],
    );
  }

  static SizedBox rowHeight({double height = 16}) {
    return SizedBox(height: height);
  }

  static SizedBox rowWidth({double width = 30}) {
    return SizedBox(width: width);
  }

  static Text bigText({
    String text = "",
    Color color = ColorConstants.black,
    TextAlign align = TextAlign.start,
  }) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 33,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Text headText({
    String text = "",
    Color color = ColorConstants.black,
    TextAlign align = TextAlign.start,
  }) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 23,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Text minHeadText({
    String text = "",
    Color color = ColorConstants.black,
    TextAlign align = TextAlign.start,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return Text(
      text,
      maxLines: 2,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: 18,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Text subtitleText({
    String text = "",
    Color color = ColorConstants.black,
    FontWeight fontWeight = FontWeight.normal,
    textAlign = TextAlign.start,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: 13,
        letterSpacing: 0.15,
        fontFamily: 'Poppins',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Text subtitleMultilineText({
    String text = "",
    Color color = ColorConstants.black,
    FontWeight fontWeight = FontWeight.normal,
    textAlign = TextAlign.start,
  }) {
    return Text(
      maxLines: 2,
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: 13,
        letterSpacing: 0.15,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Text subtitlePlusText({
    String text = "",
    Color color = ColorConstants.black,
    FontWeight fontWeight = FontWeight.normal,
    textAlign = TextAlign.start,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: 15,
        letterSpacing: 0.15,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Text minSubtitleText({
    String text = "",
    Color color = ColorConstants.black,
    FontWeight fontWeight = FontWeight.normal,
    textAlign = TextAlign.start,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: 12,
        letterSpacing: 0.15,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Text bodyText({String text = "", Color color = ColorConstants.black}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        letterSpacing: 0.5,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Text captionText({
    String text = "",
    Color color = ColorConstants.black,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.normal,
        fontSize: 10,
        letterSpacing: 0.4,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Text bodyMultilineText({
    String text = "",
    Color color = ColorConstants.black,
  }) {
    return Text(
      text,
      maxLines: 5,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        letterSpacing: 0.4,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Text captionMultilineText({
    String text = "",
    Color color = ColorConstants.black,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Text(
      text,
      maxLines: 2,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.normal,
        fontSize: 10,
        letterSpacing: 0.4,
        fontFamily: 'Poppins',
      ),
    );
  }

  static Row labelExpanded({
    String label = "",
    value = "",
    Color color = ColorConstants.black,
    fontWeight2 = FontWeight.w600,
    fontSize = 14.0,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.normal,
              fontSize: fontSize,
              letterSpacing: 0.5,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: fontWeight2,
              fontSize: fontSize,
              letterSpacing: 0.5,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  static Row labelIconExpanded({
    Icon icon = const Icon(Icons.person, size: 30, color: Colors.orangeAccent),
    text = "",
    Color color = ColorConstants.black,
    fontWeight2 = FontWeight.w600,
    fontSize = 14.0,
    isSubtitle = true,
  }) {
    return Row(
      children: <Widget>[
        icon,
        SizedBox(width: 10),
        Expanded(
          child: isSubtitle
              ? minHeadText(text: text, color: color, fontWeight: fontWeight2)
              : captionText(text: text, color: color),
        ),
      ],
    );
  }

  static Row twoLabelIconExpanded({
    Icon icon = const Icon(Icons.person, size: 30, color: Colors.orangeAccent),
    text = "",
    text2 = "",
    Color color = ColorConstants.black,
    fontWeight2 = FontWeight.w600,
    fontSize = 14.0,
    isSubtitle = true,
  }) {
    return Row(
      children: <Widget>[
        icon,
        SizedBox(width: 10),
        Expanded(
          child: isSubtitle
              ? Column(
                  children: [
                    subtitleText(
                      text: text,
                      color: color,
                      fontWeight: fontWeight2,
                    ),
                    subtitleText(
                      text: text2,
                      color: color,
                      fontWeight: fontWeight2,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subtitleText(text: text, color: color),
                    SizedBox(height: 5),
                    subtitleText(text: text2, color: color),
                  ],
                ),
        ),
      ],
    );
  }

  static Row labelRowIcon({icon, widget}) {
    return Row(
      children: [
        Icon(icon, color: ColorConstants.mainColor, size: 13),
        SizedBox(width: 5.0),
        widget,
      ],
    );
  }

  static Row widgetExpanded({
    Widget? left,
    Widget? right,
    Color color = ColorConstants.black,
  }) {
    return Row(
      children: <Widget>[
        Expanded(child: left ?? Container()),
        SizedBox(width: 20),
        Expanded(child: right ?? Container()),
      ],
    );
  }

  static void toast(String error) async {
    await Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  static void errorSnackBar(String error) async {
    Get.snackbar(
      "Error",
      error,
      icon: Icon(Icons.error_outline_rounded, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: const Color(0xFFB42318),
      borderRadius: 20,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      colorText: Colors.white,
      duration: Duration(seconds: 4),
      isDismissible: true,
      //dismissDirection: SnackDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static Widget cardWithShadow(child) {
    final sw = SizeConfig().screenWidth;
    return Container(
      width: sw,
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Padding(padding: const EdgeInsets.all(20.0), child: child),
    );
  }

  static Color setOpacity(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  static Widget progressLiniar(
    int current,
    int total,
    double percentage,
    context,
  ) {
    return Column(
      children: [
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width - 50,
          animation: true,
          lineHeight: 20.0,
          animationDuration: 2000,
          percent: percentage,
          center: CommonWidget.minSubtitleText(
            text: '${current} / ${total}',
            color: ColorConstants.white,
          ),
          barRadius: Radius.circular(10),
          progressColor: percentage < 0.25
              ? Colors.red
              : percentage < 0.5
              ? Colors.orange
              : percentage < 0.75
              ? Colors.amber
              : percentage < 1.0
              ? ColorConstants.secondaryAppColor
              : Colors.green,
        ),
        SizedBox(height: 20.0),
        Divider(color: ColorConstants.borderColor),
        SizedBox(height: 20.0),
      ],
    );
  }

  static String getRoleLabel(String role) {
    switch (role.toLowerCase()) {
      case '1':
        return 'Staff';
      case '2':
        return 'SPV';
      // case '3':
      //   return 'Area';
      // case '4':
      //   return 'Client';
      default:
        return 'Staff';
    }
  }

  static Widget customStatusCard({
    String firstParagraf = '',
    String secondParagraf = '',
    String thirdParagraf = '',
    String secondParagrafValue = '',
    String thirdParagrafValue = '',
    String status = '',
    String typeStatus = '',
    VoidCallback? onPressed,
  }) {
    final sh = SizeConfig().screenHeight;
    final sw = SizeConfig().screenWidth;
    String finalStatus;
    if (typeStatus == 'lead') {
      if (status.toLowerCase() == 'follow up') {
        finalStatus = '1';
      } else {
        finalStatus = '0';
      }
    } else if (typeStatus == 'prospect') {
      if (status.toLowerCase() == 'sudah order') {
        finalStatus = '1';
      } else {
        finalStatus = '0';
      }
    } else {
      if (status.toLowerCase() == 'follow up') {
        finalStatus = '1';
      } else {
        finalStatus = '0';
      }
    }
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      height: firstParagraf == '' ? sh * .15 : sh * .16,
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
                    Container(
                      child: CommonWidget.subtitleText(
                        text: firstParagraf,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: SizeConfig().screenWidth * .50,
                      child: CommonWidget.subtitleText(
                        text: secondParagraf + " : " + secondParagrafValue,
                        color: ColorConstants.mainColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    CommonWidget.subtitleText(
                      text: thirdParagraf + " : " + thirdParagrafValue,
                      color: ColorConstants.mainColor,
                    ),
                    SizedBox(height: 5),
                    Spacer(),
                    Container(
                      width: sw * .85,
                      decoration: BoxDecoration(
                        color: finalStatus == '1'
                            ? Colors.green[100]
                            : Colors.yellow[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            finalStatus == '1'
                                ? Icons.check_circle
                                : Icons.warning_amber_rounded,
                            color: finalStatus == '1'
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          CommonWidget.captionText(
                            text: status,
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
