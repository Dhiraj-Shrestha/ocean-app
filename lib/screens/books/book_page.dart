// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/products/card_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BookPage({Key key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final List<LibraryItems> _listOfAllBooks = [];
  bool loading = false;
  int currentPage = 1;
  int totalPages;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Future<bool> _fetchBooks({bool isRefresh = false}) async {
    var response = await CallApi().fetchAllBooks(currentPage);
    var data = jsonDecode(response.body);
    if (data['status']) {
      var bookData = data['data'];

      if (isRefresh) {
        setState(() {
          for (Map i in bookData) {
            _listOfAllBooks.add(LibraryItems.fromJson(i));
          }
        });
      } else {
        setState(() {
          for (Map i in bookData) {
            _listOfAllBooks.add(LibraryItems.fromJson(i));
          }
        });
      }
      setState(() {
        currentPage++;
        totalPages = data['meta']['last_page'];
      });

      if (currentPage >= totalPages) {
        refreshController.loadNoData();
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    _fetchBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      onRefresh: () async {
        final result = await _fetchBooks(isRefresh: true);
        if (result) {
          refreshController.refreshCompleted();
        } else {
          refreshController.refreshFailed();
        }
      },
      onLoading: () async {
        final result = await _fetchBooks();
        if (result) {
          refreshController.loadComplete();
        } else {
          refreshController.loadFailed();
        }
      },
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3 / 6.7,
          ),
          itemCount: _listOfAllBooks.length,
          itemBuilder: (BuildContext ctx, index) {
            final book = _listOfAllBooks[index];
            return CardItem(bookItems: book);
          }),
    );
  }
}
