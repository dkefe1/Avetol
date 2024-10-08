import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

Widget profileTextFormField(
    {required TextEditingController controller,
    required String labelText,
    required VoidCallback onInteraction}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: TextFormField(
      controller: controller,
      style: TextStyle(color: whiteColor, fontSize: fontSize16),
      onChanged: (value) {
        onInteraction();
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
        labelText: labelText,
        labelStyle: TextStyle(color: whiteColor, fontSize: fontSize13),
        hintStyle: TextStyle(
            color: hintColor,
            fontSize: fontSize18,
            fontWeight: FontWeight.w400),
        fillColor: otpInputFillColor,
        filled: true,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
