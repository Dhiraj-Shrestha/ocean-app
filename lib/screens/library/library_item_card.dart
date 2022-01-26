// ignore_for_file: avoid_print, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:ocean_publication/models/library/data.dart';
import 'package:url_launcher/url_launcher.dart';

class LibraryItemCard extends StatefulWidget {
  final Library library;
  const LibraryItemCard({
    Key key,
    @required this.library,
  }) : super(key: key);

  @override
  _LibraryItemCardState createState() => _LibraryItemCardState();
}

class _LibraryItemCardState extends State<LibraryItemCard> {
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
    Library library = widget.library;
    return Card(
      elevation: 2,
      shadowColor: Colors.black,
      color: const Color(0xFFf6f6f6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () async {
              await openBrowserURL(url: library.link, inApp: true);
            },
            child: Image.network(
              library.image,
              height: 145,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(library.title,
                maxLines: 2,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
