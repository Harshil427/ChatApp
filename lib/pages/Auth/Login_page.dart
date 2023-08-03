// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_label, file_names, avoid_print, use_build_context_synchronously, await_only_futures

import 'package:chatapp/Widgets/Widget.dart';
import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../services/Auth_Services.dart';
import '../home_page.dart';
import 'Register_Page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  String email = '';
  String password = '';
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
                        'Login now for talking world',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Image.asset('assets/login.png'),
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
                            login();
                          },
                          child: Text(
                            'Login',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                        text: 'Don\'t have an account? ',
                        children: [
                          TextSpan(
                              text: 'Register now',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreenReplacement(
                                      context, RegisterPage());
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

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      print('Validated');
      await AuthServices().Login(email, password).then((value) async {
        if (value == true) {
          print('Login Success');
          QuerySnapshot snapshot = await DatabaseServices(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);

          //saving values in shared Prefences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

          ///Set loading status
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
