import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';

import 'package:ocean_publication/models/products/single_page.dart' as feed;
import 'package:ocean_publication/widgets/rating.dart';

class ViewAllReview extends StatefulWidget {
    final String type;
  final String slug;
  const ViewAllReview({Key key, @required this.type, @required this.slug}) : super(key: key);

 

  @override
  _ViewAllReviewState createState() => _ViewAllReviewState();
}

class _ViewAllReviewState extends State<ViewAllReview> {

   final List<feed.Feedback> _listOfrelatedProducts = [];
  bool loading = false;


  Future _fetchRelatedReview() async {
    setState(() {
      loading = true;
    });

    if (widget.type != '' && widget.slug != '') {
      var response =
          await CallApi().getAllRelatedReview(widget.type, widget.slug);
      var data = jsonDecode(response.body);

      if (data['status']) {
        // ignore: avoid_print
        var relatedProducts = data['data']['feedbacks'];
        if (relatedProducts != null) {
          setState(() {
            for (Map i in relatedProducts) {
              _listOfrelatedProducts.add(feed.Feedback.fromJson(i));
            }
            loading = false;
          });
        }
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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child: 
      ListView.builder(
              shrinkWrap: true,
              itemCount: _listOfrelatedProducts.length,
              itemBuilder: (context, index) {
                var mydata = _listOfrelatedProducts[index];
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
            ),),

      
    );
  }
}