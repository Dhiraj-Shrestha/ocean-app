import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ocean_publication/routes/router_constant.dart';
// import 'package:new_project_work/ui_pages/forgot_password.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoggedIn = false;

  void _checkIfUserIsLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  void initState() {
    _checkIfUserIsLoggedIn();
    Timer(
        const Duration(seconds: 3),
        () => {
              _isLoggedIn
                  ? Navigator.pushNamed(context, landingRoute)
                  : Navigator.pushNamed(context, welcomeRoute),
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.white],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
        ),
        child: const Center(
          child: Image(
            height: 200,
            width: 200,
            image: AssetImage("assets/images/oceanlogo.png"),
          ),
        ),
      ),
    );
  }
}
