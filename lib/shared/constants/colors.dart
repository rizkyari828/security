import 'package:flutter/material.dart';

class ColorConstants {
  static const Color lightScaffoldBackgroundColor = Color(0xFFFFFFFF);
  static Color darkScaffoldBackgroundColor = hexToColor('#2F2E2E');
  // Brand accent (blue) + neutral (charcoal) for security UI.
  static Color secondaryAppColor = Color(0xFF0F6CBD);
  static Color secondaryDarkAppColor = Colors.white;
  static Color tipColor = hexToColor('#B6B6B6');
  static Color lightGray = Color(0xFFF6F6F6);
  static Color darkGray = Color(0xFF9F9F9F);
  static const Color black = Color(0xFF111827);
  static Color white = Color(0xFFFFFFFF);

  static const Color greenBackground = Color(0xFFd6f3a1);
  static const Color blueBackground = Color(0xFFE8F5FE);
  static const Color yellowBackground = Color(0xFFF4DE07);
  static const Color mainColor = Color(0xFF0F6CBD);
  static const Color secondaryColor = Color(0xFF0B4F8A);
  static const Color disableButton = Color.fromRGBO(200, 200, 200, 1.0);
  static Color backgroundTextField = hexToColor('#EDF0F4');

  static const Color borderColor = Color(0xFFf4f4f4);
  static const Color cardColor = Color(0xFFFf5f7f9);
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
