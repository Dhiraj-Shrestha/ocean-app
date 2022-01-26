class CategoryWithChilds {
  int id;
  String title;
  String slug;
  List<Childs> childs;

  CategoryWithChilds({this.id, this.title, this.slug, this.childs});

  CategoryWithChilds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    if (json['childs'] != null) {
      childs = <Childs>[];
      json['childs'].forEach((v) {
        childs.add(Childs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    if (childs != null) {
      data['childs'] = childs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Childs {
  int id;
  String title;
  String slug;

  Childs({this.id, this.title, this.slug});

  Childs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    return data;
  }
}
