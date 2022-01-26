import 'package:flutter/material.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/products/single_product.dart';
import 'package:ocean_publication/widgets/book_container.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

// ignore: must_be_immutable
class Package extends StatefulWidget {
  List<LibraryItems> packages;
  bool loading;

  Package({Key key, @required this.packages, @required this.loading})
      : super(key: key);

  @override
  _PackageState createState() => _PackageState();
}

class _PackageState extends State<Package> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 265,
      child: widget.loading
          ? Center(child: circularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.packages.length,
              itemBuilder: (_, index) {
                final library = widget.packages[index];

                return BookContainer(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SingleProductPage(libraryItems: library)));
                    },
                    bookImage: library.image,
                    bookTitle: library.title,
                    bookAuthor: library.author,
                    bookOfferPrice: library.offerPrice.toString(),
                    bookPrice: library.price.toString());
              }),
    );
  }
}
