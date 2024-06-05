// ignore_for_file: avoid_print, unused_local_variable

import 'package:b_dep/b_dep.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/requests/message_api.dart';
import 'package:trucker/screens/profile_screen/profile.dart';

class GroupHelper {
  GroupHelper._privateConstructor();

  static final GroupHelper instance = GroupHelper._privateConstructor();

  factory GroupHelper() {
    return instance;
  }

  // if a group name of the same name is present in user group list
  bool isGroupNameAlreadyPresent(String groupNameToCheck) {
    return detailsUser.any((group) => group.groupName == groupNameToCheck);
  }

  // This Function is used to fetch all the details of the group in which the user was the member.
  Future<void> getAllGroupDetails(
      //BuildContext context,
  {String? mUserId}
      ) async {
    // print("Calling daddy");
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '6b6b6dc0-70b8-11ee-aae7-271ecb6118b8',
      //context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "Id": mUserId??prefs.userId,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "6b6b6dc0-70b8-11ee-aae7-271ecb6118b8",
          jsonData: getJsonData());
      List<dynamic> results = response;
      // print("resultResp> $results");
      detailsUser.clear();
      for (int i = results.length-1; i >= 0; i--) {
        String length = '';
        if (results[i]["total_members"] != null) {
          length = results[i]["total_members"];
        } else {
          length = "0";
        }
        GroupDetails newGroup = GroupDetails(
          groupName: results[i]["G_Name"],
          groupMembers: length,
          groupID: results[i]["G_Id"],
          createBy: results[i]?["Created_by"]??"null",
          // singleChat: null,
        );
        if(int.parse(length) == 2){
          await GroupHelper().getAllPName(results[i]["G_Id"],true);
        }
        if(int.parse(length) > 1){
          if(detailsUser.isNotEmpty) {
            detailsUser.removeWhere((element) =>
            element.groupID == newGroup.groupID);
          }
          detailsUser.add(newGroup);
        }
      }
      // detailsUser = detailsUser.reversed.toList();
      // print("detailsUser>> ${detailsUser}");
    } catch (es, st) {
      print("Error>> $es $st");
    }
  }

  // This Function is used to delete a particular group it will take gid as the input and delete the group.
  Future<void> deleteGroups(BuildContext context, var gid,
      {VoidCallback? onDelete}) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '6412f700-740f-11ee-aa37-d51ae42648c4',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {"G_Id": gid};
      return jsonData;
    }

    var response = await bBlupSheetsApi.runHttpApi(
        queryId: "6412f700-740f-11ee-aa37-d51ae42648c4",
        jsonData: getJsonData());
    detailsUser.removeWhere((e) {
      if (e.groupID == gid) {
        return true;
      }
      return false;
    });
  }
  // This Function is used to return the name of all the members of a particular group.
  Future<Map<String, GetIndividualData>> getAllPName(gid,flag) async {
    // print("Coming $gid $flag");
    // print("result-02->> | $gid");
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '35a144f0-a89c-11ee-bc6f-d3dcbb9da00b',
      // context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "G_id": gid,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "35a144f0-a89c-11ee-bc6f-d3dcbb9da00b",
          jsonData: getJsonData());
      individualData.clear();
      // dataMap.clear();
      List<dynamic> results = response;
      for (int i = 0; i < results.length; i++) {
        String dateTimeString = '${results[i]["date"]} ${results[i]["time"]}';
        DateFormat dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
        DateTime dateTime = dateFormat.parse(dateTimeString);
        String rem = '';
        Duration difference = DateTime.now().difference(dateTime);
        if (difference.inDays >= 365) {
          int number = int.parse('${difference.inDays}');
          int res = number ~/ 365;
          String years = res.toString();
          rem =  '$years years ago';
        } else if (difference.inDays > 30) {
          int number = int.parse('${difference.inDays}');
          int res = number ~/ 30;
          String days = res.toString();
          if(days=="1"){
            rem =  '$days month ago';
          } else{
            rem =  '$days months ago';
          }
        } else if (difference.inDays > 1) {
          rem =  '${difference.inDays} days ago';
        } else if (difference.inHours >= 24) {
          int number = int.parse('${difference.inHours}');
          int res = number ~/ 24;
          String inHours = res.toString();
          rem =  '$inHours days ago';
        } else if (difference.inHours > 1) {
          rem =  '${difference.inHours} hours ago';
        }
        else if (difference.inMinutes >= 60) {
          int number = int.parse('${difference.inMinutes}');
          int res = number ~/ 60;
          String inMinutes = res.toString();
          rem =  '$inMinutes hours ago';
        } else if (difference.inMinutes > 1) {
          rem =  '${difference.inMinutes} minutes ago';
        } else {
          rem =  'Just now';
        }

        print("sttus>> ${results[i]["status"]} | ${results[i]["Name"]}");

        var late = await MessageApi.latestMessage(gid).first;
        if(late.docs.isNotEmpty) {
          var latestMessage = late.docs.first.data();

          GetIndividualData newData = GetIndividualData(
              pName: results[i]["Name"],
              pId: results[i]["UserId"],
              pNumber: results[i]["PhoneNumber"],
              pRem: rem,
              pStatus: results[i]["status"],
              pImage: results[i]["profilePic"],
              latestMessage: latestMessage["message"]
          );
          if (!individualData.any((element) => element.pId == newData.pId)) {
            newData.isNewMessage = dataMap[gid]?.isNewMessage ?? false;
            individualData.add(newData);
          } else {
            newData.isNewMessage = dataMap[gid]?.isNewMessage ?? false;
            individualData.removeWhere((element) => element.pId == newData.pId);
            individualData.add(newData);
          }
          if (flag && prefs.phoneNumber != results[i]["PhoneNumber"]) {
            dataMap[gid] = newData;
          }
        }
      }
    } catch (es, st) {
      print("Error>> $es $st");
    }
    return dataMap;
  }

  // This Function is Used to change the name of the group means it is use to rename the group.
  static Future<void> changeGroupName(BuildContext context, gid, name) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '084242f0-98ef-11ee-b7be-590e41e6f0db',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "new_group_name": name,
        "G_Id": gid,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
        queryId: "084242f0-98ef-11ee-b7be-590e41e6f0db",
        jsonData: getJsonData(),
      );
    } catch (es, st) {
      print("Error>> $es $st");
    }
  }

  // This Function is used to return all the details of a particular user in a group
  static Future<void> getSingleUser(BuildContext context, gid, pid,
      {VoidCallback? onDelete}) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '95893890-9b6e-11ee-9b30-e9b5dc312c7c',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "P_id": pid,
        "G_id": gid,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
        queryId: "95893890-9b6e-11ee-9b30-e9b5dc312c7c",
        jsonData: getJsonData(),
      );
    } catch (es, st) {
      print("Error>> $es $st");
    }
  }

  // This function is used to add the new members to the existing group that were not their in that group.
  static Future<void> addParticipant(BuildContext context, gid, pid) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '87a920a0-9b6e-11ee-9b30-e9b5dc312c7c',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "P_id": pid,
        "G_id": gid,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
        queryId: "87a920a0-9b6e-11ee-9b30-e9b5dc312c7c",
        jsonData: getJsonData(),
      );
    } catch (es, st) {
      print("Error>> $es $st");
    }
  }

  // After adding new member in the group this function is used to add new members count in the group details table to update total participants in the group.
  static Future<void> updateTotalMember(
      BuildContext context, number, gid) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '27a62a60-9e69-11ee-be6e-a7ae586ff62c',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "member": number,
        "G_id": gid,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
        queryId: "27a62a60-9e69-11ee-be6e-a7ae586ff62c",
        jsonData: getJsonData(),
      );
    } catch (es, st) {
      print("Error>> $es $st");
    }
  }
}
