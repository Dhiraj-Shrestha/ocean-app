import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/constants/app_colors.dart';

class OnBoardDesign extends StatelessWidget {
  const OnBoardDesign({
    Key key,
    this.title,
    this.details,
    this.image,
  }) : super(key: key);
  final String title, details, image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                image,
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: title == null
                    ? null
                    : Text(
                        title,
                        style: headingStyle,
                      ),
              ),
              Center(
                child: details == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        child: Text(
                          details,
                          style: greyStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
