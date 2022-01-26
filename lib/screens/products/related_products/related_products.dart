// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/products/single_product.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class RelatedProducts extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  final String type, slug;

  // ignore: prefer_const_constructors_in_immutables
  RelatedProducts({Key key, @required this.slug, @required this.type})
      : super(key: key);

  @override
  _RelatedProductsState createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts> {
  final List<LibraryItems> _listOfrelatedProducts = [];
  var loading = false;

  // ignore: prefer_void_to_null
  Future<Null> _fetchRelatedProducts() async {
    setState(() {
      loading = true;
    });

    String type = widget.type;
    String slug = widget.slug;

    if (type != '' && slug != '') {
      var response = await CallApi().getAllRelatedProducts(type, slug);
      var data = jsonDecode(response.body);

      if (data['status']) {
        // ignore: avoid_print
        var relatedProducts = data['data']['related_products'];
        if (relatedProducts != null) {
          setState(() {
            for (Map i in relatedProducts) {
              _listOfrelatedProducts.add(LibraryItems.fromJson(i));
            }
            loading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    _fetchRelatedProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_listOfrelatedProducts.isEmpty) {
   
      return Container(
        height: 350,
        width: 410,
        child: const Center(
            child: Text('No Related Products.',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.w600))),
      );
    }
 
    return Container(
      height: 267,
      child: loading
          ? Center(child: circularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _listOfrelatedProducts.length,
              itemBuilder: (_, index) {
                final item = _listOfrelatedProducts[index];
                return Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SingleProductPage(libraryItems: item)));
                      },
                   
                      child: Container(
                        width: 152,
                        child: Card(
                          elevation: 2,
                          shadowColor: Colors.black,
                          color: const Color(0xFFf6f6f6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.network(
                                item.image,
                                fit: BoxFit.fill,
                                height: 180.0,
                                width: 140.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 5.0),
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                      color: appPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 5.0),
                                    child: Text(
                                      item.author.split(',')[0],
                                      style: const TextStyle(
                                          color: appSecondaryColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  // Column(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   children: [
                                  //     Padding(
                                  //         padding: const EdgeInsets.only(
                                  //             left: 5, right: 5),
                                  //         child: buildRatingStart(item.rating)),
                                  //     Row(
                                  //       children: [
                                  //         Padding(
                                  //           padding:
                                  //               const EdgeInsets.only(right: 4),
                                  //           child: Text(
                                  //             "(${item.rating})",
                                  //             style: const TextStyle(
                                  //                 fontSize: 11,
                                  //                 color: Colors.grey),
                                  //           ),
                                  //         ),
                                  //         const Padding(
                                  //           padding: EdgeInsets.only(
                                  //               top: 4, right: 5),
                                  //           child: Text(
                                  //             "Reviews",
                                  //             style: TextStyle(
                                  //                 fontSize: 11,
                                  //                 color: Colors.grey,
                                  //                 fontFamily: 'Montserrat'),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, left: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rs. ${item.offerPrice.toString()}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Text('Rs. ${item.price.toString()}',
                                            style: const TextStyle(
                                                color: appPrimaryColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
    );
  }
}
