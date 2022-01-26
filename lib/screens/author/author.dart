import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/author/author.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class Author extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Author({Key key}) : super(key: key);
  @override
  _AuthorState createState() => _AuthorState();
}

class _AuthorState extends State<Author> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  bool loading = false;
  final List<AuthorModel> _listOfAuthors = [];

  void _getAuthors() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getAuthors('/authors');
    var data = jsonDecode(response.body);

    if (data['status']) {
      var authors = data['data'];
      if (authors != null) {
        setState(() {
          for (Map i in authors) {
            _listOfAuthors.add(AuthorModel.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _getAuthors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        centerTitle: true,
        title: const Text('Authors'),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/back.svg',
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // ignore: avoid_unnecessary_containers
      body: loading
          ? Center(child: circularProgressIndicator())
          // ignore: avoid_unnecessary_containers
          : Container(
              child: ListView.builder(
                  itemCount: _listOfAuthors.length,
                  itemBuilder: (_, index) {
                    AuthorModel author = _listOfAuthors[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          leading: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                              maxWidth: 64,
                              maxHeight: 64,
                            ),
                            child:
                                Image.network(author.image, fit: BoxFit.cover),
                          ),
                          title: Text(author.name ?? ''),
                          subtitle: Text(author.slug ?? ''),
                          trailing: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      elevation: 16,
                                      // ignore: avoid_unnecessary_containers
                                      child: Container(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            const SizedBox(height: 20),
                                            _buildRow(author.image, author.name,
                                                author.subjects)
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: const Text(
                              'View Profile',
                              style: TextStyle(fontFamily: 'Montserrat'),
                            ),
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: appPrimaryColor,
                                textStyle: const TextStyle(fontSize: 10)),
                          ),
                          onTap: () {},
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  Widget _buildRow(String image, String name, List<String> subjects) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  width: 160.00,
                  height: 200.00,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.fitHeight,
                    ),
                  )),
              const SizedBox(height: 12),
              Text(name,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Subjects',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              // ignore: sized_box_for_whitespace
              Padding(
                padding: const EdgeInsets.all(8.0),
                // ignore: sized_box_for_whitespace
                child: Container(
                    height: 200,
                    width: 200,
                    child: ListView.builder(
                        itemCount: subjects.length,
                        itemBuilder: (_, index) {
                          String subject = subjects[index];
                          return Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 5.0),
                              child: Center(child: Text(subject)),
                            ),
                          );
                        })),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
