import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/constants/common.dart';
import 'package:sales/shared/utils/common_widget.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String placeholder;
  final bool? isPassword;
  final Color color;
  final double fontSize;
  final bool password;
  final String? Function(String?)? validator;
  final Widget? prefixIcon, suffixIcon;
  final bool? isError;
  final bool? textObscured;
  final Function()? onVisibilityPressed;

  InputField({
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.labelText = '',
    this.placeholder = '',
    this.color = Colors.white,
    this.fontSize = CommonConstants.bodyText,
    this.password = false,
    this.validator,
    this.prefixIcon = const Icon(
      Icons.person,
      color: ColorConstants.black,
    ),
    this.suffixIcon = const Icon(
      Icons.error_outline,
      size: 30,
      color: Color.fromRGBO(255, 0, 0, 1.0),
    ),
    this.isPassword = false,
    this.isError = false,
    this.textObscured = true,
    this.onVisibilityPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CommonWidget.setOpacity(ColorConstants.cardColor, 0.9),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
      ),
      // color: ColorConstants.backgroundTextField,
      // elevation: 0.1,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffix: isError ?? false
              ? Icon(
                  Icons.error_outline,
                  size: 25,
                  color: Color.fromRGBO(255, 0, 0, 1.0),
                )
              : null,
          suffixIcon: _suffixIcon(),
          focusedBorder: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: new BorderSide(
                  color: isError ?? false ? Colors.red : color, width: 1.0)),
          enabledBorder: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: new BorderSide(
                  color: isError ?? false ? Colors.red : color, width: 1.0)),
          hintText: this.placeholder,
          hintStyle: TextStyle(
            fontSize: fontSize,
            // color: color,
            fontWeight: FontWeight.normal,
          ),
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          // labelStyle: TextStyle(
          //   fontSize: fontSize - 2,
          //   color: color,
          //   height: 0.2,
          //   fontWeight: FontWeight.normal,
          // ),
        ),
        controller: this.controller,
        style: TextStyle(
          color: ColorConstants.black,
          fontSize: fontSize,
          fontWeight: FontWeight.normal,
        ),
        keyboardType: this.keyboardType,
        obscureText: _showPassword(),
        autocorrect: false,
        validator: this.validator,
      ),
    );
  }

  Widget? _suffixIcon() {
    if (isPassword ?? false) {
      return IconButton(
        color: ColorConstants.black,
        onPressed: isPassword ?? false ? onVisibilityPressed : null,
        icon: textObscured ?? false
            ? Icon(
                Icons.visibility_off,
              )
            : Icon(
                Icons.visibility,
              ),
      );
    }
    return isError ?? false ? suffixIcon : null;
  }

  bool _showPassword() {
    if (isPassword ?? false) {
      return textObscured ?? false;
    }
    return false;
  }
}

class InputInputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String placeholder;
  final Color color;
  final double fontSize;
  final bool password;
  final String? Function(String?)? validator;
  final bool? isSuffixIcon;
  final Widget? suffixIcon;
  final bool? isError;
  final bool? textObscured;
  final Function()? onSuffixPressed;
  final VoidCallback? onChanged;
  final bool isDisabled;
  final bool isRequired;
  final bool showError;

  InputInputField({
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.labelText = '',
    this.placeholder = '',
    this.color = Colors.white,
    this.fontSize = CommonConstants.bodyText,
    this.password = false,
    this.validator,
    this.isSuffixIcon = false,
    this.isError = false,
    this.textObscured = true,
    this.onSuffixPressed,
    this.suffixIcon,
    this.onChanged,
    this.isDisabled = false,
    this.isRequired = false,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            readOnly: isDisabled,
            enableInteractiveSelection: isDisabled,
            keyboardType: this.keyboardType,
            autocorrect: false,
            controller: this.controller,
            onChanged: (text) {
              if (onChanged != null) onChanged!();
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  color: const Color.fromARGB(255, 20, 22, 24),
                  fontFamily: 'Poppins'),
              prefixStyle: TextStyle(
                  color: ColorConstants.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins'),
              suffixStyle: TextStyle(
                  color: ColorConstants.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins'),
              labelText: labelText,
              hintText: placeholder,
              filled: true,
              fillColor: isDisabled
                  ? Colors.grey[200]
                  : ColorConstants.backgroundTextField,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: ColorConstants.mainColor,
                ),
              ),
              suffixIcon: _suffixIcon(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey[200] ?? Colors.grey,
                ),
              ),
            ),
          ),
          if (isRequired && showError && controller.text.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 4.0),
              child: Text(
                'Harus diisi',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget? _suffixIcon() {
    if (isSuffixIcon ?? false) {
      return IconButton(
        onPressed: isSuffixIcon ?? false ? onSuffixPressed : null,
        icon: suffixIcon ?? Icon(Icons.add),
      );
    }
    return isError ?? false ? suffixIcon : null;
  }
}

class TextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDisabled;
  final ValueChanged<String>? onChanged;
  final bool isRequired;
  final bool showError;

  TextAreaField(
      {required this.controller,
      this.isDisabled = false,
      this.onChanged,
      this.isRequired = false,
      this.showError = false,
      s});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.1,
      color: isDisabled ? Colors.grey[200] : ColorConstants.backgroundTextField,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              readOnly: isDisabled,
              enableInteractiveSelection: isDisabled,
              style: TextStyle(
                  color: ColorConstants.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins'),
              controller: controller,
              maxLines: 8,
              onChanged: onChanged,
              decoration: InputDecoration.collapsed(
                hintText: "Masukkan text disini",
                hintStyle: TextStyle(
                    color: ColorConstants.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    letterSpacing: 0.5,
                    fontFamily: 'Poppins'),
                filled: true,
                fillColor: isDisabled
                    ? Colors.grey[200]
                    : ColorConstants.backgroundTextField,
                focusColor: isDisabled
                    ? Colors.grey[200]
                    : ColorConstants.backgroundTextField,
              ),
            ),
            if (isRequired && showError && controller.text.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                child: Text(
                  'Harus diisi',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomDropDownSearch extends StatelessWidget {
  final List<dynamic> listItem;
  final String labelText;
  final onChanged;
  final bool enabled;
  final selectedItem;

  CustomDropDownSearch({
    required this.listItem,
    this.labelText = '',
    this.onChanged,
    this.enabled = true,
    this.selectedItem = null,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung tinggi popup agar tidak terlalu panjang jika item sedikit
    final int itemCount = listItem.length;
    final double itemHeight = 48.0; // tinggi item dropdown
    final double maxPopupHeight = itemCount * itemHeight + 16.0; // padding

    return Container(
      child: DropdownSearch<dynamic>(
        compareFn: (a, b) => a == b,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                letterSpacing: 0.5,
                color: ColorConstants.black,
                fontFamily: 'Poppins'),
            prefixStyle: TextStyle(
                color: ColorConstants.black,
                fontWeight: FontWeight.normal,
                fontSize: 14,
                letterSpacing: 0.5,
                fontFamily: 'Poppins'),
            suffixStyle: TextStyle(
                color: ColorConstants.black,
                fontWeight: FontWeight.normal,
                fontSize: 14,
                letterSpacing: 0.5,
                fontFamily: 'Poppins'),
            labelText: labelText,
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[200],
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: ColorConstants.mainColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: ColorConstants.mainColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: ColorConstants.mainColor,
              ),
            ),
          ),
        ),
        enabled: enabled,
        selectedItem: selectedItem,
        items: (filter, infiniteScrollProps) => listItem,
        onChanged: onChanged,
        popupProps: PopupProps.menu(
          constraints: BoxConstraints(
            maxHeight: itemCount < 5 ? maxPopupHeight : 250,
          ),
        ),
      ),
    );
  }
}
