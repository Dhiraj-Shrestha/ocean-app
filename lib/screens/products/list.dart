import 'package:flutter/material.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/products/single_product.dart';
import 'package:ocean_publication/widgets/book_container.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';


// ignore: must_be_immutable
class CategoryWiseProducts extends StatefulWidget {
  List<LibraryItems> books;
  bool loading;

  CategoryWiseProducts({Key key, @required this.books, @required this.loading})
      : super(key: key);

  @override
  _CategoryWiseProductsState createState() => _CategoryWiseProductsState();
}

class _CategoryWiseProductsState extends State<CategoryWiseProducts> {
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
              itemCount: widget.books.length,
              itemBuilder: (_, index) {
                final book = widget.books[index];

                return BookContainer(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SingleProductPage(libraryItems: book),
                      ),
                    );
                  },
                  bookImage: book.image,
                  bookTitle: book.title,
                  bookAuthor: book.author,
                  bookOfferPrice: book.offerPrice.toString(),
                  bookPrice: book.price.toString(),
                );
              },
            ),
    );
  }
}
