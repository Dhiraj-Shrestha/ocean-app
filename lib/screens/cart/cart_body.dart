// ignore_for_file: avoid_unnecessary_containers
import 'dart:developer' as developer;
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/products/single_product.dart';

class CartBody extends StatefulWidget {
  final List<LibraryItems> items;
  // ignore: use_key_in_widget_constructors
  const CartBody(this.items);

  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  bool _isShown = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 25, 0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "My Cart",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            flex: 1,
            child: widget.items.isNotEmpty ? itemList() : noItemInContainer(),
          ),
          // const Expanded(flex: 1, child: Text('2'))
        ],
      ),
    );
  }

  Container noItemInContainer() {
    return Container(
      child: Center(
        child: Text(
          "No More Items Left In The Cart",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              fontSize: 20),
        ),
      ),
    );
  }

  ListView itemList() {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        LibraryItems book = widget.items[index];
        return Card(
          elevation: 10, // Change this
          shadowColor: Colors.black26, // Change this
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SingleProductPage(libraryItems: book)));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        book.image,
                        fit: BoxFit.fitHeight,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                            children: [
                              TextSpan(
                                text: book.title,
                              ),
                            ]),
                      ),
                      const SizedBox(height: 5.0),
                      Text('Rs. ${book.quantity * book.price}',
                          style: const TextStyle(
                              color: appPrimaryColor,
                              fontSize: 13,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5.0),
                      TextButton(
                        child: const Text('Remove',
                            style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.redAccent,
                          onSurface: Colors.grey,
                        ),
                        onPressed: () {
                          //   developer.log('delete icon');
                          _isShown ? _delete(context, book) : null;
                        },
                      ),
                    ],
                  ),

                  // const SizedBox(width: 5.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// delete item-----
  void _delete(BuildContext context, LibraryItems currentItem) {
    final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to remove the item ?'),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () {
                  setState(() {
                    _isShown = true;
                    Navigator.of(context).pop();
                  });

                  bloc.removeFromList(currentItem);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Item remove from the cart")));

                  //   developer.log('delete from item');
                },
                child: const Text('Yes'),
                isDefaultAction: true,
                isDestructiveAction: true,
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  developer.log('cancel');
                },
                child: const Text('No'),
                isDefaultAction: false,
                isDestructiveAction: false,
              )
            ],
          );
        });
  }
}
