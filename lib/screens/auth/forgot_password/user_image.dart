/* 
 * ------------Profile Picture---------------------
 */
import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io' as io;

import 'package:image_picker/image_picker.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePic extends StatefulWidget {
  final userData;

  // ignore: prefer_const_constructors_in_immutables
  ProfilePic({Key key, @required this.userData}) : super(key: key);
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final ImagePicker _picker = ImagePicker();
  final String _url = 'https://oceanpublication.com.np/api';
  bool loading = false;
  FToast fToast;

  String setToken;

  dynamic pickImageError;
  XFile _imageFile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        height: 100,
        width: 100,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: widget.userData['image'] == null
                  ? const AssetImage("assets/images/profile.jpg")
                  : NetworkImage(widget.userData['image']),
              // : FileImage(io.File(widget.userData['image'])),
            ),
            Positioned(
              bottom: 1.0,
              right: -7,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.grey.shade100,
                    width: 6,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (builder) => buttonSheet());
                    },
                    child: SvgPicture.asset(
                      "assets/images/camera_Icon.svg",
                      color: Colors.white,
                      fit: BoxFit.contain,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buttonSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                tooltip: 'Camera',
              ),
              IconButton(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: const Icon(Icons.image),
                tooltip: 'Gallery',
              ),
            ],
          )
        ],
      ),
    );
  }

  _saveImage() async {
    setState(() {
      loading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('token');
    if (token != null || token != '') {
      setState(() {
        setToken = token;
      });
    }
    if (_imageFile != null) {
      var data = {
        "image": _imageFile,
      };

      var response = await patchImage("/student-image/update", _imageFile.path);

      if (response.statusCode == 200) {
        print('success');
        setState(() {});
        // developer.log("$body");
        // showToast(body['message']);
      } else {
        // showToast(body['message']);
        //  developer.log("$body");
        print('fail');
      }
      setState(() {
        loading = false;
      });

      Navigator.pop(context); // pop current page
    }
  }

  showToast(msg) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: Colors.white),
          const SizedBox(
            width: 12.0,
          ),
          Text(msg, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
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
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    // final respStr = await response.stream.bytesToString();
    var image = json.decode(response.body);
    var body = jsonDecode(response.body);
    var user = localStorage.getString('user');
    print(body);
    print(body['image']);
    var userData = json.decode(user);
    userData['image'] =
        'https://oceanpublication.com.np/upload/user/1643096522image_picker4128171688242498306.jpg';

    // widget.userData['image'] = image['image'];
    // localStorage.setString('user', json.encode(widget.userData));

    setState(() {
      localStorage.setString('user', jsonEncode(userData));
    });
    print(localStorage.getString('user'));

    return response;
  }

  Future<http.StreamedResponse> ptchImage(String url, String filePath) async {
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

  void takePhoto(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        _imageFile = pickedFile;
        _saveImage();

        print(_imageFile);
      });
    } catch (e) {
      setState(() {
        pickImageError = e;
      });
    }
  }
}
