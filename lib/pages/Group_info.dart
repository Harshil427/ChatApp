// ignore_for_file: prefer_const_constructors

import 'package:chatapp/Widgets/Widget.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String adminName;
  final String groupName;

  const GroupInfo(
      {super.key,
      required this.groupId,
      required this.adminName,
      required this.groupName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    super.initState();
    getmembers();
  }

  getmembers() async {
    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      members = val;
    });
  }

  //
  String getName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  //get user id
  String getUid(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Group Info'),
        actions: [
          IconButton(
            onPressed: () async {
              await DatabaseServices(
                      uid: FirebaseAuth.instance.currentUser!.uid)
                  .toggleGroupJoin(widget.groupId, getName(widget.adminName),
                      widget.groupName)
                  .whenComplete(() {
                nextScreenReplacement(context, HomePage());
              });
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 28),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.groupName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '      Created by ${getName(widget.adminName)}',
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            child: Text(
                              getName(snapshot.data['members'][index])
                                  .substring(0, 1),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 28),
                            ),
                          ),
                          title: Text(
                            getName(snapshot.data['members'][index]),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text(
                            getUid(snapshot.data['members'][index]),
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Text('No members'),
                );
              }
            } else {
              return Center(
                child: Text('No members'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
