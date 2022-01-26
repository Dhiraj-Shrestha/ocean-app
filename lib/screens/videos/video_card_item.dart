// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:ocean_publication/screens/products/single_product.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:ocean_publication/widgets/rating.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoCardItem extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  final LibraryItems videoItems;
  // ignore: prefer_const_constructors_in_immutables
  VideoCardItem({Key key, @required this.videoItems}) : super(key: key);

  @override
  _VideoCardItemState createState() => _VideoCardItemState();
}

class _VideoCardItemState extends State<VideoCardItem> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  String setToken;
  var userData;
  bool loading = false;
   FToast fToast;

// add to cart functionality
  addToCart(LibraryItems item) {
    bloc.addToList(item);
  }
  
  showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: bloc.provider.isPresent == false ? Colors.green : Colors.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              bloc.provider.isPresent == false
                  ? Icons.check
                  : Icons.contact_mail_rounded,
              color: Colors.white),
          const SizedBox(
            width: 12.0,
          ),
          Text(
              bloc.provider.isPresent == false
                  ? "Added To Cart"
                  : 'Already added in cart',
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void _getUserToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var userInfo = localStorage.getString('user');

    if (token != '' || token != null) {
      setState(() {
        setToken = token;
      });
    }

    if (userInfo != null) {
      setState(() {
        userData = jsonDecode(userInfo);
      });
    }
  }

  _showFlashMessage(msg) {
    final snackbar = SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  void initState() {
    _getUserToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    final video = widget.videoItems;
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SingleProductPage(libraryItems: video)));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                        child: Image.network(
                      video.image ??
                          'https://oceanpublication.com.np/upload/image_not_found.jpg',
                    )),
                    Icon(Icons.play_circle_outline_rounded,
                        size: 50, color: Colors.red[200])
                  ],
                )),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Text(
                video.title.split(' ')[0],
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
                Padding(
                    padding: const EdgeInsets.only(top: 4, left: 5, right: 5),
                    child: buildRatingStart(5)),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 4, right: 4),
                      child: Text(
                        "(${video.rating})",
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4, right: 5),
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
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Rs. ${video.offerPrice.toString()}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 5.0),
                Text('Rs.${video.price.toString()}',
                    style: const TextStyle(
                        color: appPrimaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 5.0),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                height: 30,
                width: 100,
                child: TextButton(
                    child: Text("Add to cart".toUpperCase(),
                        style: const TextStyle(fontSize: 10)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(5)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side:
                                        const BorderSide(color: Colors.red)))),
                    onPressed: () {
                      addToCart(video);
                      showToast();
                    }),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                    child: loading
                        ? Center(child: smallCircularProgressIndicator())
                        : Text("Save".toUpperCase(),
                            style: const TextStyle(fontSize: 10)),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side:
                                        const BorderSide(color: Colors.red)))),
                    onPressed: () => {
                          setToken != null
                              ? _saveParticularCourse()
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()))
                        }),
              )
            ])
          ],
        ),
      ),
    );
  }

  Future<void> _saveParticularCourse() async {
    setState(() {
      loading = true;
    });
    if (widget.videoItems != null) {
      var video = widget.videoItems;
      var saveCourseInfo = {
        "courseId": video.id,
        "name": video.type,
      };
      var response =
          await CallApi().saveCourse('/save-course', setToken, saveCourseInfo);
      var data = jsonDecode(response.body);
      if (data['status']) {
        _showFlashMessage(data['message']);
        setState(() {
          loading = false;
        });
      } else {
        _showFlashMessage(data['message']);
        setState(() {
          loading = false;
        });
      }
    }
  }
}
