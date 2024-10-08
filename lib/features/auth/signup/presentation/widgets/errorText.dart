import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

Widget errorText({required String text}) {
  return SizedBox(
    width: double.infinity,
    child: Text(
      text,
      style: TextStyle(color: Colors.red, fontSize: fontSize16),
      textAlign: TextAlign.start,
    ),
  );
}
