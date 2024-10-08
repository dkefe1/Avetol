import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget profileDateFormField(
    {required TextEditingController controller,
    required String hintText,
    required VoidCallback onPressed,
    required VoidCallback onInteraction}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: whiteColor),
    onTap: onPressed,
    onChanged: (value) {
      onInteraction();
    },
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
    ],
    keyboardType: TextInputType.datetime,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
      filled: true,
      fillColor: otpInputFillColor,
      labelText: hintText,
      labelStyle: TextStyle(
        color: hintColor,
        fontSize: fontSize18,
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
    ),
  );
}
