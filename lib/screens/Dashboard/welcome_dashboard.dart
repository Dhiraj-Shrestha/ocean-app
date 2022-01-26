import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/screens/Dashboard/latest_upload.dart';
import 'package:ocean_publication/screens/dashboard/allcourses/all_courses.dart';
import 'package:ocean_publication/screens/auth/user_profile.dart';
import 'package:ocean_publication/screens/history/order_history.dart';
import 'package:ocean_publication/screens/landing_page/landing_page.dart';
import 'package:ocean_publication/screens/saved_course/save_course.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeDashboardPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  WelcomeDashboardPage({Key key}) : super(key: key);
  @override
  _WelcomeDashboardPageState createState() => _WelcomeDashboardPageState();
}

class _WelcomeDashboardPageState extends State<WelcomeDashboardPage> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  int selectedIndex = 0;
  // ignore: prefer_typing_uninitialized_variables
  var userData;
  bool loading = false;
  String setToken;
  int totalsavecourse, totalpurchasecourse;

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    if (userJson != null) {
      var user = jsonDecode(userJson);
      setState(() {
        userData = user;
      });
    }
  }

  void _getDashboardData() async {
    setState(() {
      loading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('token');

    if (token != null || token != '') {
      setState(() {
        setToken = token;
      });
    }
    var response = await CallApi().getDashboardList('/dashboard', setToken);
    var data = jsonDecode(response.body);

    if (data['status']) {
      setState(() {
        totalsavecourse = data['data']['total_save_course'];
        totalpurchasecourse = data['data']['total_purchase_course'];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _getUserInfo();
    _getDashboardData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ignore: sized_box_for_whitespace
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 10.0),
                // ignore: sized_box_for_whitespace
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserSaveCourse()));
                  },
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 150,
                    width: 150,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: appPrimaryColor),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 5,
                        shadowColor: appPrimaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              loading
                                  ? Center(child: circularProgressIndicator())
                                  : Text(totalsavecourse.toString(),
                                      style: const TextStyle(
                                          fontSize: 50.0,
                                          color: appPrimaryColor)),
                              const Text('Saved Courses',
                                  style: TextStyle(
                                      fontSize: 15.0, color: appPrimaryColor)),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
              // ignore: sized_box_for_whitespace
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserAllCourses()));
                },
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 150,
                  width: 150,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: appPrimaryColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      elevation: 5,
                      shadowColor: appPrimaryColor, // Change this
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            loading
                                ? Center(child: circularProgressIndicator())
                                : Text(totalpurchasecourse.toString(),
                                    style: const TextStyle(
                                        fontSize: 50.0,
                                        color: appPrimaryColor)),
                            const Text('Buy Courses',
                                style: TextStyle(
                                    fontSize: 15.0, color: appPrimaryColor)),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Latest Uploads",
                    style: TextStyle(
                        color: appPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        fontFamily: 'Montserrat'),
                  ),
                ]),
          ),
          const Expanded(child: LatestUploads()),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: appPrimaryColor,
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpeg'),
                  fit: BoxFit.fill,
                ),
              ),
              accountName: userData != null
                  ? Text("${userData['first_name']} ${userData['last_name']}")
                  : const Text("Ocean Publication Pvt. Ltd."),
              accountEmail: userData != null
                  ? Text(userData['email'])
                  : const Text("oceanpublication@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: userData != null && userData['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          userData['image'] ?? '',
                          height: 150.0,
                          width: 100.0,
                        ),
                      )
                    : ClipRRect(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 150.0,
                          width: 100.0,
                        ),
                      ),
              ),
            ),
            createDrawerItem(
                icon: Icons.home,
                text: 'Dashboard',
                isSelected: selectedIndex == 0,
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WelcomeDashboardPage()));
                }),
            createDrawerItem(
                icon: Icons.home,
                text: 'Home',
                isSelected: selectedIndex == 1,
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LandingPage()));
                }),
            createDrawerItem(
                icon: Icons.integration_instructions,
                text: 'My Profile',
                isSelected: selectedIndex == 2,
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                }),
            createDrawerItem(
                icon: Icons.person,
                text: 'Save Courses',
                isSelected: selectedIndex == 3,
                onTap: () {
                  setState(() {
                    selectedIndex = 3;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSaveCourse()));
                }),
            createDrawerItem(
                icon: Icons.person_add_alt_sharp,
                text: 'All Courses',
                isSelected: selectedIndex == 4,
                onTap: () {
                  setState(() {
                    selectedIndex = 4;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserAllCourses()));
                }),
            createDrawerItem(
                icon: Icons.track_changes,
                text: 'History',
                isSelected: selectedIndex == 5,
                onTap: () {
                  setState(() {
                    selectedIndex = 5;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserOrderHistory()));
                }),
            createDrawerItem(
                icon: Icons.contact_mail,
                text: 'Logout',
                isSelected: selectedIndex == 6,
                onTap: () {
                  setState(() {
                    selectedIndex = 6;
                  });
                  _logout();
                }),
          ],
        ),
      ),
    );
  }

  Widget createDrawerItem(
      {@required IconData icon,
      @required String text,
      @required GestureTapCallback onTap,
      @required bool isSelected}) {
    return Ink(
      color: isSelected ? appPrimaryColor : Colors.transparent,
      child: ListTile(
        selected: true,
        hoverColor: Colors.white,
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.blueAccent,
        ),
        title: isSelected
            ? Text(text,
                style: const TextStyle(
                    color: Colors.white, fontFamily: 'Montserrat'))
            : Text(text, style: const TextStyle(fontFamily: 'Montserrat')),
        onTap: onTap,
      ),
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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LandingPage()));
    }
  }
}
