// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:badges/badges.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/bloc/cart_provider.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:ocean_publication/screens/auth/register.dart';
import 'package:ocean_publication/screens/cart/cart_page.dart';
import 'package:expandable/expandable.dart';
import 'package:ocean_publication/screens/products/related_products/related_product_heading.dart';
import 'package:ocean_publication/screens/products/related_products/related_products.dart';
import 'package:ocean_publication/screens/products/review.dart';
import 'package:ocean_publication/screens/products/single_product_tapbar.dart';
import 'package:ocean_publication/screens/search/search_item.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:ocean_publication/widgets/rating.dart';
import 'package:ocean_publication/widgets/richtext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SingleProductPage extends StatefulWidget {
  final LibraryItems libraryItems;

  // ignore: prefer_const_constructors_in_immutables
  SingleProductPage({Key key, @required this.libraryItems}) : super(key: key);

  @override
  _SingleProductPageState createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  var message = CartProvider().isPresent;
  String setToken;
  final List<LibraryItems> _listOfUserCourses = [];
  // ignore: prefer_typing_uninitialized_variables
  var userData;
  bool loading = false;
  FToast fToast;

// add to cart functionality
  addToCart(LibraryItems item) {
    bloc.addToList(item);
  }

  // ignore: prefer_void_to_null
  Future<Null> _fetchCourseUnderPackage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('token');

    if (token != null || token != '') {
      setState(() {
        setToken = token;
      });
    }
    var response = await CallApi()
        .viewAllCourseUnderPackage(widget.libraryItems.slug, setToken);
    var data = jsonDecode(response.body);

    // developer.log("$data");
    if (data['status']) {
      var allcourses = data['data']['courses_assign'];

      if (allcourses != null) {
        setState(() {
          for (Map i in allcourses) {
            _listOfUserCourses.add(LibraryItems.fromJson(i));
          }
        });
      }
    }
  }

  void _getUserToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var userInfo = localStorage.getString('user');

    if (token != '' || token != null) {
      setState(() {
        setToken = token;
      });
    }

    if (userInfo != null) {
      setState(() {
        userData = jsonDecode(userInfo);
      });
    }
  }

  _showFlashMessage(msg) {
    final snackbar = SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: bloc.provider.isPresent == false ? Colors.green : Colors.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              bloc.provider.isPresent == false
                  ? Icons.check
                  : Icons.contact_mail_rounded,
              color: Colors.white),
          const SizedBox(
            width: 12.0,
          ),
          Text(
              bloc.provider.isPresent == false
                  ? "Added To Cart"
                  : 'Already added in cart',
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  void initState() {
    _getUserToken();
    widget.libraryItems.type == 'package' ? _fetchCourseUnderPackage() : null;
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final libraryItems = widget.libraryItems;
    return Scaffold(
      //  every product has app primary color
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/back.svg',
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
                    if (userData == null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } else {
                      if (length > 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartPage()));
                      } else {
                        return;
                      }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120.0, left: 3.0, right: 3.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.07),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: SizedBox(
                        height: 250,
                        child: Image.network(
                          libraryItems.image,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width / 2.5,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        libraryItems.isbnNo == ''
                            ? const SizedBox()
                            : richText(
                                simpleText: 'ISBN NO',
                                colorText: libraryItems.isbnNo),
                        libraryItems.edition == ''
                            ? const SizedBox()
                            : richText(
                                simpleText: 'Edition',
                                colorText: libraryItems.edition.split(" ")[0]),
                        richText(
                            simpleText: libraryItems.digitalOrHardCopy != ''
                                ? "Type Copy"
                                : "Type",
                            colorText: libraryItems.digitalOrHardCopy != ''
                                ? libraryItems.digitalOrHardCopy
                                : libraryItems.type),
                        libraryItems.language == ''
                            ? const SizedBox()
                            : richText(
                                simpleText: 'Language',
                                colorText: libraryItems.language),
                        richText(simpleText: 'Stock', colorText: '3'),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "MRP:  ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                              libraryItems.offerPrice == 0
                                  ? const SizedBox()
                                  : Text(
                                      "Rs. ${libraryItems.price.toString()}",
                                      style: const TextStyle(
                                        color: appPrimaryColor,
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                              const SizedBox(width: 5.9),
                              Text(
                                  'Rs. ${libraryItems.offerPrice == 0 ? libraryItems.price.toString() : libraryItems.offerPrice.toString()}',
                                  style: const TextStyle(
                                      color: appPrimaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 4, right: 5),
                                  child: Text(
                                    "Reviews",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: appPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, right: 5),
                                child: buildRatingStart(libraryItems.rating)),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        libraryItems.title,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            color: appPrimaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  libraryItems.author != ''
                      ? Column(
                          children: [
                            const Text(
                              'By',
                              style: TextStyle(
                                  color: appPrimaryColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    libraryItems.author,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: appPrimaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      child: SinglePageTapbar(
                    discription: libraryItems.description,
                    tableOfContent: libraryItems.tableOfContent,
                  )),

                  const SizedBox(height: 6.0),

                  const SizedBox(height: 6.0),
                  libraryItems.type == 'package'
                      ? ExpandablePanel(
                          theme: const ExpandableThemeData(
                            iconColor: appPrimaryColor,
                            expandIcon: Icons.arrow_left,
                          ),
                          header: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Package Content',
                              style: TextStyle(
                                  height: 1.5,
                                  color: appPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          collapsed: const Text(
                            '',
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          expanded: Column(
                            children: List.generate(
                              _listOfUserCourses.length,
                              (int index) {
                                var accountData = _listOfUserCourses[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SingleProductPage(
                                                    libraryItems:
                                                        accountData)));
                                  },
                                  child: Card(
                                    elevation: 0.5,
                                    child: ListTile(
                                      leading: Image.network(accountData.image),
                                      title: Text(accountData.title.toString()),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),

                  ReviewPage(
                    type: widget.libraryItems.type,
                    slug: widget.libraryItems.slug,
                    rating: widget.libraryItems.rating,
                  ),

                  // related Product Heading
                  RelatedProductTitle(),
                  const SizedBox(height: 10.0),
                  // related product lists
                  RelatedProducts(
                      type: widget.libraryItems.type,
                      slug: widget.libraryItems.slug),
                ],
              )
            ],
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rs: ${libraryItems.price.toString()}",
                      style: const TextStyle(
                          color: appPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Total Price")
                  ],
                )),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Add to Cart',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ],
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(appPrimaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.blue)))),
                onPressed: () {
                  addToCart(libraryItems);
                  showToast();
                },
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 5.0),
            child: SizedBox(
              height: 40,
              child: loading
                  ? SizedBox(
                      width: 30.0,
                      child: Center(child: smallCircularProgressIndicator()))
                  : InkWell(
                      onTap: () => {
                        setToken != null
                            ? _saveParticularCourse()
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              ),
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          width: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: SvgPicture.asset(
                            "assets/images/heart_icon.svg",
                            color: const Color(0xFFFF4848),
                            // : Color(0xFFDBDEE4),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveParticularCourse() async {
    setState(() {
      loading = true;
    });
    if (widget.libraryItems != null) {
      var item = widget.libraryItems;
      var saveCourseInfo = {
        "courseId": item.id,
        "name": item.type,
      };
      var response =
          await CallApi().saveCourse('/save-course', setToken, saveCourseInfo);
      var data = jsonDecode(response.body);
      if (data['status']) {
        _showFlashMessage(data['message']);
        setState(() {
          loading = false;
        });
      } else {
        _showFlashMessage(data['message']);
        setState(() {
          loading = false;
        });
      }
    }
  }
}
