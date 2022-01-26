import 'dart:convert';
import 'dart:developer';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:http/http.dart' as http;

class FetchItemList {
  var data = [];
  List<LibraryItems> results = [];

  Future<List<LibraryItems>> getItemList({String query}) async {
    var url = query == null || query == ''
        ? Uri.parse('https://oceanpublication.com.np/api/books')
        : Uri.parse('https://oceanpublication.com.np/api/search/?data=$query');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        data = json.decode(response.body)['data'];
        results = data.map((e) => LibraryItems.fromJson(e)).toList();
        if (query != null) {
          results = results
              .where((element) =>
                  element.title.toLowerCase().contains((query.toLowerCase())))
              .toList();
        }
      } else {
        log('fetch error');
      }
    } on Exception catch (e) {
      log('error: $e');
    }
    return results;
  }
}
