import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

Widget profilePhoneFormField(
    {required TextEditingController controller, required String labelText}) {
  return Padding(
    padding: const EdgeInsets.only(top: 9, bottom: 30),
    child: IntlPhoneField(
      dropdownTextStyle: TextStyle(color: whiteColor, fontSize: fontSize16),
      enabled: false,
      validator: null,
      disableLengthCheck: true,
      controller: controller,
      initialCountryCode: 'ET',
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(9)
      ],
      keyboardType: TextInputType.phone,
      style: TextStyle(color: whiteColor, fontSize: fontSize16),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
        labelText: labelText,
        labelStyle: TextStyle(
            color: whiteColor.withOpacity(0.8),
            fontSize: fontSize18,
            fontWeight: FontWeight.w400),
        filled: true,
        fillColor: otpInputFillColor,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
