// To parse this JSON data, do
//
//     final organizationModel = organizationModelFromJson(jsonString);

import 'dart:convert';

OrganizationModel organizationModelFromJson(String str) =>
    OrganizationModel.fromJson(json.decode(str));

String organizationModelToJson(OrganizationModel data) =>
    json.encode(data.toJson());

class OrganizationModel {
  OrganizationModel({
    this.data,
  });

  Data data;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      OrganizationModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.token,
    this.siteTitle,
    this.siteDescription,
    this.maxFileSize,
    this.primaryPhone,
    this.secondaryPhone,
    this.primaryEmail,
    this.secondaryEmail,
    this.salesEmail,
    this.address,
    this.mapLocation,
    this.about,
    this.logo,
    this.favicon,
    this.files,
  });

  String token;
  String siteTitle;
  String siteDescription;
  String maxFileSize;
  String primaryPhone;
  String secondaryPhone;
  String primaryEmail;
  String secondaryEmail;
  String salesEmail;
  String address;
  String mapLocation;
  String about;
  String logo;
  String favicon;
  String files;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["_token"],
        siteTitle: json["site_title"],
        siteDescription: json["site_Description"],
        maxFileSize: json["MAX_FILE_SIZE"],
        primaryPhone: json["primary_phone"],
        secondaryPhone: json["secondary_phone"],
        primaryEmail: json["primary_email"],
        secondaryEmail: json["secondary_email"],
        salesEmail: json["sales_email"],
        address: json["address"],
        mapLocation: json["map_location"],
        about: json["about"],
        logo: json["logo"],
        favicon: json["favicon"],
        files: json["files"],
      );

  Map<String, dynamic> toJson() => {
        "_token": token,
        "site_title": siteTitle,
        "site_Description": siteDescription,
        "MAX_FILE_SIZE": maxFileSize,
        "primary_phone": primaryPhone,
        "secondary_phone": secondaryPhone,
        "primary_email": primaryEmail,
        "secondary_email": secondaryEmail,
        "sales_email": salesEmail,
        "address": address,
        "map_location": mapLocation,
        "about": about,
        "logo": logo,
        "favicon": favicon,
        "files": files,
      };
}
