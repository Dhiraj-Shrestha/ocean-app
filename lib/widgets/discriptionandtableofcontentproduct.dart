import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ocean_publication/constants/app_colors.dart';

class Discription extends StatelessWidget {
  final String title;
  final String discription;

  const Discription({Key key, this.title, this.discription}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        // height: 205.0,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: const Color(0xFF656565).withOpacity(0.15),
            blurRadius: 1.0,
            spreadRadius: 0.2,
          )
        ]),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      height: 1.5,
                      color: appPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                color: Colors.black12,
                height: 1.0,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
                child: Html(data: discription),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
