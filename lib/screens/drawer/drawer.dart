import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/category/category_childs.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/books/category_wise_books.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ComplexDrawer extends StatefulWidget {
  int currentIndex;
  // ignore: prefer_const_constructors_in_immutables
  ComplexDrawer({Key key, this.currentIndex}) : super(key: key);

  @override
  _ComplexDrawerState createState() => _ComplexDrawerState();
}

class _ComplexDrawerState extends State<ComplexDrawer> {
  int selectedIndex = -1; //dont set it to 0
  bool isExpanded = true;
  bool loading = false;
  bool cateogryWiseProductLoading = false;
  String setToken;
  String type;
  final List<CategoryWithChilds> _listOfCategoryChilds = [];
  final List<LibraryItems> _listOfAllBooks = [];
  final List<LibraryItems> _listOfAllVidoes = [];
  // ignore: prefer_void_to_null
  Future<Null> _fetchCategoryWithChilds() async {
    setState(() {
      loading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('token');
    if (token != null || token != '') {
      setState(() {
        setToken = token;
      });
    }
    var response =
        await CallApi().fetchAllCategoriesWithItsChild("/categories", setToken);

    var data = jsonDecode(response.body);
    if (data['status']) {
      var parentCategories = data['data'];
      if (parentCategories != null) {
        setState(() {
          for (Map i in parentCategories) {
            _listOfCategoryChilds.add(CategoryWithChilds.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  // ignore: prefer_void_to_null
  Future<Null> _fetchCategoryWiseProducts(type, slug) async {
    if (type == 'book') {
      setState(() {
        cateogryWiseProductLoading = true;
      });
      var response = await CallApi().fetchProductByCategory(
          'https://oceanpublication.com.np/api/category/$type/$slug');
      var data = jsonDecode(response.body);
      var bookData = data['data']['books'];
      if (bookData != null) {
        setState(() {
          for (Map i in bookData) {
            _listOfAllBooks.add(LibraryItems.fromJson(i));
          }
          cateogryWiseProductLoading = false;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryWiseBooks(
                    listOfData: _listOfAllBooks,
                    loading: cateogryWiseProductLoading)));
      }
    } else if (type == 'video') {
      var response = await CallApi().fetchProductByCategory(
          'https://oceanpublication.com.np/api/category/$type/$slug');
      var data = jsonDecode(response.body);
      var videoData = data['data']['videos'];
      if (videoData != null) {
        setState(() {
          for (Map i in videoData) {
            _listOfAllVidoes.add(LibraryItems.fromJson(i));
          }
          cateogryWiseProductLoading = false;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryWiseBooks(
                    listOfData: _listOfAllVidoes,
                    loading: cateogryWiseProductLoading)));
      }

      //developer.log('$data');
    }
  }

  void _selectType(int index) {
    switch (index) {
      case 1:
        setState(() {
          type = 'book';
        });
        break;
      case 2:
        setState(() {
          type = 'video';
        });
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategoryWithChilds();
    _selectType(widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // ignore: sized_box_for_whitespace
    return Container(
      width: width,
      child: row(),
    );
  }

  Widget row() {
    return Row(children: [
      isExpanded ? blackIconTiles() : blackIconMenu(),
      invisibleSubMenus(),
    ]);
  }

  Widget blackIconTiles() {
    return Container(
      width: 230,
      color: const Color(0xff11111d),
      child: Column(
        children: [
          controlTile(),
          Expanded(
            child: loading
                ? Center(child: smallCircularProgressIndicator())
                : ListView.builder(
                    itemCount: _listOfCategoryChilds.length,
                    itemBuilder: (BuildContext context, int index) {
                      //  if(index==0) return controlTile();

                      CategoryWithChilds categoryWithChilds =
                          _listOfCategoryChilds[index];
                      bool selected = selectedIndex == index;
                      return ExpansionTile(
                          onExpansionChanged: (z) {
                            setState(() {
                              selectedIndex = z ? index : -1;
                            });
                          },
                          //  leading: const Icon(Icons.home_filled, color: Colors.white),
                          title: Text(
                            categoryWithChilds.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: categoryWithChilds.childs.isEmpty
                              ? null
                              : Icon(
                                  selected
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                          children: categoryWithChilds.childs.map((subMenu) {
                            return sMenuButton(subMenu, false);
                          }).toList());
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget controlTile() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: ListTile(
        leading: Image.asset('assets/images/logo.png', width: 50, height: 50),
        title: const Text(
          "Ocean Publication",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget blackIconMenu() {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: 100,
      color: const Color(0xff11111d),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _listOfCategoryChilds.length,
                itemBuilder: (contex, index) {
                  // if(index==0) return controlButton();
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      child: const Icon(Icons.title, color: Colors.white),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget invisibleSubMenus() {
    // List<CDM> _cmds = cdms..removeAt(0);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: isExpanded ? 0 : 125,
      color: const Color(0xffe3e9f7),
      child: Column(
        children: [
          Container(height: 95),
          Expanded(
            child: ListView.builder(
                itemCount: _listOfCategoryChilds.length,
                itemBuilder: (context, index) {
                  CategoryWithChilds categoryWithChilds =
                      _listOfCategoryChilds[index];
                  // if(index==0) return Container(height:95);
                  //controll button has 45 h + 20 top + 30 bottom = 95

                  bool selected = selectedIndex == index;
                  bool isValidSubMenu =
                      selected && categoryWithChilds.childs.isNotEmpty;
                  return subMenuWidget(
                      categoryWithChilds.childs, isValidSubMenu);
                }),
          ),
        ],
      ),
    );
  }

  Widget subMenuWidget(List<Childs> submenus, bool isValidSubMenu) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: isValidSubMenu ? submenus.length.toDouble() * 37.5 : 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: isValidSubMenu ? appPrimaryColor : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          )),
      child: ListView.builder(
          padding: const EdgeInsets.all(6),
          itemCount: isValidSubMenu ? submenus.length : 0,
          itemBuilder: (context, index) {
            Childs subMenu = submenus[index];
            return sMenuButton(subMenu, index == 0);
          }),
    );
  }

  Widget sMenuButton(Childs subMenu, bool isTitle) {
    return InkWell(
      onTap: () {
        //handle the function
        // ignore: unnecessary_string_interpolations
        // developer.log('${subMenu.slug}');
        switch (type) {
          case 'book':
            _fetchCategoryWiseProducts(type, subMenu.slug);
            break;
          case 'video':
            _fetchCategoryWiseProducts(type, subMenu.slug);
            break;
          default:
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          subMenu.title.toString(),
          style: TextStyle(
            fontSize: isTitle ? 17 : 14,
            color: isTitle ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
