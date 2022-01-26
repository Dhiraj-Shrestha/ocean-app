// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ocean_publication/api/api.dart';
import 'package:ocean_publication/constants/app_colors.dart';
import 'package:ocean_publication/screens/Dashboard/welcome_dashboard.dart';
import 'package:ocean_publication/screens/auth/forgot_password/forgot_password_form.dart';
import 'package:ocean_publication/screens/auth/register.dart';
import 'package:ocean_publication/widgets/circular_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool isChecked = false;

  ScaffoldState scaffoldState;

  _showFlashMessage(msg) {
    final snackbar = SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.red)),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  //handle remember me function
  void _handleRemeberme(bool value) {
    isChecked = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', _emailController.text);
        prefs.setString('password', _passwordController.text);
      },
    );
    setState(() {
      isChecked = value;
    });
  }

  //load email and password
  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      if (_remeberMe) {
        setState(() {
          isChecked = true;
        });
        _emailController.text = _email ?? "";
        _passwordController.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _loadUserEmailPassword();
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            Container(
                                child: Row(
                              children: [
                                InkWell(
                                    onTap: () {},
                                    child: Checkbox(
                                        value: isChecked,
                                        onChanged: _handleRemeberme)),
                                const Text('Remember Me')
                              ],
                            )),
                            const SizedBox(
                              height: 40.0,
                            ),
                            // ignore: avoid_unnecessary_containers
                            Container(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPasswordForm()));
                                    },
                                    child: const Text(
                                      'Forgot Password ?',
                                      style: TextStyle(
                                          color: appPrimaryColor,
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          decoration: TextDecoration.underline),
                                    ))),
                          ],
                        ),

                        // ignore: sized_box_for_whitespace
                        Container(
                            height: 40.0,
                            width: double.infinity, // <-- match_parent
                            child: ElevatedButton(
                              child: _isLoading
                                  ? Center(
                                      child: smallCircularProgressIndicator())
                                  : const Text("Login"),
                              onPressed: () {
                                if (_formKey.currentState.validate() &&
                                    !_isLoading) {
                                  _handleUserLogin();
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
                            const Text('if don\'t have an account ? '),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()),
                                  );
                                },
                                child: const Text(
                                  'Register',
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

  _handleUserLogin() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    var response = await CallApi().loginUser('/login', data);

    var body = jsonDecode(response.body);
    print(body);
    // developer.log('${body}');

    if (body['status'] == true) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', jsonEncode(body['user']));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => WelcomeDashboardPage()));
    } else {
      _showFlashMessage(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
