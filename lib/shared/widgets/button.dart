import 'package:flutter/material.dart';
import 'package:sales/shared/shared.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final dynamic buttonText;
  final Color buttonTextColor;
  final Color buttonColor;
  final bool isDisabled, isAutoFocus;
  final double width, height, fontSize, borderRadius;
  final FontWeight buttonTextWeight;
  final Color borderColor;
  final EdgeInsetsGeometry outerPadding;
  final double? elevation;

  const CustomButton(
      {Key? key,
      this.onPressed,
      required this.buttonText,
      this.borderColor = Colors.transparent,
      this.isDisabled = false,
      this.isAutoFocus = false,
      this.width = 88.0,
      this.height = 50,
      this.borderRadius = 7.0,
      this.outerPadding = const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
      this.fontSize = 14.0,
      this.buttonColor = ColorConstants.mainColor,
      this.buttonTextColor = Colors.white,
      this.elevation,
      this.buttonTextWeight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
            elevation: WidgetStateProperty.all(elevation),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10),
                side: BorderSide(color: borderColor),
              ),
            ),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return CommonWidget.setOpacity(
                    ColorConstants.disableButton, 0.7);
              } else {
                return buttonColor;
              }
            }),
            textStyle: WidgetStateProperty.all(TextStyle(
              color: buttonTextColor,
              letterSpacing: 1.25,
            ))),
        autofocus: isAutoFocus,
        onPressed: isDisabled ? null : onPressed,
        child: buttonText is String
            ? Text(buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: buttonTextColor,
                  fontWeight: buttonTextWeight,
                  letterSpacing: 1.25,
                ))
            : buttonText,
      ),
    );
  }
}
