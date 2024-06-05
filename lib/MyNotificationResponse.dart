import 'dart:convert';

import 'package:b_dep/b_dep.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/Notification.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/widgets/help_widget/help_other_accepted.dart';

class MyNotificationResponse{
  void onHelpAccepted(String payload){
    Map<String, dynamic> userData = jsonDecode(payload);
    Map<String, dynamic> picLocation = userData['picLocation'];
    //print("Details for us -> ${userData["helpID"]} ");
    _pressYes(userData);

    List<AndroidNotificationAction> actionList=[];

    userData["id"]="help_accept_call";
    actionList.add(
        AndroidNotificationAction(
            jsonEncode(userData), "Call",
            showsUserInterface: true,
            cancelNotification: false
        )
    );

    userData["id"]="help_accept_directions";
    actionList.add(
        AndroidNotificationAction(
            jsonEncode(userData), "Directions",
            showsUserInterface: true,
            cancelNotification: false
        )
    );

    // userData["id"]="help_accept_message";
    // actionList.add(
    //     AndroidNotificationAction(
    //         jsonEncode(userData), "Message",
    //         showsUserInterface: true,
    //         cancelNotification: false
    //     )
    // );

    BackgroundServiceContinuousCheckUtils(null).showNotification
      (int.parse(userData["code"]), "Helping ${userData["name"]}",
      "You may call or message your fellow trucker.",
      isShowButtons: true,
      androidNotificationActions: actionList,
      jsonStringPayload: payload,
    );

    backgroundService.invoke(
      'checkHelpRequestStatus',
      {
        "helpID": userData["helpID"],
        "code":userData["code"],
        "name":userData["name"],
      },
    );

  }


  Future<void> _pressYes(Map<String, dynamic> userData) async {

    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '03448350-8835-11ee-bd14-3170816cf75e',
      // context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID":userData["helpID"],
        "helpStatus":"Accepted",
        "assignedHelperNo":prefs.phoneNumber,
      };
      return jsonData;
    }

    try {
      await bBlupSheetsApi.runHttpApi(
          queryId: "03448350-8835-11ee-bd14-3170816cf75e",
          jsonData: getJsonData());
      await getNameData(userData);
      Map<String, dynamic> picLocation = userData['picLocation'];
      print("Location - ${userData}");
      Get.to(OtherAcceptedHelp(name: userData["name"],
        code: userData["code"], phoneNumber: userData["phoneNumber"],
        email: userData["email"],message:userData["message"],
        picLocation: LatLng(picLocation['latitude'],picLocation['longitude']),
        request: 'Accepted', imageUrl: userData['profilePic'],
        pId: userData["helpID"], userId: userData["userId"],flag: false,)
      );
      //Get.to(OtherAcceptedHelp(name: userData["name"], code: userData["code"], phoneNumber: userData["phoneNumber"], email: userData["email"],message:userData["message"],picLocation: LatLng(picLocation['latitude'],picLocation['longitude']), request: 'Accepted',));
      print("REQUEST ACCEPTED");

    } catch (es, st) {
      print("Error in PressYES>> $es $st");
    }
  }


  Map<String,dynamic> getUserDataMap(
      String? notificationIdentificationId,
      String? helpID, String? userName, String? userCode, String? userRequestPhoneNumber,
      String? userRequestEmail, String? userSubject, LatLng? position,String? profilePic, String? userId
      ){
    return  {
      'id': notificationIdentificationId??'acceptId',
      'helpID':helpID,
      'userId':userId,
      'name': userName,
      'code': userCode,
      'phoneNumber': userRequestPhoneNumber,
      'email': userRequestEmail,
      'message': userSubject,
      'profilePic': profilePic,
      'picLocation': {
        'latitude': position?.latitude ?? 0.0,
        'longitude': position?.longitude ?? 0.0,
      }
    };
  }

  String getUserDataStr(String? notificationIdentificationId,
      String? helpID, String? userName, String? userCode, String? userRequestPhoneNumber,
      String? userRequestEmail, String? userSubject, LatLng? position, String? profilePic, String? userId){
    var userData=getUserDataMap(notificationIdentificationId, helpID, userName, userCode, userRequestPhoneNumber,
        userRequestEmail, userSubject, position, profilePic, userId);
    return jsonEncode(userData);
  }

  void onHelpRejected(String helpID, String userNumber, String userCode){
    print("Reject helpId>> $helpID");
    flutterLocalNotificationsPlugin.cancel(int.parse(userCode));
    _pressNo(helpID, userNumber);
  }

  Future<void> _pressNo(String helpID,String userNumber) async {

    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '09e4ae10-8835-11ee-bd14-3170816cf75e',
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "helperNumber":userNumber,
        "PID": helpID
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "09e4ae10-8835-11ee-bd14-3170816cf75e",
          jsonData: getJsonData());
      print("REQUEST DELETED");

    } catch (es, st) {
      print("Error in PressedNo>> $es $st");
    }
  }

}
