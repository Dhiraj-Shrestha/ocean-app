// ignore_for_file: avoid_unnecessary_containers
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/screens/library/library_item_card.dart';
import 'package:ocean_publication/models/library/data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LibraryPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LibraryPage({Key key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<Library> _listOfLibraryBooks = [];
  var loading = false;
  int currentPage = 1;
  int totalPages;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  @override
  void initState() {
    _fetchAllLibrary();
    super.initState();
  }

  Future<bool> _fetchAllLibrary({bool isRefresh = false}) async {
    var response = await CallApi().fetchAllLibraryBooks(currentPage);
    var data = jsonDecode(response.body);
    if (data['status']) {
      var libraries = data['data'];
      if (isRefresh) {
        setState(() {
          for (Map video in libraries) {
            _listOfLibraryBooks.add(Library.fromJson(video));
          }
        });
      } else {
        setState(() {
          for (Map video in libraries) {
            _listOfLibraryBooks.add(Library.fromJson(video));
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SmartRefresher(
              controller: refreshController,
              enablePullUp: true,
              onRefresh: () async {
                final result = await _fetchAllLibrary(isRefresh: true);
                if (result) {
                  refreshController.refreshCompleted();
                } else {
                  refreshController.refreshFailed();
                }
              },
              onLoading: () async {
                final result = await _fetchAllLibrary();
                if (result) {
                  refreshController.loadComplete();
                } else {
                  refreshController.loadFailed();
                }
              },
              child: GridView.builder(
                itemCount: _listOfLibraryBooks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 5,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) =>
                    LibraryItemCard(library: _listOfLibraryBooks[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
