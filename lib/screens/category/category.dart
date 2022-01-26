

import 'package:flutter/material.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/category/data.dart';

import 'package:ocean_publication/screens/library/view_all.dart';
import 'package:ocean_publication/screens/packages/view_all.dart';
import 'package:ocean_publication/screens/products/view_all.dart';

import 'package:ocean_publication/screens/videos/view_all.dart';

// ignore: use_key_in_widget_constructors
class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<CategorieModel> categories = [];

  @override
  void initState() {
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Category",
            style: TextStyle(
                color: appPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                fontFamily: 'Montserrat'),
          ),
          const SizedBox(
            height: 10.0,
          ),
          // ignore: sized_box_for_whitespace
          Container(
            height: 50,
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 1.1, right: 1.1, top: 1.1),
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  /// Create List Item tile
                  return CategoriesTile(
                    imgUrls: categories[index].imgUrl,
                    categorie: categories[index].categorieName,
                  );
                }),
          )
        ],
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrls, categorie;

  // ignore: use_key_in_widget_constructors
  const CategoriesTile({@required this.imgUrls, @required this.categorie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // click single category to go its child
        switch (categorie) {
          case 'Books':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BookViewAll()));
            break;
          case 'Videos':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const VideoViewAll()));

            break;
          case 'Packages':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PackageViewAll()));

            break;

          case 'Library':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LibraryViewAll()));

            break;
          default:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BookViewAll()));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(imgUrls,
                    height: 50, width: 100, fit: BoxFit.cover)),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Container(
                height: 50,
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  categorie,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat'),
                ))
          ],
        ),
      ),
    );
  }
}
