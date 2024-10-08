import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

Widget textFormField(
    {required TextEditingController controller,
    required String hintText,
    required VoidCallback onInteraction}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: whiteColor),
    onChanged: (value) {
      onInteraction();
    },
    decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            color: hintColor,
            fontSize: fontSize18,
            fontWeight: FontWeight.w400)),
  );
}
