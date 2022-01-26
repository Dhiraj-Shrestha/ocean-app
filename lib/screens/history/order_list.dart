import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/order/order.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class OrderList extends StatefulWidget {
  final OrderHistory order;
  // ignore: prefer_const_constructors_in_immutables
  OrderList({Key key, @required this.order}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  bool loading = false;
  String setToken;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          margin: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.order.orderItems
                .map((item) => _listOfData(item))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _listOfData(LibraryItems item) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.network(item.image, width: 110, fit: BoxFit.fitHeight),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: appPrimaryColor),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rs. ${widget.order.grandTotal.toString()}",
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red),
                    ),
                    const SizedBox(width: 10.0),
                    Text(widget.order.paymentMethod.toString(),
                        style: const TextStyle(
                            fontSize: 14, color: appPrimaryColor))
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  widget.order.date.toString(),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4E6059)),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Order ID:  ${widget.order.invoiceNo.toString()}",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: appSecondaryColor),
                ),
                const SizedBox(
                  height: 6,
                ),
                IconButton(
                    onPressed: () {
                      openFile(
                          url: widget.order.link,
                          fileName: 'file.pdf'); // file.pdf
                    },
                    icon: const Icon(Icons.download, color: appPrimaryColor))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future openFile({String url, String fileName}) async {
    final file = await downloadFile(url, fileName);
    if (file == null) {
      return;
    }
    log('path: ${file.path}');
    OpenFile.open(file.path);
  }

  Future<File> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      final response = await Dio().get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }
}
