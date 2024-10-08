import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

Widget buildCategory(
    context,
    double? width,
    double? height,
    Color gradientStart,
    Color gradientEnd,
    String categoryName,
    VoidCallback onInteraction) {
  double screenWidth = MediaQuery.of(context).size.width;
  return GestureDetector(
    onTap: onInteraction,
    child: Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(left: 21, bottom: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [gradientStart, gradientEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            "images/logo.png",
            width: 41,
            height: 26,
          ),
          Text(
            categoryName,
            style: TextStyle(
                color: whiteColor,
                fontSize: screenWidth < 400 ? fontSize18 : fontSize24,
                fontWeight: FontWeight.w300,
                height: 1),
            softWrap: true,
            overflow: TextOverflow.visible,
          )
        ],
      ),
    ),
  );
}
