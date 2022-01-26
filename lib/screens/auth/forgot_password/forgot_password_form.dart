// ignore_for_file: avoid_print, sized_box_for_whitespace

import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/bloc/cart_list_bloc.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/screens/auth/forgot_password/valid_token.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class ForgotPasswordForm extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ForgotPasswordForm({Key key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool status = false;
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  ScaffoldState scaffoldState;

  _showFlashMessage(msg, status) {
    final snackbar = SnackBar(
      content: Text(msg,
          style: TextStyle(color: status ? Colors.white : Colors.red)),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ignore: avoid_unnecessary_containers
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Column(
                      children: const [
                        Text('Forgot Your Password  ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: appPrimaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 17)),
                        SizedBox(height: 20.0),
                        Text(
                          'Enter the Email address associated  with your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                            EmailValidator(errorText: "Invalid email")
                          ]),
                          decoration: const InputDecoration(
                              labelText: "Email",
                              // hintText: 'Enter your Email Address',
                              labelStyle: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 40.0,
                            width: double.infinity, // <-- match_parent
                            child: ElevatedButton(
                              child: _isLoading
                                  ? Center(
                                      child: smallCircularProgressIndicator())
                                  : const Text("Send Mail"),
                              onPressed: () {
                                if (_formKey.currentState.validate() &&
                                    !_isLoading) {
                                  _sendEmail();
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

  _sendEmail() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email': _emailController.text,
    };
    var response =
        await CallApi().sendMailForResetPassword('/user-forgot-password', data);
    var body = jsonDecode(response.body);

    if (body['status'] == true) {
      setState(() {
        status = true;
      });
      _showFlashMessage(body['message'], status);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ValidResetPasswordToken()));
      BlocProvider.getBloc<CartListBloc>().addUserEmail(_emailController.text);
      // bloc.addUserEmail(_emailController.text);
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
