import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class AboutUs extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AboutUs({Key key}) : super(key: key);
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  bool loading = false;
  final _listOfData = [];

  void _getAboutUs() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().aboutUs("/aboutus");

    var data = jsonDecode(response.body);

    if (data['status']) {
      _listOfData.add(data['data'][0]);
      setState(() {
        loading = false;
      });

      // developer.log('$_listOfData[0]');
    }
  }

  @override
  void initState() {
    _getAboutUs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        title: const Text('About Us'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/back.svg',
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? Center(child: circularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  ListTile(
                      title: const Text("About Us",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w800)),
                      subtitle: Html(data: _listOfData[0])),
                ],
              ),
            ),
    );
  }
}
