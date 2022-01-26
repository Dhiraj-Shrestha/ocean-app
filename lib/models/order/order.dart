import 'package:ocean_publication/models/products/api_data.dart';

class OrderHistory {
  int id;
  String date;
  String link;
  String invoiceNo;
  int grandTotal;
  String paymentMethod;
  List<LibraryItems> orderItems;

  OrderHistory(
      {this.id,
      this.date,
      this.link,
      this.invoiceNo,
      this.grandTotal,
      this.paymentMethod,
      this.orderItems});

  OrderHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    link = json['link'];
    invoiceNo = json['invoice_no'];
    grandTotal = json['grand_total'];
    paymentMethod = json['payment_method'];
    if (json['order_items'] != null) {
      orderItems = <LibraryItems>[];
      json['order_items'].forEach((v) {
        orderItems.add(LibraryItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['link'] = link;
    data['invoice_no'] = invoiceNo;
    data['grand_total'] = grandTotal;
    data['payment_method'] = paymentMethod;
    if (orderItems != null) {
      data['order_items'] = orderItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

