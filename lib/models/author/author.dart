class AuthorModel {
  int id;
  String name;
  String slug;
  List<String> subjects;
  String image;

  AuthorModel({this.id, this.name, this.slug, this.subjects, this.image});

  AuthorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    subjects = json['subjects'].cast<String>();
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['subjects'] = subjects;
    data['image'] = image;
    return data;
  }
}
