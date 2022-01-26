import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ocean_publication/constants/app_colors.dart';

class SinglePageTapbar extends StatelessWidget {
  final String discription;
  final String tableOfContent;

  const SinglePageTapbar(
      {Key key, @required this.discription, @required this.tableOfContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.white,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Creates border
                  color: appPrimaryColor),
              tabs: const <Widget>[
                Tab(
                  child: Text(
                    'Table of Content',
                    // style: TextStyle(color: Colors.white70),
                  ),
                ),
                Tab(
                  child: Text(
                    'Description',
                    // style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              child: TabBarView(
                physics: const ClampingScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    child: Html(data: tableOfContent),
                  ),
                  SingleChildScrollView(
                      child: Html(shrinkToFit: false, data: discription)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
