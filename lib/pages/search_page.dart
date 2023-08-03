// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:chatapp/Widgets/Widget.dart';
import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/Chat_page.dart';
import 'package:chatapp/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  QuerySnapshot? searchSnapshot;
  bool haveUserSearch = false;
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  String userName = '';
  User? user;
  bool isjoined = false;

  @override
  void initState() {
    super.initState();
    getCurrentUserNameAndId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Search',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(children: [
        Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  initialSearchMethod();
                },
                icon: Icon(Icons.search),
                color: const Color.fromARGB(255, 0, 0, 0),
              )
            ],
          ),
        ),
        _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : groupList(),
      ]),
    );
  }

  initialSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseServices()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          haveUserSearch = true;
        });
      });
    }
  }

  groupList() {
    return haveUserSearch
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                  userName,
                  searchSnapshot!.docs[index]['groupId'],
                  searchSnapshot!.docs[index]['groupName'],
                  searchSnapshot!.docs[index]['admin']);
            },
          )
        : Container();
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    //Check user already exist in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
      ),
      subtitle: Text('Admin is ${getName(admin)}'),
      trailing: InkWell(
        onTap: () async {
          await DatabaseServices(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (isjoined) {
            setState(() {
              isjoined = !isjoined;
            });
            showSnackbar(context, Colors.red, 'Left the group $groupName');
          } else {
            setState(() {
              isjoined = !isjoined;
            });
            showSnackbar(context, Colors.green, 'Joined the group $groupName');
            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                      groupId: groupId,
                      userName: userName,
                      groupName: groupName));
            });
          }
        },
        child: isjoined
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 3, 96, 219),
                    border: Border.all(color: Colors.white, width: 1)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Joined',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 3, 96, 219),
                    border: Border.all(color: Colors.white, width: 1)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Join Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }

  String getName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  getCurrentUserNameAndId() async {
    await HelperFunctions.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      isjoined = value;
    });
  }
}
