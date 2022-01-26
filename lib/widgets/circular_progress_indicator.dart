import 'package:flutter/material.dart';
import 'package:ocean_publication/constants/app_colors.dart';

Widget circularProgressIndicator() {
  return const CircularProgressIndicator(
    backgroundColor: Colors.white,
    valueColor: AlwaysStoppedAnimation<Color>(appPrimaryColor),
  );
}

Widget smallCircularProgressIndicator() {
  return const SizedBox(
      height: 16,
      width: 16,
      child: Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 1.5,
        valueColor: AlwaysStoppedAnimation<Color>(appPrimaryColor),
      )));
}
