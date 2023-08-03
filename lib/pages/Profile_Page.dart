// ignore_for_file: file_names, prefer_const_constructors

import 'package:chatapp/services/Auth_Services.dart';
import 'package:flutter/material.dart';

import '../Widgets/Widget.dart';
import '../helper/helper_function.dart';
import 'Auth/Login_page.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName = '';
  String? email = '';

  AuthServices authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailSF().then((value) {
      setState(() {
        email = value;
      });
    });
    await HelperFunctions.getUserNameSF().then((value) {
      setState(() {
        userName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Profile",
            style: TextStyle(
                color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ))
          ]),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              userName!,
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                nextScreenReplacement(context, HomePage());
              },
              selectedColor: Color.fromARGB(255, 3, 96, 219),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group),
              title: const Text(
                'Groups',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Color.fromARGB(255, 3, 96, 219),
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.person_2_rounded),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                await authServices.signOut().whenComplete(() {
                  HelperFunctions.saveUserLoggedInStatus(false);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                });
              },
              selectedColor: Color.fromARGB(255, 3, 96, 219),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Full Name',
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  userName!,
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email',
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  email!,
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
