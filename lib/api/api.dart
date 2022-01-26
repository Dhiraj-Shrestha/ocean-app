import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ocean_publication/models/organization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'https://oceanpublication.com.np/api';

  //------------ get all books from home page---------------------
  getAllDataFromHomePage(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

//------------ get all books from home page---------------------

//------------ get all books---------------------
  viewAllBooks(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

//------------ end get all books--------------------
//------------ get all packages---------------------
  viewAllPackages(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  viewAllCourseUnderPackage(slug, token) async {
    var fullUrl = _url + '/package/$slug';
    return await http.get(Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token));
  }

//------------ end get all packages-----------------

  getAllRelatedProducts(type, slug) async {
    var fullUrl = 'https://oceanpublication.com.np/api/$type/$slug';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getAllVideos(currentPage) async {
    return await http.get(
        Uri.parse(
            'https://oceanpublication.com.np/api/videos?page=$currentPage'),
        headers: _setHeaders());
  }

  fetchAllBooks(currentPage) async {
    return await http.get(
        Uri.parse(
            'https://oceanpublication.com.np/api/books?page=$currentPage'),
        headers: _setHeaders());
  }

  fetchAllLibraryBooks(currentPage) async {
    return await http.get(
        Uri.parse(
            'https://oceanpublication.com.np/api/libraries?page=$currentPage'),
        headers: _setHeaders());
  }

  // ------ login user------
  loginUser(apiUrl, loginCredential) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        headers: _setHeaders(), body: jsonEncode(loginCredential));
  }
  // ------ end login user------

  // ----------regiser user-------
  registerUser(apiUrl, registerUser) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        headers: _setHeaders(), body: jsonEncode(registerUser));
  }

  userLogout(apiUrl, token) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token));
  }

  saveCourse(apiUrl, token, data) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeadersWithToken(token));
  }

  getAllSaveCourse(apiUrl, token) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token));
  }

  getAllCourse(apiUrl, token) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token));
  }

  deleteSaveCourse(apiUrl, token, data) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeadersWithToken(token));
  }

  patchImage(String url, String filePath) async {
    var fullUrl = _url + url;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var request = http.MultipartRequest('post', Uri.parse(fullUrl));
    request.files.add(await http.MultipartFile.fromPath('image', filePath));
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    var image = json.decode(respStr);
    var user = localStorage.getString('user');
    var userData = json.decode(user);
    userData['image'] = image['image'];
    localStorage.setString('user', json.encode(userData));
    return response;
  }

  checkout(apiUrl, token, data) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeadersWithToken(token));
  }

  fetchAllCategoriesWithItsChild(apiUrl, token) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token));
  }

  fetchProductByCategory(fullUrl) async {
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  aboutUs(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getAuthors(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  fetchDistributer(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  fetchTrainingSeminars(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getDashboardList(apiUrl, token) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token));
  }

  Future<OrganizationModel> getOrganizationData() async {
    String fullUrl = _url + '/settings';

    var response = await http.get(Uri.parse(fullUrl), headers: _setHeaders());
    try {
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        OrganizationModel organizationModel =
            OrganizationModel.fromJson(jsonMap);
        return organizationModel;
      } else {
        return null;
      }
    } on Exception {
      throw "Unable to retrieve data.";
    }
  }

  getAllUserOrders(apiUrl, token) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token));
  }

  downloadOrder(token, id) async {
    var fullUrl = 'https://oceanpublication.com.np/api/download/$id';
    return await http.get(Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token));
  }

  sendMailForResetPassword(apiUrl, data) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        headers: _setHeaders(), body: jsonEncode(data));
  }

  checkToken(apiUrl, data) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        headers: _setHeaders(), body: jsonEncode(data));
  }

  changePassword(apiUrl, token, data) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token), body: jsonEncode(data));
  }

    changeForgetPassword(apiUrl, data) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        headers: _setHeaders(), body: jsonEncode(data));
  }

  fetchVideoUrl(videoId) async {
    return await http.get(
        Uri.parse('http://cdn.jwplayer.com/v2/media/$videoId'),
        headers: _setHeaders());
  }
  // ----------end regiser user-------

  // ----set header with token------
  _setHeadersWithToken(token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

// ----------------set Headers----------------------
  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
// ----------------set Headers----------------------
