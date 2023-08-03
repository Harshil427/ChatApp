// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors

import 'package:chatapp/Widgets/Widget.dart';
import 'package:chatapp/pages/Chat_page.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupName;
  final String groupId;

  const GroupTile({
    required this.userName,
    required this.groupName,
    required this.groupId,
  });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Text(
              '${widget.groupName.substring(0, 1).toUpperCase()}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'join the conversation as ${widget.userName}',
            style: TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
