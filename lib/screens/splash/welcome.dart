import 'package:flutter/material.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/routes/router_constant.dart';
import 'package:ocean_publication/screens/splash/onboard_design.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key key}) : super(key: key);

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: controller,
        onPageChanged: (value) {
          setState(() {
            slideIndex = value;
          });
        },
        itemCount: onBoardData.length,
        itemBuilder: (context, index) => OnBoardDesign(
          image: onBoardData[index]['image'],
          title: onBoardData[index]['title'],
          details: onBoardData[index]['details'],
        ),
      ),
      bottomSheet: slideIndex != onBoardData.length - 1
          ? Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      controller.animateToPage(onBoardData.length - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    child: const Text(
                      "SKIP",
                      style: TextStyle(
                          color: Color(0xFF0074E4),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < 3; i++)
                        i == slideIndex
                            ? _buildPageIndicator(true)
                            : _buildPageIndicator(false),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      controller.animateToPage(slideIndex + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    child: const Text(
                      "NEXT",
                      style: TextStyle(
                          color: Color(0xFF0074E4),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )
          : InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, landingRoute);
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 6,
                color: appPrimaryColor,
                alignment: Alignment.center,
                child: const Text(
                  "Get Started Now",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }

  List<Map<String, String>> onBoardData = [
    {
      "image": "assets/images/1.png",
      "title": "Search",
      "details":
          "The only thing you absolutely have to know is the location of the library",
    },
    {
      "image": "assets/images/2.png",
      "title": "Order",
      "details":
          "Read the best books first, or you may not have a chance to read them to all."
    },
    {
      "image": "assets/images/1.png",
      "title": "Reading",
      "details":
          "Reading is a conversation. All books talk. But a good book listens as well",
    },
  ];

  int slideIndex = 0;
  PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: 6.0,
      width: isCurrentPage ? 10.0 : 7.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? appPrimaryColor : Colors.grey[300],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    controller = PageController();
  }
}
