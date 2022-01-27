import 'package:flutter/material.dart';

const appPrimaryColor = Color(0xFF0b4aa2); // primary color
const appSecondaryColor = Color(0xFF068cd4); // secondary color

const kTextColor = Color(0xFF7cccec); // secondary text color

const kPrimaryLightColor = Color(0xFF5ba6d8); // primary light color

const kPrimaryGradientColor = LinearGradient(
  // primary gradient color
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF0b4aa2), Color(0xFF068cd4)],
);

const IconData delete = IconData(0xe1b9, fontFamily: 'MaterialIcons');

TextStyle greyStyle =
     const TextStyle(color: Colors.grey, fontSize: 15, letterSpacing: 0.8);

TextStyle headingStyle =
    const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700);
TextStyle largeTextStyle = const TextStyle(
    fontSize: 25.0, fontWeight: FontWeight.w700, color: appPrimaryColor);

TextStyle subHeadingStyle =
    const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600);
