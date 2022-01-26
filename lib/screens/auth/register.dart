import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/screens/auth/login.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';

class RegisterPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  ScaffoldState scaffoldState;
  _showFlashMessage(msg) {
    final snackbar = SnackBar(
      content: Text(msg,style: const TextStyle(color: Colors.red)),
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
    _confirmPasswordVisible = false;
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
                        TextFormField(
                          controller: _firstNameController,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                          ]),
                          decoration: const InputDecoration(
                              labelText: "First Name",
                              // hintText: 'Enter your Email Address',
                              labelStyle: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey)),
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                          ]),
                          decoration: const InputDecoration(
                              labelText: "Last Name",
                              // hintText: 'Enter your Email Address',
                              labelStyle: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey)),
                        ),
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
                        TextFormField(
                          controller: _mobileNoController,
                          keyboardType: TextInputType.number,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "*. Required"),
                          ]),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: const InputDecoration(
                              labelText: "Mobile No",
                              // hintText: 'Enter your Email Address',
                              labelStyle: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: !_passwordVisible,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "*. Required"),
                            MinLengthValidator(6,
                                errorText:
                                    "Password should be atleast 6 characters"),
                            MaxLengthValidator(15,
                                errorText:
                                    "Password should not be greater than 15 characters")
                          ]),
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
                        TextFormField(
                          controller: _confirmPasswordController,
                          keyboardType: TextInputType.text,
                          obscureText: !_confirmPasswordVisible,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "*. Required"),
                            MinLengthValidator(6,
                                errorText:
                                    "Password should be atleast 6 characters"),
                            MaxLengthValidator(15,
                                errorText:
                                    "Password should not be greater than 15 characters")
                          ]),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: appPrimaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                      !_confirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        const SizedBox(
                          height: 40.0,
                        ),
                        // ignore: sized_box_for_whitespace
                        Container(
                            height: 40.0,
                            width: double.infinity, // <-- match_parent
                            child: ElevatedButton(
                              child: _isLoading
                                  ? Center(
                                      child: smallCircularProgressIndicator())
                                  : const Text("Register"),
                              onPressed: () {
                                if (_formKey.currentState.validate() &&
                                    !_isLoading) {
                                  _registerUser();
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'if you have already account please login ? '),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: appPrimaryColor,
                                      fontFamily: 'Montserrat',
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registerUser() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'confirm_password': _confirmPasswordController.text,
      'phone': _mobileNoController.text
    };
    var response = await CallApi().registerUser('/register', data);
    var body = jsonDecode(response.body);
    //developer.log('${body}');

    if (body['status'] == true) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      _showFlashMessage(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
