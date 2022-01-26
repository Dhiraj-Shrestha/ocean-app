// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/order/order.dart';
import 'package:ocean_publication/screens/history/order_list.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOrderHistory extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  UserOrderHistory({Key key}) : super(key: key);

  @override
  _UserOrderHistory createState() => _UserOrderHistory();
}

class _UserOrderHistory extends State<UserOrderHistory> {
  final List<OrderHistory> _listOfUserOrderLists = [];
  bool loading = false;
  String setToken;
  @override
  void initState() {
    _fetchUserOrderHistory();
    super.initState();
  }

  // ignore: prefer_void_to_null
  Future<Null> _fetchUserOrderHistory() async {
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
    var response = await CallApi().getAllUserOrders("/user-orders", setToken);
    var data = jsonDecode(response.body);

    if (data['status']) {
      var orders = data['data'];
      if (orders != null) {
        log('$orders');
        setState(() {
          for (Map i in orders) {
            _listOfUserOrderLists.add(OrderHistory.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          centerTitle: true,
          elevation: 0.7,
          title: const Text(
            "All Orders",
            style: TextStyle(fontSize: 17.0),
          ),
        ),
        body: loading
            ? Center(child: circularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: _listOfUserOrderLists.length,
                          itemBuilder: (context, index) {
                            OrderHistory order = _listOfUserOrderLists[index];
                            return OrderList(order: order);
                          }),
                    ],
                  ),
                ),
              ));
  }
}
