class LibraryItems {
  LibraryItems({
    this.id,
    this.title,
    this.slug,
    this.image,
    this.price,
    this.offerPrice,
    this.author,
    this.video,
    this.preview,
    this.feature,
    this.book,
    this.time,
    this.isbnNo,
    this.type,
    this.edition,
    this.language,
    this.rating,
    this.videoUrl,
    this.digitalOrHardCopy,
    this.description,
    this.packageType,
    this.tableOfContent,
    this.quantity = 1,
  });

  int id;
  String title;
  String slug;
  String image;
  int price;
  String digitalOrHardCopy;
  int offerPrice;
  String author;
  String video;
  String book;
  int preview;
  int feature;
  String time;
  String isbnNo;
  String type;
  String edition;
  String language;
  String videoUrl;
  int rating;
  String packageType;
  String description;
  String tableOfContent;
  int quantity;

  factory LibraryItems.fromJson(Map<String, dynamic> json) => LibraryItems(
        id: json['id'],
        title: json['title'] ?? '',
        slug: json['slug'] ?? '',
        image: json['image'] ?? '',
        price: json['price'] ?? 0,
        offerPrice: json['offer_price'] ?? 0,
        author: json['author'] ?? '',
        video: json['video'] ?? '',
        book: json['book'] ?? '',
        videoUrl: json['video_url'] ?? '',
        preview: json['preview'] ?? 0,
        feature: json['feature'] ?? 0,
        time: json['time'] ?? '',
        isbnNo: json['isbn_no'] ?? '',
        type: json['type'] ?? '',
        edition: json['edition'] ?? '',
        language: json['language'] ?? '',
        packageType: json['package_type'] ?? '',
        digitalOrHardCopy: json['digital_or_hardcopy'] ?? '',
        rating: json['rating'] ?? 3,
        description: json['description'] ?? '',
        tableOfContent: json['table_of_content'] ?? '',
        quantity: json['quantity'] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'image': image,
        'price': price,
        'offer_price': offerPrice,
        'author': author,
        'video': video,
        'video_url': videoUrl,
        'preview': preview,
        'time': time,
        'feature': feature,
        'isbn_no': isbnNo,
        'type': type,
        'book': book,
        "package_type": packageType,
        'edition': edition,
        'language': language,
        'rating': rating,
        'description': description,
        'table_of_content': tableOfContent,
        'digital_or_hardcopy': digitalOrHardCopy,
        'quantity': quantity
      };

  void incrementQty() {
    quantity = quantity + 1;
  }

  void decrementQty() {
    quantity = quantity - 1;
  }
}
