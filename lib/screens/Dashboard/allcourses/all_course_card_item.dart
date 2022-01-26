// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/coming_soon/coming_soon.dart';

import 'package:ocean_publication/screens/video_player/network.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class AllCourseCardItem extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  final LibraryItems allCourseItem;
  // ignore: prefer_const_constructors_in_immutables
  AllCourseCardItem({Key key, @required this.allCourseItem}) : super(key: key);

  @override
  _AllCourseCardItemState createState() => _AllCourseCardItemState();
}

class _AllCourseCardItemState extends State<AllCourseCardItem> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  String setToken;
  // ignore: prefer_typing_uninitialized_variables
  var userData;
  bool loading = false;
  FToast fToast;
  // final bool _isShown = true;

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

  Color colorValue;
  IconData iconData;
  void colorCheck() {
    switch (widget.allCourseItem.type) {
      case 'book':
        {
          colorValue = const Color(0xff750550);
          iconData = Icons.book;
        }
        break;
      case 'video':
        {
          colorValue = const Color(0xff24A19C);
          iconData = Icons.video_call_rounded;
        }
        break;

      default:
        {
          colorValue = appPrimaryColor;
          iconData = FontAwesome5.bell;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    colorCheck();
    fToast = FToast();
    fToast.init(context);
  }

  Future openBrowserURL({
    @required String url,
    bool inApp = false,
  }) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: inApp, forceWebView: inApp, enableJavaScript: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    final saveCourse = widget.allCourseItem;

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
                  navigateFunction();
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
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          child: Center(
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Icon(
                                  iconData,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  saveCourse.type.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(colorValue),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(color: colorValue)))),
                          onPressed: () {
                          
                            navigateFunction();
                          },
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

  void navigateFunction() {
    if (widget.allCourseItem.type == 'book') {
      openBrowserURL(
          url: widget.allCourseItem.book != '' ||
                  widget.allCourseItem.book != null
              ? widget.allCourseItem.book
              : '',
          inApp: true);
    } else if (widget.allCourseItem.type == 'video') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NetworkPlayer(
                  videoPlayerController: VideoPlayerController.network(
                      widget.allCourseItem.videoUrl))));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CoursesUnderPackage(
                    courseUnderPackage: widget.allCourseItem,
                  )));
    }
  }
}
