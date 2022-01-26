import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/models/distributer/data.dart';
import 'dart:developer' as developer;
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class Distributer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Distributer({Key key}) : super(key: key);
  @override
  _DistributerState createState() => _DistributerState();
}

class _DistributerState extends State<Distributer> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  bool loading = false;
  final List<DistributerModel> _listOfDistributers = [];

  void _getDistributers() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().fetchDistributer("/distributor");
    var data = jsonDecode(response.body);

    developer.log('$data');

    if (data['status']) {
      var distributers = data['data'];
      if (distributers != null) {
        setState(() {
          for (Map i in distributers) {
            _listOfDistributers.add(DistributerModel.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _getDistributers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        centerTitle: true,
        title: const Text('Distributors'),
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
                  itemCount: _listOfDistributers.length,
                  itemBuilder: (_, index) {
                    DistributerModel distributor = _listOfDistributers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 7,
                        child: ListTile(
                          
                          title: Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Row(children: [
                              const Icon(Icons.person, color: appPrimaryColor),
                              const SizedBox(width: 5.0),
                              Text(distributor.name ?? '',
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ]),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: appPrimaryColor),
                                const SizedBox(width: 5.0),
                                Text(distributor.address ?? '',
                                    style: const TextStyle(
                                        fontFamily:  'Montserrat',
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Row(
                              children: [
                                distributor.phoneNumber != null || distributor.phoneNumber != '' ?
                                const Icon(Icons.call, color: appPrimaryColor) : '',
                                const SizedBox(width: 5.0),
                                Text(distributor.phoneNumber ?? '',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ]),
                          onTap: () {},
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
