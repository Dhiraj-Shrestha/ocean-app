import 'package:flutter/material.dart';
import 'package:ocean_publication/constants/app_colors.dart';

Widget richText({simpleText, colorText}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: RichText(
      text: TextSpan(children: [
        TextSpan(
          text: simpleText + ': ',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
        TextSpan(
            text: colorText,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                color: appPrimaryColor,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ]),
    ),
  );
}
