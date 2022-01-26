class DistributerModel {
  int id;
  String name;
  String slug;
  String image;
  String address;
  String contactPerson;
  String phoneNumber;

  DistributerModel(
      {this.id,
      this.name,
      this.slug,
      this.image,
      this.address,
      this.contactPerson,
      this.phoneNumber});

  DistributerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    slug = json['slug'] ?? '';
    image = json['image'] ?? '';
    address = json['address'] ?? '';
    contactPerson = json['contact_person']?? '';
    phoneNumber = json['phone_number'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['address'] = address;
    data['contact_person'] = contactPerson;
    data['phone_number'] = phoneNumber;
    return data;
  }
}