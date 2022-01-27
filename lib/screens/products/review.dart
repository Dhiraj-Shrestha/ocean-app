import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';

import 'package:ocean_publication/models/products/single_page.dart' as feed;
import 'package:ocean_publication/routes/router_constant.dart';
import 'package:ocean_publication/screens/products/related_products/view_all_review.dart';
import 'package:ocean_publication/widgets/rating.dart';

import 'package:rating_dialog/rating_dialog.dart';

class ReviewPage extends StatefulWidget {
  final String type;
  final String slug;

  const ReviewPage({
    Key key,
    @required this.type,
    @required this.slug,
  }) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('Give Product Review'),
  //           content: Form(
  //             key: _formKey,
  //             child: Padding(
  //               padding: const EdgeInsets.only(top: 7.0, bottom: 5.0),
  //               child: FormBuilderTextField(
  //                 name: 'Feedback',
  //                 decoration: InputDecoration(
  //                   labelText: 'Feedback',
  //                   focusColor: appPrimaryColor,
  //                   focusedBorder: OutlineInputBorder(
  //                     borderSide:
  //                         const BorderSide(width: 0.2, color: appPrimaryColor),
  //                     borderRadius: BorderRadius.circular(12.0),
  //                   ),
  //                   fillColor: appPrimaryColor,
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(12.0),
  //                     borderSide: const BorderSide(),
  //                   ),
  //                 ),
  //                 // validator:,

  //                 // validator: FormBuilderValidators.compose([
  //                 //   FormBuilderValidators.required(context,
  //                 //       errorText: kDescriptionNullError),
  //                 // ]),
  //                 autovalidateMode: AutovalidateMode.disabled,
  //                 maxLines: 3,
  //                 maxLength: 100,
  //                 keyboardType: TextInputType.multiline,
  //                 controller: _textFieldController,
  //               ),
  //             ),
  //           ),
  //           // content: TextField(
  //           //   onChanged: (value) {
  //           //     setState(() {
  //           //       valueText = value;
  //           //     });
  //           //   },
  //           //   controller: _textFieldController,
  //           //   decoration: InputDecoration(hintText: "Feedback"),
  //           // ),
  //           actions: <Widget>[
  //             FlatButton(
  //               color: Colors.grey,
  //               textColor: Colors.white,
  //               child: const Text('CANCEL'),
  //               onPressed: () {
  //                 setState(() {
  //                   Navigator.pop(context);
  //                 });
  //               },
  //             ),
  //             FlatButton(
  //               color: appPrimaryColor,
  //               textColor: Colors.white,
  //               child: const Text('Post'),
  //               onPressed: () async {
  //                 if (_formKey.currentState.validate()) {
  //                   Map data = {
  //                     "product_id": widget.mydata['id'],
  //                     "comment": _textFieldController.text
  //                   };
  //                   // var response = await Api().postData(data, 'review');

  //                   // var result = jsonDecode(response.body);
  //                   // if (result['code'] == 200) {
  //                   //   _textFieldController.text = '';
  //                   //   FocusScopeNode currentFocus = FocusScope.of(context);
  //                   //   if (!currentFocus.hasPrimaryFocus) {
  //                   //     currentFocus.unfocus();
  //                   //   }
  //                   //   Navigator.pop(context);

  //                   //   print("success");
  //                   //   // showInSnackBar(context, 'Thank You for review');
  //                   // } else {
  //                   //   print("fail");
  //                   // }
  //                   // showInSnackBar(context, 'Thank You for review');

  //                   // Navigator.pop(context);
  //                 }
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  List<feed.Feedback> _listOfrelatedProducts = [];
  bool loading = false;

  // ignore: prefer_void_to_null
  Future<Null> _fetchRelatedReview() async {
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
            _listOfrelatedProducts = _listOfrelatedProducts.take(5).toList();
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
    return SingleChildScrollView(
        child: Column(children: [
      const Divider(
        color: Colors.black12,
        height: 1.0,
      ),
      loading
          ? const CircularProgressIndicator()
          :

          // ListView.builder(itemBuilder: (conext, index) {
          //   shr
          //   return Text("hlw");
          // }),

          _listOfrelatedProducts.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Center(child: Text("No Review Yet")),
                )
              : ListView.builder(
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
                ),
      _listOfrelatedProducts.length > 3
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
    ]));
  }
}
