// ignore_for_file: unused_local_variable, avoid_print

import 'package:b_dep/b_dep.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/widgets/help_widget/help.dart';

List<int> timer = [];

class RequestMade {
  String requestMadePhone;
  String requestMadeName;
  String requestMadeUserId;
  String requestMadeStatus;
  String requestMadeSubject;
  String requestMadePID;
  String requestMadeAskedTime;
  String requestMadeAskedDate;
  String requestMadeCode;
  String requestMadeImage;
  LatLng requestMadePos;
  RequestMade({
    required this.requestMadePhone,
    required this.requestMadeName,
    required this.requestMadeUserId,
    required this.requestMadePID,
    required this.requestMadeStatus,
    required this.requestMadeSubject,
    required this.requestMadeAskedTime,
    required this.requestMadeAskedDate,
    required this.requestMadeCode,
    required this.requestMadeImage,
    required this.requestMadePos,
  });
}

class RequestAccepted {
  String requestAcceptedName;
  String requestAcceptedPhone;
  String requestAcceptedUserId;
  String requestAcceptedPID;
  String requestAcceptedStatus;
  String requestAcceptedSubject;
  String requestAcceptedAskedTime;
  String requestAcceptedAskedDate;
  String requestAcceptedCode;
  String requestAcceptedImage;
  LatLng requestAcceptedPos;
  RequestAccepted({
    required this.requestAcceptedName,
    required this.requestAcceptedPhone,
    required this.requestAcceptedUserId,
    required this.requestAcceptedPID,
    required this.requestAcceptedStatus,
    required this.requestAcceptedSubject,
    required this.requestAcceptedAskedTime,
    required this.requestAcceptedAskedDate,
    required this.requestAcceptedCode,
    required this.requestAcceptedImage,
    required this.requestAcceptedPos,
  });
}

List<RequestMade> requestMadeByUser = [];

List<RequestAccepted> requestAcceptedByUser = [];

List<RequestMade> statusAdd = [];


class HistoryFetch {
  HistoryFetch._privateConstructor();

  static final HistoryFetch instance = HistoryFetch._privateConstructor();

  factory HistoryFetch() {
    return instance;
  }

  // This function is used to create a new request for help to the other trucker.
  Future<void> requestMade(context) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '96800230-fb28-1dbd-82b3-47f4bf97d739',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "userMobileNo": prefs.phoneNumber,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "96800230-fb28-1dbd-82b3-47f4bf97d739",
          jsonData: getJsonData());
      requestMadeByUser.clear();
      for (var res in response) {
        if (res["helpSubject"] != null &&
            res["helpAskedTime"] != null &&
            res["helpAskedDate"] != null &&
            res["helpCode"] != null &&
            res["Name"] != null &&
            res["PID"] != null) {
          RequestMade newDetail = RequestMade(
            requestMadeName: res["Name"],
            requestMadePhone: res["assignedHelperNo"],
            requestMadeStatus: res["helpStatus"],
            requestMadeSubject: res["helpSubject"],
            requestMadeAskedTime: res["helpAskedTime"],
            requestMadeAskedDate: res["helpAskedDate"],
            requestMadeCode: res["helpCode"],
            requestMadeImage: res["profilePic"],
            requestMadePID: res["PID"],
            requestMadeUserId: res["UserId"],
            requestMadePos:
            LatLng(double.parse(res["lat"]), double.parse(res["lng"])),
          );
          if (res["helpStatus"] == "Searching...") {
            statusAdd.add(newDetail);
          }
          requestMadeByUser.add(newDetail);
        }

        for (int i = 0; i < statusAdd.length; i++) {
          if (diffTime(statusAdd[i].requestMadeAskedDate,
              statusAdd[i].requestMadeAskedTime)) {
            statusChange(context, i);
          }
        }



      }

      requestMadeByUser.sort((a, b) {
        String dateTimeString1 = '${a.requestMadeAskedDate} ${a.requestMadeAskedTime}';
        DateFormat dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
        DateTime dateTime1 = dateFormat.parse(dateTimeString1);

        String dateTimeString2 = '${b.requestMadeAskedDate} ${b.requestMadeAskedTime}';
        DateTime dateTime2 = dateFormat.parse(dateTimeString1);

        return dateTime1.millisecondsSinceEpoch.compareTo(dateTime2.millisecondsSinceEpoch);
      });

      requestMadeByUser = requestMadeByUser.reversed.toList();

    } catch (es, st) {
      print("Error in RequestAcceted>> $es $st");
    }
  }

  // This function return the list of the help accepted by the trucker of their fellow truckers.
  Future<void> requestAccepted(context) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '22738280-fb47-1dbd-82b3-47f4bf97d739',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "assignedHelperNo": prefs.phoneNumber,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "22738280-fb47-1dbd-82b3-47f4bf97d739",
          jsonData: getJsonData());
      requestAcceptedByUser.clear();
      for (var res in response) {
        if (res["lat"] != null &&
            res["lng"] != null &&
            res["helpStatus"] != null &&
            res["assignedHelperNo"] != null &&
            res["Name"] != null &&
            res["PID"] != null &&
            res["helpStatus"] != null &&
            res["helpSubject"] != null &&
            res["helpAskedTime"] != null &&
            res["helpAskedDate"] != null &&
            res["helpCode"] != null) {
          if (res["PhoneNumber"] != prefs.phoneNumber) {

              RequestAccepted newYouDetail = RequestAccepted(
              requestAcceptedName: res["Name"],
              requestAcceptedPhone: res["PhoneNumber"],
              requestAcceptedStatus: res["helpStatus"],
              requestAcceptedSubject: res["helpSubject"],
              requestAcceptedAskedTime: res["helpAskedTime"],
              requestAcceptedAskedDate: res["helpAskedDate"],
              requestAcceptedCode: res["helpCode"],
              requestAcceptedPID: res["PID"],
                requestAcceptedImage:res["profilePic"],
                requestAcceptedUserId: res["UserId"],
              requestAcceptedPos:
              LatLng(double.parse(res["lat"]), double.parse(res["lng"])),
            );
            requestAcceptedByUser.add(newYouDetail);
          }
        }
      }
      requestAcceptedByUser = requestAcceptedByUser.reversed.toList();
    } catch (es, st) {
      print("Error in RequestAcceptedByYou>> $es $st");
    }
  }

  // It is Use to find the Time Difference between two time
  bool diffTime(String date, String time) {
    DateTimeComponents dateTimeComponents = getCurrentDateTime();
    String time1 = dateTimeComponents.time;
    String date1 = dateTimeComponents.date;
    String dateTimeString1 = '$date $time';
    String dateTimeString2 = '$date1 $time1';
    DateFormat dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
    DateTime dateTime1 = dateFormat.parse(dateTimeString1);
    DateTime dateTime2 = dateFormat.parse(dateTimeString2);
    Duration difference = dateTime2.difference(dateTime1);
    int days = difference.inDays;
    int seconds = difference.inSeconds;
    if (days >= 1 || seconds >= 1200) {
      return true;
    }
    return false;
  }

  // This function is used to change the status of the request made by the trucker.
  Future<void> statusChange(context, int i) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '230bea80-2ee2-1e11-b908-a14dc3ff091e',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID": statusAdd[i].requestMadePID,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "230bea80-2ee2-1e11-b908-a14dc3ff091e",
          jsonData: getJsonData());
      requestMadeByUser
          .where((item) => item.requestMadePID == statusAdd[i].requestMadePID)
          .forEach((item) {
        item.requestMadeStatus = "Cancelled";
      });
    } catch (es, st) {
      print("Error in RequestAcceptedByYou>> $es $st");
    }
  }
}
