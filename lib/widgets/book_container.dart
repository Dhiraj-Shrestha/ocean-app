import 'package:flutter/material.dart';
import 'package:ocean_publication/constants/app_colors.dart';

class BookContainer extends StatelessWidget {
  final Function onTap;
  final String bookImage;
  final String bookTitle;
  final String bookAuthor;
  final String bookOfferPrice;
  final String bookPrice;

  const BookContainer(
      {Key key,
      @required this.onTap,
      @required this.bookImage,
      @required this.bookTitle,
      @required this.bookAuthor,
      @required this.bookOfferPrice,
      @required this.bookPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
      child: GestureDetector(
        onTap: onTap
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             SingleProductPage(libraryItems: book)));
        ,
        child: SizedBox(
          width: 152,
          child: Card(
            elevation: 2,
            shadowColor: Colors.black,
            color: const Color(0xFFf6f6f6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  bookImage,
                  fit: BoxFit.fill,
                  height: 180.0,
                  width: 140.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, left: 5.0),
                  child: Text(
                    bookTitle,
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
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: Text(
                        bookAuthor.split(',')[0],
                        style: const TextStyle(
                            color: appSecondaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rs. $bookOfferPrice',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text('Rs. $bookPrice',
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
      ),
    );
  }
}
