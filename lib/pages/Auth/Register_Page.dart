// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/Auth/Login_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/Auth_Services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Widgets/Widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = '';
  String password = '';
  String Fname = '';
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Teamy',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Register for chat and explore',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Image.asset('assets/register.png'),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Full Name',
                          hintText: 'Enter Full Name...',
                        ),
                        onChanged: (value) {
                          setState(() {
                            Fname = value;
                          });
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Full Name cannot be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: textInputDecoration.copyWith(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          hintText: 'Enter Email...',
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Email cannot be empty';
                          } else if (!RegExp(
                                  r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(val)) {
                            return 'Enter a valid email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          prefixIcon: Icon(Icons.password),
                          labelText: 'Password',
                          hintText: 'Enter Password',
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Password cannot be empty';
                          } else if (val.length < 6) {
                            return 'Password must be at least 6 characters';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Register();
                          },
                          child: Text(
                            'Register',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                        text: 'Already Account? ',
                        children: [
                          TextSpan(
                              text: 'Login now',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreenReplacement(context, LoginPage());
                                }),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void Register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      print('Validated');
      await AuthServices().register(Fname, email, password).then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(Fname);
          setState(() {
            _isLoading = false;
          });
          nextScreenReplacement(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    } else {
      print('Not Validated');
    }
  }
}
