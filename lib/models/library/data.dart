class Library {
  int id;
  String title;
  String slug;
  String link;
  String image;

  Library({this.id, this.title, this.slug, this.link, this.image});

  Library.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    link = json['link'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['link'] = link;
    data['image'] = image;
    return data;
  }
}
