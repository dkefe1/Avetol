import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

Widget buildMovieInfo(
    double? fontSize, String genre, String seasons, String releasedYear) {
  return RichText(
    softWrap: true,
    overflow: TextOverflow.visible,
    text: TextSpan(
        style: TextStyle(
            color: whiteColor, fontSize: fontSize, fontWeight: FontWeight.w300),
        children: [
          TextSpan(
            text: genre,
          ),
          TextSpan(
            text: " \u2022 $seasons",
          ),
          TextSpan(
            text: " \u2022 $releasedYear",
          ),
        ]),
  );
}

Widget buildWorksInfo(double? fontSize, String seasons, String releasedYear) {
  return RichText(
    softWrap: true,
    overflow: TextOverflow.visible,
    text: TextSpan(
        style: TextStyle(
            color: whiteColor, fontSize: fontSize, fontWeight: FontWeight.w300),
        children: [
          TextSpan(
            text: "$seasons",
          ),
          TextSpan(
            text: " \u2022 $releasedYear",
          ),
        ]),
  );
}
