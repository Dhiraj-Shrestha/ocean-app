import 'package:flutter/material.dart';
import 'package:ocean_publication/constants/app_colors.dart';

// ignore: use_key_in_widget_constructors
class RelatedProductTitle extends StatefulWidget {
  @override
  _RelatedProductTitleState createState() => _RelatedProductTitleState();
}

class _RelatedProductTitleState extends State<RelatedProductTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 3),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Related Products",
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
