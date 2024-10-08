import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

Widget buildTextListColumn(String boldHeader, Wrap listView) {
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
        SizedBox(width: double.infinity, height: 40, child: listView)
      ],
    ),
  );
}
