// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String? uid;
  DatabaseServices({this.uid});
  //
  final CollectionReference userColection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference groupsColection =
      FirebaseFirestore.instance.collection('Groups');
  //
  Future updateUserData(String fullname, String email) async {
    return await userColection
        .doc(uid)
        .set({'fullName': fullname, 'email': email, 'groups': [], 'uid': uid});
  }

  // Getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userColection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  //Getting user groups
  getUserGroups() async {
    return userColection.doc(uid).snapshots();
  }

  //Creating Groups
  Future createGroup(String userName, String uid, String groupName) async {
    DocumentReference documentReference = await groupsColection.add({
      'groupName': groupName,
      // 'admin': userName,
      'admin': '${uid}_$userName',
      'groupIcon': '',
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
      'recentMessageTime': DateTime.now(),
    });
    //UPDATE VALUE

    await documentReference.update({
      'members': FieldValue.arrayUnion(['${uid}_$userName']),
      'groupId': documentReference.id,
    });

    DocumentReference userDocumentReference = await userColection.doc(uid);
    return await userDocumentReference.update({
      'groups': FieldValue.arrayUnion(['${documentReference.id}_$groupName']),
    });
  }
  //get chat

  getChats(String groupId) async {
    return groupsColection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  //get group admin
  getGroupAdmin(String groupId) async {
    DocumentReference d = groupsColection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  //get members
  getGroupMembers(String groupId) async {
    return groupsColection.doc(groupId).snapshots();
  }

  //search group name
  searchByName(String groupName) {
    return groupsColection.where('groupName', isEqualTo: groupName).get();
  }

  //Chech user Joined group or not
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocument = userColection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocument.get();

    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains('${groupId}_$groupName')) {
      return true;
    } else {
      return false;
    }
  }

  //toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    DocumentReference userDocumentRefence = userColection.doc(uid);
    DocumentReference groupDocumentRefence = groupsColection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentRefence.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    //
    if (groups.contains('${groupId}_$groupName')) {
      await userDocumentRefence.update({
        'groups': FieldValue.arrayRemove(['${groupId}_$groupName']),
      });

      await groupDocumentRefence.update({
        'members': FieldValue.arrayRemove(['${uid}_$userName']),
      });
    } else {
      await userDocumentRefence.update({
        'groups': FieldValue.arrayUnion(['${groupId}_$groupName']),
      });

      await groupDocumentRefence.update({
        'members': FieldValue.arrayUnion(['${uid}_$userName']),
      });
    }
  }

  //send message

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupsColection.doc(groupId).collection('messages').add(chatMessageData);
    groupsColection.doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString()
    });
  }
}
