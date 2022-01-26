import 'package:flutter/material.dart';
import 'package:ocean_publication/screens/home/homepage.dart';
import 'package:ocean_publication/screens/landing_page/landing_page.dart';
import 'package:ocean_publication/screens/products/view_all.dart';
import 'package:ocean_publication/screens/splash/splash_screen.dart';
import 'package:ocean_publication/screens/splash/welcome.dart';

import 'router_constant.dart';

class Routers {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case viewAll:
        return MaterialPageRoute(builder: (_) => BookViewAll());
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => const Welcome());
      case landingRoute:
        return MaterialPageRoute(builder: (_) => const LandingPage());

      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
