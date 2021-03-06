import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/routes/router.dart';
import 'package:ocean_publication/routes/router_constant.dart';
import 'package:flutter/services.dart';

void main() {
  // add these lines
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => CartListBloc()),
      ],
      dependencies: const [],
      child: MaterialApp(
          title: 'Ocean Publication',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Montserrat'),
          onGenerateRoute: Routers.onGenerateRoute,
          initialRoute: splashRoute),
      // home: ForgotPasswordForm(),
    );
  }
}
