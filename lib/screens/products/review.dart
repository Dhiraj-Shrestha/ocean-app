import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';

import 'package:ocean_publication/models/products/single_page.dart' as feed;
import 'package:ocean_publication/screens/products/related_products/view_all_review.dart';
import 'package:ocean_publication/widgets/rating.dart';

class ReviewPage extends StatefulWidget {
  final String type;
  final String slug;
  final int rating;

  const ReviewPage({
    Key key,
    @required this.type,
    @required this.slug,
    this.rating,
  }) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  final List<feed.Feedback> _listOfRelatedProducts = [];
  List<feed.Feedback> _listOfNewProducts = [];

  bool loading = false;

  // ignore: prefer_void_to_null
  Future<Null> _fetchRelatedReview() async {
    setState(() {
      loading = true;
    });

    var response =
        await CallApi().getAllRelatedReview(widget.type, widget.slug);
    var data = jsonDecode(response.body);

    if (data['status']) {
      // ignore: avoid_print
      var relatedProducts = data['data']['feedbacks'];
      if (relatedProducts != null) {
        setState(() {
          for (Map i in relatedProducts) {
            _listOfRelatedProducts.add(feed.Feedback.fromJson(i));
          }
          _listOfNewProducts = _listOfRelatedProducts.take(5).toList();

          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _fetchRelatedReview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      theme: const ExpandableThemeData(
        iconColor: appPrimaryColor,
        expandIcon: Icons.arrow_left,
      ),
      header: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                  height: 1.5,
                  color: appPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                buildRatingStart(widget.rating),
                Row(
                  children: [
                    Text(
                      _listOfRelatedProducts.length.toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const Text(
                      "Reviews",
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      collapsed: const Text(
        '',
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      expanded: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              color: Colors.black12,
              height: 1.0,
            ),
            loading
                ? const CircularProgressIndicator()
                : _listOfNewProducts.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: Text("No Review Yet"),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: _listOfNewProducts.length,
                        itemBuilder: (context, index) {
                          var mydata = _listOfNewProducts[index];
                          var userdata = mydata.user;
                          return Card(
                            elevation: 0.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: mydata.user.image == null
                                        ? const AssetImage(
                                            'assets/images/profile.jpg',
                                          )
                                        : NetworkImage(userdata.image),
                                  ),
                                  title: Text(userdata.firstName),
                                  trailing: buildRatingStart(mydata.star),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        mydata.review,
                                        textAlign: TextAlign.justify,
                                      )),
                                )
                              ],
                            ),
                          );
                        },
                      ),
            _listOfRelatedProducts.length > 5
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewAllReview(
                                          type: widget.type,
                                          slug: widget.slug,
                                        )));
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.remove_red_eye_rounded,
                                color: appPrimaryColor,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "View All Reviews",
                                style: TextStyle(
                                    color: appPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                    fontFamily: 'Montserrat'),
                              ),
                            ],
                          )),
                    ],
                  )
                : const SizedBox(
                    height: 1,
                  )
          ],
        ),
      ),
    );
  }
}
