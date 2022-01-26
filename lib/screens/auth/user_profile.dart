// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/screens/Dashboard/latest_upload.dart';
import 'package:ocean_publication/screens/auth/forgot_password/reset_password_form.dart';
import 'package:ocean_publication/screens/auth/forgot_password/user_image.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:ocean_publication/screens/history/order_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var userData;
  bool loading;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    setState(() {
      loading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = jsonDecode(userJson);

    setState(() {
      userData = user;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        centerTitle: true,
        elevation: 0.7,
        title: const Text(
          "Profile Setting",
          style: TextStyle(fontSize: 17.0),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          loading
              ? const Text("loading")
              : ProfilePic(
                  userData: userData,
                ),
          userData != null
              ? Text("${userData['first_name']} ${userData['last_name']}",
                  style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5))
              : const Text(""),
          userData != null ? Text(userData['email']) : const Text(""),
          ProfileMenu(
              icon: "assets/images/user_icon.svg",
              text: "Change Password",
              press: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordForm()))
                  }),
          ProfileMenu(
              icon: "assets/images/bell.svg",
              text: "Latest Uploads",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LatestUploads()));
              }),
          ProfileMenu(
              icon: "assets/images/settings.svg",
              text: "Settings",
              press: () {}),
          ProfileMenu(
              icon: "assets/images/cart_icon.svg",
              text: "Orders",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserOrderHistory()));
              }),
          const LogoutUserProfile()
        ],
      ),
    );
  }
}

/*
 *--------------Logout User Profile---------------
 */
class LogoutUserProfile extends StatefulWidget {
  const LogoutUserProfile({Key key}) : super(key: key);

  @override
  _LogoutUserProfileState createState() => _LogoutUserProfileState();
}

class _LogoutUserProfileState extends State<LogoutUserProfile> {
  ScaffoldState scaffoldState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: appPrimaryColor,
          onPressed: () {
            _logout();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/logout.svg",
                width: 22,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ],
          )),
    );
  }

  void _logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var res = await CallApi().userLogout('/logout', token);
    var body = jsonDecode(res.body);
    if (body['status']) {
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}

/*
 *-------------Profile Menu Items-----------------
 */
class ProfileMenu extends StatelessWidget {
  final String text, icon;
  final Function press;

  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: SizedBox(
        height: 40.0,
        child: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: const Color(0xFFF5F6F9),
            onPressed: press,
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  width: 22,
                  color: appPrimaryColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                  text,
                  style: TextStyle(color: Colors.grey[500]),
                )),
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey[500])
              ],
            )),
      ),
    );
  }
}
