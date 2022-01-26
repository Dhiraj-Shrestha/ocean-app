import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/library/data.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:ocean_publication/screens/auth/register.dart';
import 'package:ocean_publication/screens/cart/cart_page.dart';
import 'package:ocean_publication/screens/library/library_item_card.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'dart:developer' as developer;

class LibraryViewAll extends StatefulWidget {
  const LibraryViewAll({Key key}) : super(key: key);

  @override
  _LibraryViewAllState createState() => _LibraryViewAllState();
}

class _LibraryViewAllState extends State<LibraryViewAll> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();


  // ignore: prefer_typing_uninitialized_variables
  var userData;
  final List<Library> _listOfLibraryBooks = [];
  bool loading = false;
  int currentPage = 1;
  int totalPages;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Future<bool> _fetchAllLibrary({bool isRefresh = false}) async {
    var response = await CallApi().fetchAllLibraryBooks(currentPage);
    var data = jsonDecode(response.body);
    if (data['status']) {
      var bookData = data['data'];

      if (isRefresh) {
        setState(() {
          for (Map i in bookData) {
            _listOfLibraryBooks.add(Library.fromJson(i));
          }
        });
      } else {
        setState(() {
          for (Map i in bookData) {
            _listOfLibraryBooks.add(Library.fromJson(i));
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
    _fetchAllLibrary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/back.svg',
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              onPressed: () {
                developer.log('cart page goes here...');
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
          const SizedBox(width: 5.0),
          userData == null
              ? PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: const Text("Sign In")),
                    ),
                    PopupMenuItem(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: const Text("Sign Up"),
                      ),
                    ),
                  ],
                )
              : Container(),
          const SizedBox(width: 20.0 / 2)
        ],
      ),
      body: SmartRefresher(
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
    );
  }
}
