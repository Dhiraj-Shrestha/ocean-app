// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:ocean_publication/screens/auth/register.dart';
import 'package:ocean_publication/screens/cart/cart_body.dart';
import 'package:ocean_publication/screens/cart/success_order.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class CartPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CartPage({Key key}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  final _listOfCarts = [];
  // ignore: prefer_typing_uninitialized_variables
  var userData;
  String setToken;
  // ignore: non_constant_identifier_names
  bool payment_method = false;
  bool loading = false;

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

  void _getUserToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('token');

    if (token != null || token != '') {
      setState(() {
        setToken = token;
      });
    }
  }

  // ignore: prefer_void_to_null
  Future<Null> _checkOut(List<LibraryItems> items) async {
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

    if (items.isNotEmpty) {
      for (var item in items) {
        _listOfCarts.add({"id": item.id, "name": item.type});
      }
    }

    var cartItem = {
      "cart": _listOfCarts.isNotEmpty ? _listOfCarts : null,
      "ttlPrice": returnTotalAmount(items),
      "payment_method": payment_method ? 'Esewa' : 'Cash On Delivery'
    };

    // developer.log("$cartItem");
    var response = await CallApi().checkout('/orderStore', setToken, cartItem);
    var data = jsonDecode(response.body);

    if (data['status']) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SuccessfullOrder(orderTrackId: data['invoice_no'])));
    }

    //developer.log("$data");

    setState(() {
      loading = false;
    });
  }

  Future<void> payment({List<LibraryItems> items, String totalAmount}) async {
    return EsewaFlutterSdk.initPayment(
      esewaConfig: EsewaConfig(
        environment: Environment.live,
        clientId: "KhAAFg9TOxAbCRoGFhUaBAtZNQURWS0HD0tDKyNIMjJeJCY8JD0=",
        secretId: "BhwIWQQADhIYSxwGEgAdRRYdDg==",
      ),
      esewaPayment: EsewaPayment(
        productId: "1d71jd81",
        productName: "Product One",
        productPrice: totalAmount,
        callbackUrl: "www.test-url.com",
      ),
      onPaymentSuccess: (EsewaPaymentSuccessResult data) {
        _checkOut(items);
        debugPrint(":::SUCCESS::: => $data");
      },
      onPaymentFailure: (data) {
        debugPrint(":::FAILURE::: => $data");
      },
      onPaymentCancellation: (data) {
        debugPrint(":::CANCELLATION::: => $data");
      },
    );
  }

  @override
  void initState() {
    _getUserInfo();
    _getUserToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LibraryItems>>(
      stream: bloc.listStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<LibraryItems> items = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: appPrimaryColor,
              elevation: 0,
              title: const Text('Cart Details'),
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
                      developer.log('search goes here...');
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartPage()));
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
            body: SafeArea(
                // ignore: avoid_unnecessary_containers
                child: Container(
              child: CartBody(items),
            )),
            bottomNavigationBar: returnTotalAmount(items) == 0
                ? const SizedBox()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      totalAmount(items),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                payment_method = true;
                              });
                              var totalAmount = returnTotalAmount(items);

                              setToken != null
                                  ? payment(
                                      items: items,
                                      totalAmount: totalAmount.toString())
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/esewa.png',
                                      width: 30, fit: BoxFit.fitWidth),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Proceed to Pay",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.green,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        }
        return Center(child: circularProgressIndicator());
      },
    );
  }
}

Container totalAmount(List<LibraryItems> items) {
  return Container(
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "Grant Total:",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        Text(
          "Rs. ${returnTotalAmount(items)} /-",
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
        ),
      ],
    ),
  );
}

returnTotalAmount(List<LibraryItems> items) {
  int totalAmount = 0;

  for (int i = 0; i < items.length; i++) {
    totalAmount = totalAmount + items[i].price * items[i].quantity;
  }
  return totalAmount;
}
