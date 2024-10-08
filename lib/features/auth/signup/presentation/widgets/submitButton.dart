import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

Widget submitButton(
    {required String text,
    required bool disable,
    required VoidCallback onInteraction}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: disable ? null : onInteraction,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              disable ? Color(0x800B84FF) : primaryColor),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 20))),
      child: Text(
        text,
        style: TextStyle(
            color: whiteColor,
            fontSize: fontSize14,
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}
