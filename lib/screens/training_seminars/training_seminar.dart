import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/training_seminar/data.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class TrainingSeminar extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  TrainingSeminar({Key key}) : super(key: key);
  @override
  _TrainingSeminarState createState() => _TrainingSeminarState();
}

class _TrainingSeminarState extends State<TrainingSeminar> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  bool loading = false;
  final List<TrainingSeminarModel> _listOfTrainingAndSeminars = [];

  void _getTrainingSeminars() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().fetchTrainingSeminars("/training-seminar");
    var data = jsonDecode(response.body);

    if (data['status']) {
      var trainingSeminars = data['data'];
      if (trainingSeminars != null) {
        setState(() {
          for (Map i in trainingSeminars) {
            _listOfTrainingAndSeminars.add(TrainingSeminarModel.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _getTrainingSeminars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        centerTitle: true,
        title: const Text('Training And Seminars'),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/back.svg',
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // ignore: avoid_unnecessary_containers
      body: loading
          ? Center(child: circularProgressIndicator())
          // ignore: avoid_unnecessary_containers
          : Container(
              child: ListView.builder(
                  itemCount: _listOfTrainingAndSeminars.length,
                  itemBuilder: (_, index) {
                    TrainingSeminarModel trainingSeminarModel =
                        _listOfTrainingAndSeminars[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 7,
                          child: Column(
                            children: [
                              ListTile(
                                leading: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 50,
                                    minHeight: 50,
                                    maxWidth: 64,
                                    maxHeight: 70,
                                  ),
                                  child: Image.network(
                                      trainingSeminarModel.image,
                                      fit: BoxFit.cover),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 5.0),
                                  child: Row(children: [
                                    const Icon(Icons.person,
                                        color: appPrimaryColor),
                                    const SizedBox(width: 5.0),
                                    Text(trainingSeminarModel.title ?? '',
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700)),
                                  ]),
                                ),
                                subtitle: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: appPrimaryColor),
                                          const SizedBox(width: 5.0),
                                          Text(trainingSeminarModel.slug ?? '',
                                              style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ]),
                                onTap: () {},
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Html(data: trainingSeminarModel.postContent)
                                  ],
                                ),
                              ),
                            ],
                          )),
                    );
                  }),
            ),
    );
  }
}
