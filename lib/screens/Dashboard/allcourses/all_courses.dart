// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/dashboard/allcourses/all_course_card_item.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAllCourses extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  UserAllCourses({Key key}) : super(key: key);

  @override
  _UserAllCourses createState() => _UserAllCourses();
}

class _UserAllCourses extends State<UserAllCourses> {
  final List<LibraryItems> _listOfUserCourses = [];
  bool loading = false;
  String setToken;
  @override
  void initState() {
    _fetchUserAllCourses();
    super.initState();
  }

  // ignore: prefer_void_to_null
  Future<Null> _fetchUserAllCourses() async {
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
    var response = await CallApi().getAllCourse("/all-course", setToken);
    var data = jsonDecode(response.body);
    print(data);
    // developer.log("$data");
    if (data['status']) {
      var allcourses = data['data'];
      if (allcourses != null) {
        setState(() {
          for (Map i in allcourses) {
            _listOfUserCourses.add(LibraryItems.fromJson(i));
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
          centerTitle: true,
          elevation: 0.7,
          title: const Text(
            "Buyed Courses",
            style: TextStyle(fontSize: 17.0),
          ),
        ),
        body: loading
            ? Center(child: circularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 3 / 6),
                itemCount: _listOfUserCourses.length,
                itemBuilder: (BuildContext ctx, index) {
                  final courseItem = _listOfUserCourses[index];
                  return AllCourseCardItem(allCourseItem: courseItem);
                }));
  }
}
