import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

Widget buildTextColumn(String boldHeader, String lightBody) {
  return Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boldHeader,
          style: TextStyle(
              color: whiteColor,
              fontSize: fontSize20,
              fontWeight: FontWeight.w900),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        Text(
          lightBody,
          style: TextStyle(
              color: whiteColor,
              fontSize: fontSize15,
              fontWeight: FontWeight.w300),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ],
    ),
  );
}
