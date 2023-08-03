// ignore_for_file: prefer_const_constructors

import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/Auth/Login_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignIn = false;

  @override
  void initState() {
    getUserLoggedInstatus();
    super.initState();
  }

///////////////////////////////////////////////////////////////////////////////////
  
  void getUserLoggedInstatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignIn = value;
        });
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isSignIn ? HomePage() : LoginPage(),
    );
  }
  
}
