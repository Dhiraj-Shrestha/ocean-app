import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/organization.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/Dashboard/welcome_dashboard.dart';
import 'package:ocean_publication/screens/aboutus/about_us.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:ocean_publication/screens/auth/register.dart';
import 'package:ocean_publication/screens/author/author.dart';
import 'package:ocean_publication/screens/books/book_page.dart';
import 'package:ocean_publication/screens/cart/cart_page.dart';
import 'package:ocean_publication/screens/distributer/distributer.dart';
import 'package:ocean_publication/screens/drawer/drawer.dart';
import 'package:ocean_publication/screens/library/library_page.dart';
import 'package:ocean_publication/screens/home/homepage.dart';
import 'package:ocean_publication/screens/search/search_item.dart';
import 'package:ocean_publication/screens/training_seminars/training_seminar.dart';
import 'package:ocean_publication/screens/videos/video_page.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:badges/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<OrganizationModel> _organizationModel;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: prefer_typing_uninitialized_variables
  var userData;

  GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  int _currentIndex = 0;
  int selectedIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    BookPage(),
    VideoPage(),
    LibraryPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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

  // void _getOrganizationDetails() async {
  //   var response = await CallApi().getOrganizationData('/settings');

  //   var data = jsonDecode(response.body);

  //   // developer.log("$data");
  //   if (response.statusCode == 200) {
  //     var allcourses = data['data'];

  //     if (allcourses != null) {
  //       setState(() {
  //         for (Map i in allcourses) {
  //           organizationDetail.add(Data.fromJson(i));
  //         }
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    _organizationModel = CallApi().getOrganizationData();

    _getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: ItemSearch());
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          StreamBuilder<List<LibraryItems>>(
            stream: bloc.listStream,
            builder: (context, snapshot) {
              List<LibraryItems> items = snapshot.data;
              int length = items != null ? items.length : 0;
              return Center(
                child: InkWell(
                  onTap: () {
                    developer.log('cart page goes here...');
                    if (length > 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartPage()));
                    } else {
                      return;
                    }
                  },
                  child: Badge(
                    badgeColor: Colors.white,
                    badgeContent: Text(length.toString(),
                        style: const TextStyle(color: Colors.black)),
                    animationType: BadgeAnimationType.scale,
                    animationDuration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 5.0),
          userData == null
              ? PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: const Text("Sign In")),
                    ),
                    PopupMenuItem(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: const Text("Sign Up"),
                      ),
                    ),
                  ],
                )
              : Container(),
          const SizedBox(width: 20.0 / 2)
        ],
      ),
      body: _children[_currentIndex],
      drawer: _currentIndex == 0 || _currentIndex == 3
          ? SizedBox(
              width: MediaQuery.of(context).size.width - 70,
              child: Drawer(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: <Widget>[
                          UserAccountsDrawerHeader(
                            decoration: const BoxDecoration(
                              color: appPrimaryColor,
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/background.jpeg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            accountName: userData != null
                                ? Text(
                                    "${userData['first_name']} ${userData['last_name']}")
                                : const Text("Ocean Publication Pvt. Ltd."),
                            accountEmail: userData != null
                                ? Text(userData['email'])
                                : FutureBuilder<OrganizationModel>(
                                    future: _organizationModel,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var mydata = snapshot.data.data;
                                        return Text(mydata.primaryEmail);
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                            'Cannot load at this time');
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                            currentAccountPicture: Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Colors.white,
                                ),
                                // backgroundColor: Colors.white,
                                child: userData != null &&
                                        userData['image'] != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          userData['image'] ?? '',
                                          height: 150.0,
                                          width: 100.0,
                                        ),
                                      )
                                    : FutureBuilder<OrganizationModel>(
                                        future: _organizationModel,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var mydata = snapshot.data.data;
                                            return ClipRRect(
                                              child: Image.network(
                                                mydata.logo,
                                                height: 150.0,
                                                width: 150.0,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text(
                                                'Cannot load at this time');
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        })),
                          ),
                          Expanded(
                            child: Column(
                              // Important: Remove any padding from the ListView.

                              children: <Widget>[
                                createDrawerItem(
                                    icon: Icons.home,
                                    text: 'Home',
                                    isSelected: selectedIndex == 0,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 0;
                                      });
                                    }),
                                createDrawerItem(
                                    icon: Icons.integration_instructions,
                                    text: 'About Us',
                                    isSelected: selectedIndex == 1,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 1;
                                      });

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AboutUs()));
                                    }),
                                createDrawerItem(
                                    icon: Icons.person,
                                    text: 'Author',
                                    isSelected: selectedIndex == 2,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 2;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Author()));
                                    }),
                                createDrawerItem(
                                    icon: Icons.person_add_alt_sharp,
                                    text: 'Distributor',
                                    isSelected: selectedIndex == 3,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 3;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Distributer()));
                                    }),
                                createDrawerItem(
                                    icon: Icons.track_changes,
                                    text: 'Training and Seminars',
                                    isSelected: selectedIndex == 4,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 4;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TrainingSeminar()));
                                    }),
                                createDrawerItem(
                                    icon: Icons.login,
                                    text: userData != null
                                        ? 'Go Dashboard'
                                        : 'Login',
                                    isSelected: selectedIndex == 6,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 6;
                                      });
                                      userData != null
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WelcomeDashboardPage()))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()));
                                    }),
                                const Divider(),
                                FutureBuilder<OrganizationModel>(
                                    future: _organizationModel,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var now = DateTime.now();
                                        var formatter = DateFormat('yyyy');
                                        String formattedDate =
                                            formatter.format(now);
                                        var mydata = snapshot.data.data;
                                        var arr = mydata.address.split('  ');
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              top: 3.0,
                                              bottom: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 28.0, bottom: 15.0),
                                                child: Text(
                                                  mydata.siteDescription
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.person,
                                                      color: appSecondaryColor),
                                                  const SizedBox(width: 10.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          arr[0].toString() +
                                                              ' ' +
                                                              arr[1].toString(),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100)),
                                                      Text(arr[2].toString(),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10.0),
                                              Row(
                                                children: [
                                                  const Icon(Icons.phone,
                                                      color: appSecondaryColor),
                                                  const SizedBox(width: 10.0),
                                                  Text(
                                                      mydata.primaryPhone
                                                              .toString() +
                                                          ', ' +
                                                          mydata.secondaryPhone
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w100))
                                                ],
                                              ),
                                              const SizedBox(height: 10.0),
                                              Row(
                                                children: [
                                                  const Icon(Icons.contact_mail,
                                                      color: appSecondaryColor),
                                                  const SizedBox(width: 10.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          mydata.primaryEmail
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100)),
                                                      const SizedBox(
                                                          width: 5.0),
                                                      Text(
                                                          mydata.secondaryEmail
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Copyright @ ' +
                                                            (mydata.siteTitle
                                                                    .toString() +
                                                                ' ' +
                                                                formattedDate
                                                                    .toString()),
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                            'Cannot load at this time');
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Powered By: ',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                                InkWell(
                                  onTap: _launchURL,
                                  child: const Text(
                                    'AllStar Technology',
                                    style: TextStyle(
                                      color: appPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ComplexDrawer(currentIndex: _currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appPrimaryColor,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        selectedItemColor: appSecondaryColor,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_sharp),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: 'Library',
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'https://allstar.com.np';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget createDrawerItem(
      {@required IconData icon,
      @required String text,
      @required GestureTapCallback onTap,
      @required bool isSelected}) {
    return SizedBox(
      height: 50,
      child: Ink(
        color: isSelected ? appPrimaryColor : Colors.transparent,
        child: Card(
          elevation: 0.0,
          child: ListTile(
            selected: true,
            leading: Icon(
              icon,
              color: isSelected ? appPrimaryColor : Colors.blueAccent,
            ),
            title: isSelected
                ? Text(text,
                    style: const TextStyle(
                        color: appPrimaryColor, fontFamily: 'Montserrat'))
                : Text(text, style: const TextStyle(fontFamily: 'Montserrat')),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
