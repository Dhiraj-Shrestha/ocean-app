import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class BannerPage extends StatelessWidget {
  final List banners;
  final SwiperController scollBarController;
  final bool loading;

  // ignore: prefer_const_constructors_in_immutables
  BannerPage(
      {Key key,
      @required this.banners,
      @required this.loading,
      @required this.scollBarController})
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
        // : Swiper.children(
        //     autoplay: true,
        //     viewportFraction: 0.7,
        //     scale: 0.8,
        //     pagination: const SwiperPagination(
        //         margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
        //         builder: DotSwiperPaginationBuilder(
        //             color: Colors.white30,
        //             activeColor: Colors.white,
        //             size: 20.0,
        //             activeSize: 20.0)),
        //     children: banners,
        //   ),
        // : SmoothPageIndicator(
        //     // PageController
        //     count: 6,

        //     // forcing the indicator to use a specific direction
        //     textDirection: TextDirection.rtl,
        //     effect: WormEffect(),
        //   ),
        // : Swiper(
        //     controller: scollBarController,
        //     scrollDirection: Axis.horizontal,
        //     itemCount: banners.length,
        //     // control: const SwiperControl(),
        //     itemBuilder: (BuildContext context, int index) {
        //       return SizedBox(
        //         height: 220,
        //         child: Image.network(
        //           banners[index],
        //           fit: BoxFit.fill,
        //         ),
        //       );
        //     },
        //     viewportFraction: 0.8,
        //     scale: 0.9,
        //     pagination: const SwiperPagination(
        //       margin: EdgeInsets.all(5.0),
        //       builder: SwiperPagination.dots,
        //     ),
        //     autoplay: true,
        //     itemWidth: MediaQuery.of(context).size.width - 20,
        //   ),
        );
  }

  Swiper imageSlider({context}) => Swiper.children(
        autoplay: true,
        viewportFraction: 0.7,
        scale: 0.8,
        pagination: const SwiperPagination(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
            builder: DotSwiperPaginationBuilder(
                color: Colors.white30,
                activeColor: Colors.white,
                size: 20.0,
                activeSize: 20.0)),
        children: banners,
      );
}
