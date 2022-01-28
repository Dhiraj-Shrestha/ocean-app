import 'package:flutter/material.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class BannerPage extends StatelessWidget {
  final List banners;
  final bool loading;

  // ignore: prefer_const_constructors_in_immutables
  BannerPage(
      {Key key,
      @required this.banners,
      @required this.loading,
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return SizedBox(
        height: 150,
        width: double.infinity,
        child: loading
            ? Center(child: circularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 6.0, top: 2.0, bottom: 2.0),
                    child: Image.network(
                      banners[index],
                      fit: BoxFit.fitWidth,
                    ),
                  );
                })
        );
  }

}
