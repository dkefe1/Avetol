import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget giftCardTextForm({
  required TextEditingController controller,
  required String hintText,
  required VoidCallback onInteraction,
  required VoidCallback onSubmit,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(29),
    child: TextFormField(
      controller: controller,
      style: const TextStyle(color: whiteColor),
      onChanged: (value) {
        onInteraction();
      },
      onFieldSubmitted: (value) {
        onSubmit();
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(16)
      ],
      cursorColor: whiteColor,
      decoration: InputDecoration(
          fillColor: indicatorColor.withOpacity(0.25),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
              color: hintColor,
              fontSize: fontSize18,
              fontWeight: FontWeight.w400)),
    ),
  );
}
