// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/saved_course/card_items.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSaveCourse extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  UserSaveCourse({Key key}) : super(key: key);

  @override
  _UserSaveCourse createState() => _UserSaveCourse();
}

class _UserSaveCourse extends State<UserSaveCourse> {
  final List<LibraryItems> _listOfSaveCourses = [];
  bool loading = false;
  String setToken;
  @override
  void initState() {
    _fetchAllSaveCourses();
    super.initState();
  }

  // ignore: prefer_void_to_null
  Future<Null> _fetchAllSaveCourses() async {
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
        await CallApi().getAllSaveCourse("/get-save-courses", setToken);
    var data = jsonDecode(response.body);
    // developer.log("$data");
    if (data['status']) {
      var saveCourses = data['data'];
      if (saveCourses != null) {
        setState(() {
          for (Map i in saveCourses) {
            _listOfSaveCourses.add(LibraryItems.fromJson(i));
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
            "Save Courses",
            style: TextStyle(fontSize: 17.0),
          ),
        ),
        body: loading
            ? Center(child: circularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 3 / 6.9),
                itemCount: _listOfSaveCourses.length,
                itemBuilder: (BuildContext ctx, index) {
                  final courseItem = _listOfSaveCourses[index];
                  return SaveCourseCardItem(saveCourseItem: courseItem);
                }));
  }
}
