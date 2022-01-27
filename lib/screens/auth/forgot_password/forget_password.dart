// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class ForgetPassword extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ForgetPassword({Key key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;
  final _formKey = GlobalKey<FormState>();
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool _isLoading = false;
  bool status = false;

  ScaffoldState scaffoldState;

  _showFlashMessage(msg, status) {
    final snackbar = SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  void initState() {
    super.initState();

    _passwordVisible = false;
    _passwordConfirmVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ignore: avoid_unnecessary_containers
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "*. Required"),
                            MinLengthValidator(6,
                                errorText:
                                    "Password should be atleast 6 characters"),
                            MaxLengthValidator(15,
                                errorText:
                                    "Password should not be greater than 15 characters")
                          ]),
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: appPrimaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _passwordConfirmationController,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "*. Required"),
                            MinLengthValidator(6,
                                errorText:
                                    "Password should be atleast 6 characters"),
                            MaxLengthValidator(15,
                                errorText:
                                    "Password should not be greater than 15 characters")
                          ]),
                          obscureText: !_passwordConfirmVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordConfirmVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: appPrimaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordConfirmVisible =
                                      !_passwordConfirmVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // ignore: sized_box_for_whitespace
                        Container(
                            height: 40.0,
                            width: double.infinity, // <-- match_parent
                            child: ElevatedButton(
                              child: _isLoading
                                  ? Center(
                                      child: smallCircularProgressIndicator())
                                  : const Text("Change Password"),
                              onPressed: () {
                                if (_formKey.currentState.validate() &&
                                    !_isLoading) {
                                  _changePassword();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: appPrimaryColor,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            )),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _changePassword() async {
    setState(() {
      _isLoading = true;
      debugPrint(bloc.email);
    });
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // String token = localStorage.getString('token');

    // if (token != null || token != '') {
    //   setState(() {
    //     setToken = token;
    //   });
    // }
    var data = {
      'email': BlocProvider.getBloc<CartListBloc>().email,
      'password': _passwordController.text,
      'password_confirmation': _passwordConfirmationController.text
    };
    var response = await CallApi()
        .changeForgetPassword('/user-forgot-update-password', data);
    var body = jsonDecode(response.body);
    if (body['status'] == true) {
      setState(() {
        status = true;
      });
      _showFlashMessage(body['message'], status);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      setState(() {
        status = false;
      });
      _showFlashMessage(body['message'], status);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
