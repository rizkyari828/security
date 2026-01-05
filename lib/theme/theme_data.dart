import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staffku/shared/shared.dart';

class ThemeConfig {
  static ThemeData createTheme({
    required Brightness brightness,
    required Color background,
    required Color primaryText,
    Color? secondaryText,
    required Color accentColor,
    Color? divider,
    Color? buttonBackground,
    required Color buttonText,
    Color? cardBackground,
    Color? disabled,
    required Color error,
  }) {
    final baseTextTheme = brightness == Brightness.dark
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    return ThemeData(
      brightness: brightness,
      canvasColor: background,
      cardColor: background,
      dividerColor: divider,
      dividerTheme: DividerThemeData(color: divider, space: 1, thickness: 1),
      // cardTheme: CardTheme(
      //   color: cardBackground,
      //   margin: EdgeInsets.zero,
      //   clipBehavior: Clip.antiAliasWithSaveLayer,
      // ),
      primaryColor: accentColor,
      // textSelectionColor: accentColor,
      // textSelectionHandleColor: accentColor,
      // cursorColor: accentColor,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: accentColor,
        selectionHandleColor: accentColor,
        cursorColor: accentColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardBackground,
        iconTheme: IconThemeData(color: secondaryText),
        toolbarTextStyle: TextTheme(
          bodyLarge: baseTextTheme.bodyLarge!.copyWith(
            color: secondaryText,
            fontSize: 18,
          ),
        ).bodyMedium,
        titleTextStyle: TextTheme(
          bodyLarge: baseTextTheme.bodyLarge!.copyWith(
            color: secondaryText,
            fontSize: 18,
          ),
        ).titleLarge,
      ),
      iconTheme: IconThemeData(color: secondaryText, size: 16.0),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: accentColor,
          secondary: accentColor,
          surface: background,
          error: error,
          onPrimary: buttonText,
          onSecondary: buttonText,
          onSurface: buttonText,
          onError: buttonText,
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: accentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: TextStyle(color: error),
        labelStyle: TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          color: CommonWidget.setOpacity(primaryText, 0.5),
        ),
        hintStyle: TextStyle(
          color: secondaryText,
          fontSize: 13.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      fontFamily: 'Rubik',
      unselectedWidgetColor: hexToColor('#DADCDD'),
      textTheme: TextTheme(
        displayLarge: baseTextTheme.displayLarge!.copyWith(
          color: primaryText,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: baseTextTheme.displayMedium!.copyWith(
          color: primaryText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: baseTextTheme.displaySmall!.copyWith(
          color: secondaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: baseTextTheme.headlineMedium!.copyWith(
          color: primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: baseTextTheme.headlineSmall!.copyWith(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          return null;
        }),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: accentColor)
          .copyWith(surface: background)
          .copyWith(error: error),
    );
  }

  static ThemeData get lightTheme => createTheme(
    brightness: Brightness.light,
    background: ColorConstants.lightScaffoldBackgroundColor,
    cardBackground: ColorConstants.secondaryAppColor,
    primaryText: Colors.black,
    secondaryText: Colors.white,
    accentColor: ColorConstants.secondaryAppColor,
    divider: ColorConstants.secondaryAppColor,
    buttonBackground: Colors.black38,
    buttonText: ColorConstants.secondaryAppColor,
    disabled: ColorConstants.secondaryAppColor,
    error: Colors.red,
  );

  static ThemeData get darkTheme => createTheme(
    brightness: Brightness.dark,
    background: ColorConstants.darkScaffoldBackgroundColor,
    cardBackground: ColorConstants.secondaryDarkAppColor,
    primaryText: Colors.white,
    secondaryText: Colors.black,
    accentColor: ColorConstants.secondaryDarkAppColor,
    divider: Colors.black45,
    buttonBackground: Colors.white,
    buttonText: ColorConstants.secondaryDarkAppColor,
    disabled: ColorConstants.secondaryDarkAppColor,
    error: Colors.red,
  );
}
