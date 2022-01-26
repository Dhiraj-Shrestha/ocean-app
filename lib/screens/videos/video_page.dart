// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/products/card_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  VideoPage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<VideoPage> {
  final List<LibraryItems> _listOfVidoes = [];
  var loading = false;
  int currentPage = 1;
  int totalPages;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    _fetchVideos();
    super.initState();
  }

  Future<bool> _fetchVideos({bool isRefresh = false}) async {
    var response = await CallApi().getAllVideos(currentPage);
    var data = jsonDecode(response.body);

    if (data['status']) {
      var videos = data['data'];

      if (isRefresh) {
        setState(() {
          for (Map i in videos) {
            _listOfVidoes.add(LibraryItems.fromJson(i));
          }
        });
      } else {
        setState(() {
          for (Map i in videos) {
            _listOfVidoes.add(LibraryItems.fromJson(i));
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
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      onRefresh: () async {
        final result = await _fetchVideos(isRefresh: true);
        if (result) {
          refreshController.refreshCompleted();
        } else {
          refreshController.refreshFailed();
        }
      },
      onLoading: () async {
        final result = await _fetchVideos();
        if (result) {
          refreshController.loadComplete();
        } else {
          refreshController.loadFailed();
        }
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 3 / 6.5),
        itemCount: _listOfVidoes.length,
        itemBuilder: (BuildContext ctx, index) {
          final book = _listOfVidoes[index];
          return CardItem(bookItems: book);
          // return VideoCardItem(videoItems: book);
        },
      ),
    );
  }
}
