// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:ocean_publication/screens/products/single_product.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:ocean_publication/widgets/rating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PackageCardItem extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  final LibraryItems packageItem;
  // ignore: prefer_const_constructors_in_immutables
  PackageCardItem({Key key, @required this.packageItem}) : super(key: key);

  @override
  _PackageCardItemState createState() => _PackageCardItemState();
}

class _PackageCardItemState extends State<PackageCardItem> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  String setToken;
  // ignore: prefer_typing_uninitialized_variables
  var userData;
  bool loading = false;
  FToast fToast;
  showToastMessage() {
    Widget showToast = Container(
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
        child: showToast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2));
  }

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

// add to cart functionality
  addToCart(LibraryItems item) {
    bloc.addToList(item);
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

  // _showFlashMessage(msg) {
  //   final snackbar = SnackBar(
  //     content: Text(msg, style: const TextStyle(color: Colors.white)),
  //     action: SnackBarAction(
  //       label: 'Close',
  //       onPressed: () {
  //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       },
  //     ),
  //   );

  //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  // }

  @override
  void initState() {
    _getUserToken();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    final book = widget.packageItem;
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
                              SingleProductPage(libraryItems: book)));
                },
                child: Image.network(
                    book.image ??
                        'https://oceanpublication.com.np/upload/image_not_found.jpg',
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                  return Image.network(
                      'https://oceanpublication.com.np/upload/book/image/1626433730viber_image_2021-07-16_16-43-40-581.jpg',
                      fit: BoxFit.cover,
                      height: 150);
                }, fit: BoxFit.cover, height: 150)),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Text(
                book.title.split(' ')[0],
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
                        "(${book.rating})",
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  book.offerPrice > 0
                      ? "Rs. ${book.offerPrice.toString()}"
                      : '',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 5.0),
                Text('Rs.${book.price.toString()}',
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
                      addToCart(book);
                      showToastMessage();
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
    if (widget.packageItem != null) {
      var book = widget.packageItem;
      var saveCourseInfo = {
        "courseId": book.id,
        "name": book.type,
      };
      var response =
          await CallApi().saveCourse('/save-course', setToken, saveCourseInfo);
      var data = jsonDecode(response.body);
      if (data['status']) {
        showToast(data['message']);
        setState(() {
          loading = false;
        });
      } else {
        showToast(data['message']);
        setState(() {
          loading = false;
        });
      }
    }
  }
}
