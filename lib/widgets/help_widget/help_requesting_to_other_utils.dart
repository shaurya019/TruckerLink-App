import 'package:b_dep/b_dep.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/Notification.dart';
import 'package:trucker/widgets/help_widget/help_timer.dart';

class HelpRequestingToOtherUtils{

  Future<void> checkIsHelpRequestAcceptedByOtherUser(pID, helpCode, message, Function onRequestAccepted, {bool isRunBackgroundService=false}) async {
    if(isRunBackgroundService){
      backgroundService.invoke("startHelpRequestToOthersService", {
        "pID":pID,
        "helpCode":helpCode,
        "message": message,
      });
    }

    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'b3a2c620-7e68-1e33-acbf-df3d1580e41c',
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID":pID,
      };
      return jsonData;
    }
    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "b3a2c620-7e68-1e33-acbf-df3d1580e41c",
          jsonData: getJsonData());
       // print("notificationContainHelperId - $response");
        if (response[0]["helpStatus"] == "Accepted" && (notificationContainHelperId.isEmpty ||
            (notificationContainHelperId.isNotEmpty &&
                !notificationContainHelperId.contains(pID)))) {
          notificationContainHelperId.add(pID);
          await _getAssuranceData(pID, onRequestAccepted);
        }
    } catch (es, st) {
      print("Error help>> $es $st");
    }
  }

  Future<void> _getAssuranceData(pID, Function onRequestAccepted) async {
    print("Assured !!!");
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'f38c1820-02be-1dbb-9762-bfe5ae87c236',
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID":pID,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "f38c1820-02be-1dbb-9762-bfe5ae87c236",
          jsonData: getJsonData());
      print("Response for Hello Accepted Help >>> $response");
      onRequestAccepted(response);
    } catch (es, st) {
      print("Error in AcceptedHelp>> $es $st");
    }
  }

}