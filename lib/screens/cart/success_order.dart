import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/order/order.dart';
import 'package:ocean_publication/screens/history/order_history.dart';
import 'package:ocean_publication/screens/landing_page/landing_page.dart';

class SuccessfullOrder extends StatefulWidget {
  final String orderTrackId;

  const SuccessfullOrder({Key key, @required this.orderTrackId})
      : super(key: key);

  @override
  State<SuccessfullOrder> createState() => _SuccessfullOrderState();
}

class _SuccessfullOrderState extends State<SuccessfullOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/1.png",
                  height: 220,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                // ignore: deprecated_member_use
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    padding: const EdgeInsets.all(20),
                    elevation: 0.7,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    textColor: Colors.deepOrange,
                    color: Colors.white,
                    onPressed: () {},
                    child: const Text(
                      'Order Success',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          letterSpacing: 0.5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Your Order has been placed. Your Order ID is: ",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 5.0),
                Text(widget.orderTrackId,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {
                       final CartListBloc cartListBloc =
                          BlocProvider.getBloc<CartListBloc>();
                      cartListBloc.removeAllCartData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  UserOrderHistory()));
                    },
                    child: const Text('Order History',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500)),
                    textColor: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.black26,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: TextButton(
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: appPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: () {
                      final CartListBloc cartListBloc =
                          BlocProvider.getBloc<CartListBloc>();
                      cartListBloc.removeAllCartData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LandingPage()));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
