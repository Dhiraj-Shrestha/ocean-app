// To parse this JSON data, do
//
//     final singleProductModel = singleProductModelFromJson(jsonString);

import 'dart:convert';

SingleProductModel singleProductModelFromJson(String str) =>
    SingleProductModel.fromJson(json.decode(str));

String singleProductModelToJson(SingleProductModel data) =>
    json.encode(data.toJson());

class SingleProductModel {
  SingleProductModel({
    this.status,
    this.data,
  });

  bool status;
  Data data;

  factory SingleProductModel.fromJson(Map<String, dynamic> json) =>
      SingleProductModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.book,
    this.relatedProducts,
    this.childCategory,
    this.feedbacks,
  });

  Book book;
  List<Book> relatedProducts;
  Child childCategory;
  List<Feedback> feedbacks;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        book: Book.fromJson(json["book"]),
        relatedProducts: List<Book>.from(
            json["related_products"].map((x) => Book.fromJson(x))),
        childCategory: Child.fromJson(json["child_category"]),
        feedbacks: List<Feedback>.from(
            json["feedbacks"].map((x) => Feedback.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "book": book.toJson(),
        "related_products":
            List<dynamic>.from(relatedProducts.map((x) => x.toJson())),
        "child_category": childCategory.toJson(),
        "feedbacks": List<dynamic>.from(feedbacks.map((x) => x.toJson())),
      };
}

class Book {
  Book({
    this.id,
    this.title,
    this.slug,
    this.book,
    this.image,
    this.price,
    this.offerPrice,
    this.author,
    this.isbnNo,
    this.edition,
    this.language,
    this.rating,
    this.description,
    this.tableOfContent,
    this.digitalOrHardcopy,
    this.type,
  });

  int id;
  String title;
  String slug;
  String book;
  String image;
  int price;
  dynamic offerPrice;
  String author;
  String isbnNo;
  String edition;
  String language;
  int rating;
  String description;
  String tableOfContent;
  String digitalOrHardcopy;
  String type;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        book: json["book"],
        image: json["image"],
        price: json["price"],
        offerPrice: json["offer_price"],
        author: json["author"],
        isbnNo: json["isbn_no"],
        edition: json["edition"],
        language: json["language"],
        rating: json["rating"],
        description: json["description"],
        tableOfContent: json["table_of_content"],
        digitalOrHardcopy: json["digital_or_hardcopy"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "book": book,
        "image": image,
        "price": price,
        "offer_price": offerPrice,
        "author": author,
        "isbn_no": isbnNo,
        "edition": edition,
        "language": language,
        "rating": rating,
        "description": description,
        "table_of_content": tableOfContent,
        "digital_or_hardcopy": digitalOrHardcopy,
        "type": type,
      };
}

class Child {
  Child({
    this.id,
    this.title,
    this.slug,
    this.parentId,
    this.icon,
    this.image,
    this.status,
    this.description,
    this.childs,
  });

  int id;
  String title;
  String slug;
  int parentId;
  dynamic icon;
  String image;
  Status status;
  dynamic description;
  List<Child> childs;

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        parentId: json["parent_id"],
        icon: json["icon"],
        image: json["image"],
        status: statusValues.map[json["status"]],
        description: json["description"],
        childs: List<Child>.from(json["childs"].map((x) => Child.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "parent_id": parentId,
        "icon": icon,
        "image": image,
        "status": statusValues.reverse[status],
        "description": description,
        "childs": List<dynamic>.from(childs.map((x) => x.toJson())),
      };
}

// ignore: constant_identifier_names
enum Status { ACTIVE }

final statusValues = EnumValues({"Active": Status.ACTIVE});

class Feedback {
  Feedback({
    this.id,
    this.review,
    this.star,
    this.user,
    this.courseId,
  });

  int id;
  String review;
  int star;
  User user;
  int courseId;

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        id: json["id"],
        review: json["review"],
        star: json["star"],
        user: User.fromJson(json["user"]),
        courseId: json["course_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "review": review,
        "star": star,
        "user": user.toJson(),
        "course_id": courseId,
      };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
    this.email,
    this.phone,
    this.address,
  });

  int id;
  String firstName;
  String lastName;
  String image;
  String email;
  dynamic phone;
  dynamic address;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "email": email,
        "phone": phone,
        "address": address,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
