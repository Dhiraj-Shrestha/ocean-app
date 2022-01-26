// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/packages/package.dart';
import 'package:ocean_publication/screens/packages/package_heading.dart';
import 'package:ocean_publication/screens/banner/banner.dart';
import 'package:ocean_publication/screens/banner/banner_heading.dart';
import 'package:ocean_publication/screens/category/category.dart';
import 'package:ocean_publication/screens/products/heading.dart';
import 'package:ocean_publication/screens/products/list.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class HomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<LibraryItems> _listOfBooks = [];
  final _listBanners = [];
  final _listExtraBanners = [];
  final List<LibraryItems> _listOfPackages = [];
  var loading = false;
  SwiperController scollBarController;
  @override
  void initState() {
    _fetchExtraBanners();
    _fetchBookLists();
    _fetchBanners();

    _fetchPackages();
    super.initState();
  }

  // ignore: prefer_void_to_null
  Future<Null> _fetchBookLists() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getAllDataFromHomePage("/homepage");

    var data = jsonDecode(response.body);

    if (data['status']) {
      var bookData = data['data']['books']['data'];
      if (bookData != null) {
        setState(() {
          for (Map i in bookData) {
            _listOfBooks.add(LibraryItems.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  // ignore: prefer_void_to_null
  Future<Null> _fetchBanners() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getAllDataFromHomePage("/homepage");
    var data = jsonDecode(response.body);
    if (data['status']) {
      var banners = data['data']['banner'];
      if (banners != null) {
        setState(() {
          for (Map i in banners) {
            _listBanners.add(NetworkImage(i['image']));
          }
          loading = false;
        });
      }
    }
  }

  // ignore: prefer_void_to_null
  Future<Null> _fetchExtraBanners() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getAllDataFromHomePage("/homepage");
    var data = jsonDecode(response.body);
    if (data['status']) {
      var banners = data['data']['extra_banners'];
      if (banners != null) {
        setState(() {
          for (Map i in banners) {
            _listExtraBanners.add(i['image']);
          }
          scollBarController = SwiperController();
          loading = false;
        });
      }
    }
  }

  // ignore: prefer_void_to_null
  Future<Null> _fetchPackages() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getAllDataFromHomePage("/homepage");
    var data = jsonDecode(response.body);
    if (data['status']) {
      var packages = data['data']['packages']['data'];
      if (packages != null) {
        setState(() {
          for (Map i in packages) {
            _listOfPackages.add(LibraryItems.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          // slider images
          SizedBox(
            height: 200.0,
            child: loading
                ? Center(child: circularProgressIndicator())
                : Carousel(
                    boxFit: BoxFit.cover,
                    images: _listBanners,
                    autoplay: true,
                    animationCurve: Curves.fastOutSlowIn,
                    autoplayDuration: const Duration(milliseconds: 4000),
                    animationDuration: const Duration(milliseconds: 1000),
                    dotSize: 4.0,
                    indicatorBgPadding: 8.0,
                  ),
          ),
          // categories list
          Category(),
          // category wise product heading
          CategoryProductHeading(),
          // Center(child: Text(_LibraryItemss.length.toString())),
          //list of category products
          CategoryWiseProducts(books: _listOfBooks, loading: loading),
          //
          //banner page
          BannerHeading(),
          //banner page

          // SizedBox(
          //   height: 200,
          //   child: loading
          //       ? Center(child: circularProgressIndicator())
          //       : Swiper.children(
          //           autoplay: true,
          //           viewportFraction: 0.7,
          //           scale: 0.8,
          //           pagination: const SwiperPagination(
          //               margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
          //               builder: DotSwiperPaginationBuilder(
          //                   color: Colors.white30,
          //                   activeColor: Colors.white,
          //                   size: 20.0,
          //                   activeSize: 20.0)),
          //           children: _listExtraBanners,
          //         ),
          // ),
          BannerPage(
            banners: _listExtraBanners,
            loading: loading,
            scollBarController: scollBarController,
          ),
          // package heading
          PackageHeading(),
          //  package list
          Package(packages: _listOfPackages, loading: loading),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: appPrimaryColor,
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpeg'),
                  fit: BoxFit.fill,
                ),
              ),
              accountName: const Text("Ocean Publication Pvt. Ltd."),
              accountEmail: const Text("oceanpublication@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 55.0,
                  height: 55.0,
                ),
              ),
            ),
            createDrawerItem(
                icon: Icons.home,
                text: 'Dashboard',
                isSelected: selectedIndex == 0,
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                }),
            createDrawerItem(
                icon: Icons.person,
                text: 'My Profile',
                isSelected: selectedIndex == 1,
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                }),
            createDrawerItem(
                icon: Icons.book_online,
                text: 'Saved Courses',
                isSelected: selectedIndex == 2,
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                }),
            createDrawerItem(
                icon: Icons.person,
                text: 'My Profile',
                isSelected: selectedIndex == 3,
                onTap: () {
                  setState(() {
                    selectedIndex = 3;
                  });
                }),
            createDrawerItem(
                icon: Icons.app_blocking,
                text: 'History',
                isSelected: selectedIndex == 4,
                onTap: () {
                  setState(() {
                    selectedIndex = 4;
                  });
                }),
            createDrawerItem(
                icon: Icons.logout,
                text: 'Logout',
                isSelected: selectedIndex == 5,
                onTap: () {
                  setState(() {
                    selectedIndex = 5;
                  });
                }),
          ],
        ),
      ),
    );
  }

  Widget createDrawerItem(
      {@required IconData icon,
      @required String text,
      @required GestureTapCallback onTap,
      @required bool isSelected}) {
    return Ink(
      color: isSelected ? appPrimaryColor : Colors.transparent,
      child: ListTile(
        selected: true,
        hoverColor: Colors.white,
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.blueAccent,
        ),
        title: isSelected
            ? Text(text,
                style: const TextStyle(
                    color: Colors.white, fontFamily: 'Montserrat'))
            : Text(text, style: const TextStyle(fontFamily: 'Montserrat')),
        onTap: onTap,
      ),
    );
  }
}
