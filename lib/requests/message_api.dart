import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/modals/message_modals.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';
import 'package:intl/intl.dart';

// var prefs = SharedPreferencesService.getInstance();

class MessageApi {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> allmessages(
      GroupDetails groupdetails) {
    return firestore
        .collection('chats/${getchatid(groupdetails.groupID)}/groupmessage')
        .orderBy("sendat", descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> latestMessage(
      String groupId) {
    return firestore
        .collection('chats/${groupId}/groupmessage')
        .orderBy("sendat", descending: true).limit(1)
        .snapshots();
  }

  static String getchatid(String id) {
    return id;
  }

  static Future<void> sendMessage(GroupDetails groupdetails, String messssage,
      MessageType messagetype) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final GroupMessage groupmessage = GroupMessage(
      read: "",
      fromPID: prefs.userId!,
      sendat: time,
      type: messagetype,
      message: messssage,
      fromPName: prefs.name!,
      toGId: groupdetails.groupID,
    );
    final refs = firestore
        .collection('chats/${getchatid(groupdetails.groupID)}/groupmessage');
    await refs.doc(time).set(groupmessage.toJson());
  }

  static Future<void> sendImage(
      GroupDetails groupDetails, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        "messageimages/${getchatid(groupDetails.groupID)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
    await ref.putFile(file).then((p0) {});
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(groupDetails, imageUrl, MessageType.image);
  }

  static String dateAndTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final formattedTime = DateFormat.jm().format(date);
    return formattedTime;
  }
}
