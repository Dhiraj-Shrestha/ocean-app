// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/products/single_product.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SaveCourseCardItem extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  final LibraryItems saveCourseItem;
  // ignore: prefer_const_constructors_in_immutables
  SaveCourseCardItem({Key key, @required this.saveCourseItem})
      : super(key: key);

  @override
  _SaveCourseCardItemState createState() => _SaveCourseCardItemState();
}

class _SaveCourseCardItemState extends State<SaveCourseCardItem> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  String setToken;
  // ignore: prefer_typing_uninitialized_variables
  var userData;
  bool loading = false;
  FToast fToast;
  bool _isShown = true;

  showToast(msg) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: Colors.white),
          const SizedBox(
            width: 12.0,
          ),
          Text(msg, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    final saveCourse = widget.saveCourseItem;

    return Padding(
      padding:
          const EdgeInsets.only(top: 1.0, left: 2.0, right: 2.0, bottom: 1.0),
      child: Container(
        child: Card(
          elevation: 2,
          shadowColor: Colors.black,
          color: const Color(0xFFf6f6f6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SingleProductPage(libraryItems: saveCourse)));
                },
                child: Image.network(
                  saveCourse.image ??
                      'https://oceanpublication.com.np/upload/image_not_found.jpg',
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Image.network(
                      'https://oceanpublication.com.np/upload/book/image/1626433730viber_image_2021-07-16_16-43-40-581.jpg',
                    );
                  },
                  height: 150,
                  width: 150,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: Text(
                  saveCourse.title,
                  maxLines: 2,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: appPrimaryColor),
                ),
              ),
              const SizedBox(height: 5.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, top: 4, right: 4),
                        child: Text(
                          "(${saveCourse.rating})",
                          style:
                              const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 4,
                          right: 5,
                        ),
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                      top: 4,
                      right: 5,
                    ),
                    child: Text('Rs. ${saveCourse.price.toString()}',
                        style: const TextStyle(
                            color: appPrimaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.remove_red_eye,
                                  size: 15.0,
                                ),
                                const SizedBox(
                                  width: 3.0,
                                ),
                                Text(
                                  "View".toUpperCase(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: const BorderSide(
                                            color: Colors.red)))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingleProductPage(
                                          libraryItems: saveCourse)));
                            }),
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      loading
                          ? Center(child: smallCircularProgressIndicator())
                          : SizedBox(
                              width: 35.0,
                              height: 33.0,
                              child: Center(
                                child: TextButton(
                                  child: const Icon(
                                    delete,
                                    color: Colors.redAccent,
                                    size: 22.0,
                                  ),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: const BorderSide(
                                                  color: Colors.red)))),
                                  onPressed: () {
                                    _isShown ? _delete(context) : null;
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // delete item-----
  void _delete(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to remove the item ?'),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () {
                  setState(() {
                    _isShown = true;
                    Navigator.of(context).pop();
                  });
                  _handleDelete();
                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text("Item remove from the cart")));

                  developer.log('delete from item');
                },
                child: const Text('Yes'),
                isDefaultAction: true,
                isDestructiveAction: true,
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  developer.log('cancel');
                },
                child: const Text('No'),
                isDefaultAction: false,
                isDestructiveAction: false,
              )
            ],
          );
        });
  }

  _handleDelete() async {
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
    if (widget.saveCourseItem != null) {
      var data = {
        "course_id": widget.saveCourseItem.id,
        "name": widget.saveCourseItem.type,
      };

      var response =
          await CallApi().deleteSaveCourse('/delete-course', setToken, data);
      var body = jsonDecode(response.body);
      if (body['status']) {
        // developer.log("$body");
        showToast(body['message']);
      } else {
        showToast(body['message']);
        //  developer.log("$body");
      }
      setState(() {
        loading = false;
      });

      Navigator.pop(context); // pop current page
    }
  }
}
