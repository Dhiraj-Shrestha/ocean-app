// ignore_for_file: avoid_print
import 'dart:developer' as developer;
import 'package:badges/badges.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/cart/cart_page.dart';
import 'package:ocean_publication/screens/products/card_item.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class CategoryWiseBooks extends StatefulWidget {
  final bool loading;
  final List<LibraryItems> listOfData;
  // ignore: prefer_const_constructors_in_immutables
  CategoryWiseBooks({Key key, this.loading, this.listOfData}) : super(key: key);

  @override
  _CategoryWiseBooksState createState() => _CategoryWiseBooksState();
}

class _CategoryWiseBooksState extends State<CategoryWiseBooks> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listOfData.isEmpty) {
      // ignore: sized_box_for_whitespace
      return Scaffold(
          appBar: AppBar(
            backgroundColor: appPrimaryColor,
            elevation: 0,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/images/back.svg',
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: const Center(
              child: Text('No Books Available...',
                  style: TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.w600))));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/back.svg',
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            widget.listOfData.clear();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                developer.log('search goes here...');
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          StreamBuilder<List<LibraryItems>>(
            stream: bloc.listStream,
            builder: (context, snapshot) {
              List<LibraryItems> items = snapshot.data;
              int length = items != null ? items.length : 0;
              return Center(
                child: InkWell(
                  onTap: () {
                    developer.log('cart page goes here...');
                    if (length > 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartPage()));
                    } else {
                      return;
                    }
                  },
                  child: Badge(
                    badgeColor: Colors.white,
                    badgeContent: Text(length.toString(),
                        style: const TextStyle(color: Colors.black)),
                    animationType: BadgeAnimationType.scale,
                    animationDuration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: widget.loading
          ? Center(child: circularProgressIndicator())
          : GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 3 / 6.56),
              itemCount: widget.listOfData.length,
              itemBuilder: (BuildContext ctx, index) {
                final book = widget.listOfData[index];
                return CardItem(bookItems: book);
              }),
    );
  }
}
