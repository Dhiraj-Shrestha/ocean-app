import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/products/single_product.dart';

class LatestUploads extends StatefulWidget {
  const LatestUploads({Key key}) : super(key: key);

  @override
  _LatestUploadsState createState() => _LatestUploadsState();
}

class _LatestUploadsState extends State<LatestUploads> {
  List<LibraryItems> _book = [];
  List<LibraryItems> _video = [];

  List<LibraryItems> _combine = [];

  Future combine() {
    _combine = _book.take(5).toList() + _video.take(5).toList();
  }

  // ignore: prefer_void_to_null
  Future<Null> fetchBooks() async {
    var response = await CallApi().viewAllBooks('/books');
    var data = jsonDecode(response.body);
    // var response = await CallApi().viewAllBooks("/view-all-books");
    // var data = jsonDecode(response.body);

    if (data['status']) {
      var bookData = data['data'];
      if (bookData != null) {
        setState(() {
          for (Map i in bookData) {
            _book.add(LibraryItems.fromJson(i));
          }
        });
      }
    }
  }

  Future<Null> fetchVideos() async {
    var response = await CallApi().viewAllBooks('/videos');
    var data = jsonDecode(response.body);
    // var response = await CallApi().viewAllBooks("/view-all-books");
    // var data = jsonDecode(response.body);

    if (data['status']) {
      var bookData = data['data'];
      if (bookData != null) {
        setState(() {
          for (Map i in bookData) {
            _video.add(LibraryItems.fromJson(i));
          }
        });
      }
    }
  }

  @override
  void initState() {
    fetchBooks();
    fetchVideos();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: combine(),
            builder: (context, index) {
              return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _combine.length,
                  itemBuilder: (context, index) {
                    var mydata = _combine[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SingleProductPage(libraryItems: mydata)));
                      },
                      child: Card(
                          elevation: 0.1,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: ClipOval(
                                child: Image.network(
                                  mydata.image,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              radius: 20.0,
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(mydata.title),
                            subtitle: Text(
                              'By- ' + mydata.author,
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.grey.shade500),
                            ),
                          )),
                    );
                  });
            }),
      ),
    );
  }
}
