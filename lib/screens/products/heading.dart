import 'package:flutter/material.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/screens/products/view_all.dart';

// ignore: use_key_in_widget_constructors
class CategoryProductHeading extends StatefulWidget {
  @override
  _CategoryProductHeadingState createState() => _CategoryProductHeadingState();
}

class _CategoryProductHeadingState extends State<CategoryProductHeading> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text(
          "Books",
          style: TextStyle(
              color: appPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              fontFamily: 'Montserrat'),
        ),
        Row(
          children: [
            const Icon(
              Icons.remove_red_eye_rounded,
              color: appPrimaryColor,
              size: 18.0,
            ),
            const SizedBox(
              width: 5.0,
            ),
            InkWell(
              onTap: () {
                BookViewAll();
  
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BookViewAll()));
              },
              child: const Text(
                "View All",
                style: TextStyle(
                    color: appPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
