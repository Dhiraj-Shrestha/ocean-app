class TrainingSeminarModel {
  int id;
  String postAuthor;
  String postContent;
  String title;
  String slug;
  String image;

  TrainingSeminarModel(
      {this.id,
      this.postAuthor,
      this.postContent,
      this.title,
      this.slug,
      this.image});

  TrainingSeminarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postAuthor = json['post_author'] ?? '';
    postContent = json['post_content'] ?? '';
    title = json['title'] ?? '';
    slug = json['slug'] ?? '';
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['post_author'] = postAuthor;
    data['post_content'] = postContent;
    data['title'] = title;
    data['slug'] = slug;
    data['image'] = image;
    return data;
  }
}
