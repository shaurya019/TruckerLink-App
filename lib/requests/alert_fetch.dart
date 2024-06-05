
// ignore_for_file: use_build_context_synchronously

import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trucker/requests/calculate_distance.dart';
import 'package:trucker/screens/navigation_screen/alert_dialog.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/help_widget/help.dart';
import 'package:trucker/widgets/help_widget/help_dialog.dart';
import '../screens/navigation_screen/bottom.dart';
import '../screens/profile_screen/profile.dart';

class AlertData {
  final String name;
  final String uuid;
  final String userId;
  final String userImage;
  final String subject;
  final String phoneNumber;
  final String date;
  final String time;
  String status;
  final LatLng position;
  final List<String> images;

  AlertData(this.name, this.phoneNumber,this.userId, this.userImage, this.subject, this.uuid, this.position,
      this.date, this.time, this.status, this.images);

}

Map<String, AlertData> alertList = {};
Map<String, AlertData> yourAlert = {};
Map<String, AlertData> totalAlert = {};
List<AlertData> alertsMadeByYou = [];
List<AlertData> alertsMadeByOthers = [];
List<AlertData> alertMarker = [];
List<AlertData> alertPinMarker = [];
Set<String> helpRequestNotificationContainId = {};
Set<String> safetyAlertNotificationContainId = {};
Set<String> helpRequestStatusNotificationContainId = {};
Set<String> chatMessageNotificationContainId = {};

class AlertFetch {
  AlertFetch._privateConstructor();

  static final AlertFetch instance = AlertFetch._privateConstructor();
  final double maxKM=25;///25 KM

  factory AlertFetch() {
    return instance;
  }
  DateTime convert(
      String date1,
      String time1,
      ) {
    List<String> dateComponents = date1.split(":");
    List<String> timeComponents = time1.split(":");
    int year = int.parse(dateComponents[0]);
    int month = int.parse(dateComponents[1]);
    int day = int.parse(dateComponents[2]);
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);
    int second = int.parse(timeComponents[2]);
    DateTime dateTime1 = DateTime(year, month, day, hour, minute, second);
    return dateTime1;
  }

  // This function is used to an notification alert to the user
  // when ever a new help request is received.
  Future<void> getHelpRequestNotification(
      ///If the [getHelpRequestNotification] is called from BackgroundService,
      ///then make [calledFromBackgroundNotification] true, or else false.
    bool calledFromBackgroundNotification,
      {
        bool isShowPopUp = false,
        BuildContext? context,
        Function(bool isShowNotification,
            {String? helpID,
            String? userName,
            String? userSubject,
            String? userCode,
            String? userRequestPhoneNumber,
            String? userRequestEmail,
            LatLng? position,
            String? profilePic,
            String? userId,
            })? onResultReceived}) async {
    // print("called from notify>> $calledFromBackgroundNotification");
    // print("main function >> $onResultReceived");
    DateTime now = DateTime.now();
    String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    String date = "${now.year}:${now.month}:${now.day}";
    final prefs = await SharedPreferences.getInstance();

    ///As we need [reload] only when running
    ///background service for notifications.
    if(!isShowPopUp) {
      await prefs.reload();
    }
    String? phoneNum = prefs.getString("phoneNumber");

    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '362dd360-8543-11ee-977b-af3f5f4de9c8',
      //context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {'helperNumber': phoneNum};
      return jsonData;
    }

    try {
      // print("inside tyr loop with notify $calledFromBackgroundNotification with json data >> $getJsonData()");
      var result = await bBlupSheetsApi.runHttpApi(
          queryId: "362dd360-8543-11ee-977b-af3f5f4de9c8",
          jsonData: getJsonData());
      print("-R-> ${result} from notify $calledFromBackgroundNotification | $phoneNum");

      //var result=response.body;
      double? lat;
      double? lng;

      if((result is List)&&result.isNotEmpty) {
        print("inside if statement with notify $calledFromBackgroundNotification");
        var startLocation=await GetCurrentLocation().fetch();
        for (Map<String,dynamic> data in result) {
          // print("inside 0");
          userStatus = data["helpStatus"];
          helpID = data["PID"];
          userID = data["UserId"];
          userSubject = data["helpSubject"];
          userTime = data["helpAskedTime"];
          userDate = data["helpAskedDate"];
          userCode = data["helpCode"];
          userRequestName = data["Name"];
          userRequestImage = data["profilePic"];
          userRequestPhoneNumber = data["PhoneNumber"];
          userRequestEmail = data["Email"];
          lat = double.parse(data["lat"]);
          lng = double.parse(data["lng"]);
          userRequestLatLng = LatLng(lat, lng);
          DateTime x = convert(date, formattedTime);
          DateTime y = convert(userDate, userTime);
          Duration difference = x.difference(y);
          secTime = difference.inSeconds;

          // ///Below code is to add startLocation if the service is in Background.
          // if(calledFromBackgroundNotification){
          //   // print("Inside Get Location Background");
          //   Position data = await SplashState().determinePosition();
          //   startLocation=LatLng(data.latitude, data.longitude);
          //   // print("Inside Get Location Background0 > ${startLocation}");
          // }
          // print("inside 1");
          // print("LatLng for the checking here -> $lat $lng ${startLocation.latitude} ${startLocation.longitude}");
          double dist = CalculateDistance.instance.calculateDistance(
              lat,
              lng,
              startLocation.latitude,
              startLocation.longitude);
          // print("Distance for the checking here -> $dist | $lat | $lng | ${startLocation.latitude} | ${startLocation.longitude}");
          double distanceInKm = dist; //* 1000.0;//* 1609.34;
          String distanceInKmStr = dist.toStringAsFixed(3);
          // print("inside 2");

          // print("result of person is $data and dis $distance");
          // print("1st con>> back>${calledFromBackgroundNotification} ${(helpRequestNotificationContainId.isEmpty || (helpRequestNotificationContainId.isNotEmpty && !helpRequestNotificationContainId.contains(helpID)))} | ${helpRequestNotificationContainId}");
          // print("2nd cod>> ${phoneNum != userRequestPhoneNumber} | myPh> $phoneNum | otherPh> $userRequestPhoneNumber");
          // print("3rd cod>> ${ distanceInKm <= maxKM} here meter is $distanceInKm");
          if ((helpRequestNotificationContainId.isEmpty || (helpRequestNotificationContainId.isNotEmpty && !helpRequestNotificationContainId.contains(helpID)))
              && phoneNum != userRequestPhoneNumber
              && distanceInKm <= maxKM)
          {
            helpRequestNotificationContainId.add(helpID);
            // print("Decline -> $phoneNum -> $userRequestPhoneNumber");
            // print("distance get -> $distance");
            // print("INNNN?01");
            // print("onResultReceived -> $onResultReceived");
            if(onResultReceived!=null) {
              onResultReceived(
                true,
                helpID: helpID,
                userName: userRequestName,
                userSubject: userSubject,
                userCode: userCode,
                userRequestPhoneNumber: userRequestPhoneNumber,
                userRequestEmail: userRequestEmail,
                position: LatLng(lat, lng),
                profilePic: userRequestImage,
                userId: userID
              );
            print("onResultReceived -> $onResultReceived");
            } else if(isShowPopUp&&context!=null
                &&userRequestPhoneNumber!=phoneNum && distanceInKm <= maxKM){
              // print("Show popup -> $phoneNum -> $userRequestPhoneNumber");
              showHelpDialog(context, userID, helpID, userRequestName, userRequestPhoneNumber, userRequestEmail, userSubject, userCode, distanceInKmStr, userRequestImage, userRequestLatLng);
            }
          }else{
          }
        }
      }else if(onResultReceived!=null){
        onResultReceived(
          false,
        );
      }else{
        print("getNotification");
      }



    } catch (es, st) {
      print("Error getNotification>> $es $st");
    }
  }

  ///Called If the app is open already when
  ///receiving a help request.
  Future<void> showHelpDialog(context,String userIDOfUser,String helpIDOfUser,String userRequestNameOfUser,String userRequestPhoneNumberOfUser,String userRequestEmailOfUser,String userSubjectOfUser,String userCodeOfUser,String distanceOfUser,String userRequestImageOfUser,LatLng userRequestLatLngOfUser) async {
    if(context!=null) {
      showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // print("Dialog **-> $userRequestNameOfUser $userSubjectOfUser $distanceOfUser");
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            insetPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: HelpDialog(
                userID: userIDOfUser,
                helpID:helpIDOfUser,
                userRequestName: userRequestNameOfUser,
                userNumber: userRequestPhoneNumberOfUser,
                userRequestLatLng: userRequestLatLngOfUser,
                userRequestEmail: userRequestEmailOfUser,
                userSubject: userSubjectOfUser,
               userRequestImage:userRequestImageOfUser,
                userCode: userCodeOfUser,
                distance:distanceOfUser,
            ),
          );
        },
      );
    }
  }

  Future<void> getSafetyAlertNotification(
      ///[isShowDialogBox] is true if used in the UI thread,
      ///It is false if used in background process.
      ///
      ///Note: Supply [context] if the [isShowDialogBox] is true.
      ///It is used to show the dialog box.
      bool isShowDialogBox,{
        BuildContext? context,
        Function(AlertDialogShow)? onShowNotification,
      }) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '067b2cc0-d7d9-1dd3-a885-17d6006ef83c',
      // '0e2ef190-077a-1dd1-a885-17d6006ef83c',
      // context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {};
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "067b2cc0-d7d9-1dd3-a885-17d6006ef83c",
          jsonData: getJsonData());
      if(response is http.Response) {
        print("res> ${response.body}");
      }else if(response is String) {
        print("res-error> ${response}");
      }else {
        //print("res-0> ${response}");
        List<dynamic> res = response;
        yourAlert.clear();
        alertList.clear();
        totalAlert.clear();
        alertsMadeByYou.clear();
        alertsMadeByOthers.clear();
        alertMarker.clear();
        alertPinMarker.clear();
        for (int i = 0; i < res.length; i++) {
          if (res[i]["Name"] != null &&
              res[i]["Subject"] != null &&
              res[i]["uid"] != null &&
              res[i]["PhoneNumber"] != null &&
              res[i]["Lat"] != null &&
              res[i]["Lng"] != null) {
            var id = res[i]['uid'];
            double latitude1 = double.parse(res[i]["Lat"]);
            double longitude1 = double.parse(res[i]["Lng"]);
            LatLng coordinates = LatLng(latitude1, longitude1);
            String date = res[i]["alertDate"];
            String time = res[i]["alertTime"];
            String status = res[i]["Status"];
            if (!alertList.containsKey(id) && status == "Active") {
              alertList[id] = AlertData(
                  res[i]["Name"],
                  res[i]["PhoneNumber"],
                  res[i]["UserId"],
                  res[i]["profilePic"],
                  res[i]["Subject"],
                  res[i]["uid"],
                  coordinates,
                  date,
                  time,
                  status,
                  []);
            }
            var image = res[i]['Image'];
            if (image != null) {
              alertList[id]?.images.add(image);
            }
            DateTimeComponents dateTimeComponents = getCurrentDateTime();
            String time1 = dateTimeComponents.time;
            String date1 = dateTimeComponents.date;
            String dateTimeString1 = '$date $time';
            String dateTimeString2 = '$date1 $time1';
            DateFormat dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
            DateTime dateTime1 = dateFormat.parse(dateTimeString1);
            DateTime dateTime2 = dateFormat.parse(dateTimeString2);
            Duration difference = dateTime2.difference(dateTime1);
            int hours = difference.inHours;
            if ((status == "Active" || status == "Removed") && hours >= 8) {
              await updateStatus(res[i]["uid"]);
            }
            if (res[i]["PhoneNumber"] == prefs.phoneNumber) {
              if (!yourAlert.containsKey(id)) {
                yourAlert[id] = AlertData(
                    res[i]["Name"],
                    res[i]["PhoneNumber"],
                    res[i]["UserId"],
                    res[i]["profilePic"],
                    res[i]["Subject"],
                    res[i]["uid"],
                    coordinates,
                    date,
                    time,
                    status,
                    []);
              }
              var image = res[i]['Image'];
              if (image != null) {
                yourAlert[id]?.images.add(image);
              }
            } else {
              if (!totalAlert.containsKey(id)) {
                totalAlert[id] = AlertData(
                    res[i]["Name"],
                    res[i]["PhoneNumber"],
                    res[i]["UserId"],
                    res[i]["profilePic"],
                    res[i]["Subject"],
                    res[i]["uid"],
                    coordinates,
                    date,
                    time,
                    status,
                    []);
              }
              var image = res[i]['Image'];
              if (image != null) {
                totalAlert[id]?.images.add(image);
              }
            }
          }
        }
        alertsMadeByYou = yourAlert.values.toList();
        alertsMadeByYou = alertsMadeByYou.reversed.toList();
        alertsMadeByOthers = totalAlert.values.toList();
        alertsMadeByOthers = alertsMadeByOthers.reversed.toList();
        alertMarker = alertList.values.toList();
        // print("alertMarker>> %${alertMarker} | ${onShowNotification}");

        var startLocation=await GetCurrentLocation().fetch();

        for (int i = 0; i < alertMarker.length; i++) {
          // print("alertMarker>>-01 %${alertMarker} | ${onShowNotification}");

          double distanceInKm = CalculateDistance.instance.calculateDistance(
              alertMarker[i].position.latitude,
              alertMarker[i].position.longitude,
              startLocation.latitude,
              startLocation.longitude);


          if (distanceInKm < maxKM) {
            alertPinMarker.add(alertMarker[i]);

            if (!safetyAlertNotificationContainId.contains(alertMarker[i].uuid)
                && alertPresent == false &&
                alertMarker[i].phoneNumber != prefs.phoneNumber) {
              safetyAlertNotificationContainId.add(alertMarker[i].uuid);
              var obj = AlertDialogShow(
                  uuid: alertMarker[i].uuid,
                  name: alertMarker[i].name,
                  subject: alertMarker[i].subject,
                  userImage: alertMarker[i].userImage,
                  imageList: alertMarker[i].images
              );

              if (onShowNotification != null) {
                onShowNotification(obj);
              }

              if (isShowDialogBox) {
                showDialog(
                  context: context!,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: obj,
                    );
                  },
                );
              }
            }
          }
        }
      }
    } catch (es, st) {
      print("Error getNotification>> $es $st");
    }
  }

  // This function is used to calculate the Distance between two user so that they can show as a near by person.
  Future<void> updateStatus(String uuid, /*context*/) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '12626ec0-1d91-1ddd-a911-592cec524104',
      // context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "uid": uuid,
        "Status": "Disable",
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "12626ec0-1d91-1ddd-a911-592cec524104",
          jsonData: getJsonData());
    } catch (es, st) {
      print("Error in InsertIntoAlert>> $es $st");
    }
  }



  Future<void> GetSearchNotify(BuildContext? context) async {
    DateTime now = DateTime.now();
    String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    String date = "${now.year}:${now.month}:${now.day}";
    ///As we need [reload] only when running
    ///background service for notifications.
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'd9103850-5602-1e5a-8ead-a772a7fd1f0a',
      //context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {};
      return jsonData;
    }

    try {
      var result = await bBlupSheetsApi.runHttpApi(
          queryId: "d9103850-5602-1e5a-8ead-a772a7fd1f0a",
          jsonData: getJsonData());
        for (var data in result) {
          // print("Coming till here");
          helpID = data["PID"];
          userTime = data["helpAskedTime"];
          userDate = data["helpAskedDate"];
          DateTime x = convert(date, formattedTime);
          DateTime y = convert(userDate, userTime);
          Duration difference = x.difference(y);
          secTime = difference.inMinutes;
          // print("data -> ${helpID} ${secTime}");
          if(secTime >= 60){
            // print("Coming till here too -> ${helpID} ${secTime}");
            UpdateCancelNotify(context,data["PID"]);
          }
      }
    } catch (es, st) {
      print("Error getNotification>> $es $st");
    }
  }

  Future<void> UpdateCancelNotify(BuildContext? context,String userHelpID) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '1044ac20-68f5-1e5a-8ead-a772a7fd1f0a',
      //context: context,
    );
    print("Get in");
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        'PID':userHelpID,
      };
      return jsonData;
    }

    try {
      var result = await bBlupSheetsApi.runHttpApi(
          queryId: "1044ac20-68f5-1e5a-8ead-a772a7fd1f0a",
          jsonData: getJsonData());
      print("Cancelled -> $userHelpID");
    } catch (es, st) {
      print("Error getNotification>> $es $st");
    }
  }

}
