// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, sort_child_properties_last, unused_local_variable

import 'package:chatapp/Widgets/Widget.dart';
import 'package:chatapp/Widgets/group_tile.dart';
import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/Auth/Login_page.dart';
import 'package:chatapp/pages/search_page.dart';
import 'package:chatapp/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/Auth_Services.dart';

import 'Profile_Page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName = '';
  String? email = '';
  Stream? groupStream;
  bool _isLoading = false;
  String groupName = '';

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  //get id
  String getId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String getName(String res) {
    return res.substring(res.indexOf('_') + 1);
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

    //getting list of groups snapsort
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groupStream = snapshot;
      });
    });
  }

  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
        title: const Text(
          "Chat",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
                // nextScreenReplacement(context, HomePage());
              },
              selectedColor: Color.fromARGB(255, 3, 96, 219),
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group),
              title: const Text(
                'Groups',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplacement(context, ProfilePage());
              },
              selectedColor: Color.fromARGB(255, 3, 96, 219),
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        backgroundColor: Color.fromARGB(255, 3, 96, 219),
        elevation: 0,
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 255, 255, 255),
          size: 30,
        ),
      ),
    );
  }

  void popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Create Group', textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Group Name',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (groupName.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseServices(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(
                        userName!,
                        FirebaseAuth.instance.currentUser!.uid,
                        groupName,
                      )
                          .whenComplete(() {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                      Navigator.pop(context);
                      // showSnackbar(
                      //     context, Colors.green, 'Group Created successfully');
                    }
                  },
                  child: Text('CREATE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groupStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              // return Text('Hello');
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseindex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      userName: snapshot.data['fullName'],
                      groupName: getName(snapshot.data['groups'][reverseindex]),
                      groupId: getId(snapshot.data['groups'][reverseindex]));
                },
              );
            } else {
              return noGroupsWidget();
            }
          } else {
            return noGroupsWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

// Group not exist
  noGroupsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '😠😠You have not join any group click to add and find group using search😁😁',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
