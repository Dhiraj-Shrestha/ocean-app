import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:ocean_publication/screens/auth/register.dart';
import 'package:ocean_publication/screens/cart/cart_page.dart';
import 'package:ocean_publication/screens/products/card_item.dart';
import 'dart:developer' as developer;
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageViewAll extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  PackageViewAll({Key key}) : super(key: key);

  @override
  _PackageViewAllState createState() => _PackageViewAllState();
}

class _PackageViewAllState extends State<PackageViewAll> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  final List<LibraryItems> _listOfAllPackages = [];
  var loading = false;
  // ignore: prefer_typing_uninitialized_variables
  var userData;

  @override
  void initState() {
    fetchPackages();
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    if (userJson != null) {
      var user = jsonDecode(userJson);
      setState(() {
        userData = user;
      });
    }
  }

  // ignore: prefer_void_to_null
  Future<Null> fetchPackages() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().viewAllPackages("/view-all-packages");
    var data = jsonDecode(response.body);

    if (data['status']) {
      var packageData = data['data'];
      if (packageData != null) {
        setState(() {
          for (Map i in packageData) {
            _listOfAllPackages.add(LibraryItems.fromJson(i));
          }
          loading = false;
        });
      }
    }
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
      body: loading
          ? Center(child: circularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 3 / 7),
              itemCount: _listOfAllPackages.length,
              itemBuilder: (BuildContext ctx, index) {
                final package = _listOfAllPackages[index];
                return CardItem(bookItems: package);
                // return PackageCardItem(packageItem: package);
              }),
    );
  }
}
