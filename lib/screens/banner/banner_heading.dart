import 'package:flutter/material.dart';
import 'package:ocean_publication/constants/app_colors.dart';

// ignore: use_key_in_widget_constructors
class BannerHeading extends StatefulWidget {
  @override
  _BannerHeadingState createState() => _BannerHeadingState();
}

class _BannerHeadingState extends State<BannerHeading> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,left:5),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Banner",
              style: TextStyle(
                  color: appPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  fontFamily: 'Montserrat'),
            ),
          ]),
    );
  }
}
