import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:b_dep/b_dep.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trucker/MyNotificationResponse.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/requests/alert_fetch.dart';
import 'package:trucker/requests/calculate_distance.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/requests/message_api.dart';
import 'package:trucker/screens/chat_screen/chat.dart';
import 'package:trucker/screens/navigation_screen/alert_dialog.dart';
import 'package:trucker/screens/navigation_screen/bottom.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/help_widget/help_accepted.dart';
import 'package:trucker/widgets/help_widget/help_other_accepted.dart';
import 'package:trucker/widgets/help_widget/help_requesting_to_other_utils.dart';

const String _NOTIFICATION_CHANNEL_ID="TRUCKER_LINK_NOTIFICATION_ID";

///On main.dart add the following,
///--> initializeBackgroundService();
///
///

final backgroundService = FlutterBackgroundService();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> initializeBackgroundService() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("initializeBackgroundService **");
  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    _NOTIFICATION_CHANNEL_ID, // id
    'TRUCKER LINK SERVICE', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high, // importance must be at low or higher level
  );


  if (Platform.isIOS || Platform.isAndroid) {
    try {
      print("flutterLocalNotificationsPlugin *");
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      print("flutterLocalNotificationsPlugin **");
      await flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            iOS: DarwinInitializationSettings(),
            android: AndroidInitializationSettings('@drawable/ic_notification'),
          ),
          onDidReceiveNotificationResponse: (
              NotificationResponse payload) {
            print("navigateToDesiredPage *");
            navigateToDesiredPage(
                payload.actionId??payload.payload??"",
                context: BottomState.contextForDialogBox
            );
          },
      );
    }catch(e){
      "ERROROROR>> $e";
    }
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await backgroundService.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: _NOTIFICATION_CHANNEL_ID,
      initialNotificationTitle: 'Preparing',
      initialNotificationContent: 'Trucker Link Service',
      foregroundServiceNotificationId: 888,
      autoStartOnBoot: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

}


@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  BackgroundServiceContinuousCheckUtils backgroundUtilsWorker = BackgroundServiceContinuousCheckUtils(service);

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      print("startLocationTracking | Received-SetFore");
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      print("startLocationTracking | Received-SetBack");
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    print("startLocationTracking | Received-StopService");
    //stopLocationTracking();
    service.stopSelf();
  });

  SharedPreferences.getInstance().then((prefs) async{
    if(prefs.getString("phoneNumber")==null) {
      ///This takes care of listening to "Help" requests made by others.
      service.on('startContinuousCheckingService').listen((payload) {
        print("startContinuousCheckingService | Received> $payload");
        backgroundUtilsWorker.startContinuousCheckingService();
      });
    }else {
      backgroundUtilsWorker.startContinuousCheckingService();
    }
  });



  ///This takes care of listening to "Help" requests accepted by others.
  service.on('startHelpRequestToOthersService').listen((payload) {
    print("startHelpRequestToOthersService | Received> $payload");
    backgroundUtilsWorker._startService_checkIfHelpRequestAcceptedByOtherUser(
      payload?["pID"],
      payload?["helpCode"],
      payload?["message"],
    );
  });

  // service.on('startMessageListeningService').listen((payload) {
  //   print("startMessageListeningService | Received> $payload");
  //   backgroundUtilsWorker._startService_checkIfHelpRequestAcceptedByOtherUser(
  //     payload?["pID"],
  //     payload?["helpCode"],
  //     payload?["message"],
  //   );
  // });

  service.on('stopLocationTracking').listen((payload) {
    //stopLocationTracking();
    backgroundUtilsWorker.payload_caseId=null;
  });

  service.on('checkHelpRequestStatus').listen((payload) {
    print("checkHelpRequestStatus | Received> $payload");
    backgroundUtilsWorker.addHelpIdToCheck(
      payload?["code"],
      payload?["helpID"],
      payload?["name"],
    );
  });

  // bring to foreground
  print("Background Service Ready");
}

class BackgroundServiceContinuousCheckUtils{
  BackgroundServiceContinuousCheckUtils(this.service);
  ServiceInstance? service;
  Timer? _timer;
  String? payload_caseId;

  int isLocationWorkingInt=0;
  int updateLocationNotWorkingCounter=0;
  int defaultNotificationId=888;

  ///Key: Code (To manage notifications), Value: HelpId (To use http).
  List<OtherAcceptedHelp> checkHelpRequestStatusData=[];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void startContinuousCheckingService(){
    _continuousCheckWorker();
  }

  void stopContinuousCheckServiceTimer(){
    if(_timer!=null&&_timer!.isActive) {
      _timer?.cancel();
    }
  }

  void _continuousCheckWorker(){

    showNotification(
      defaultNotificationId,
      "Welcome to Trucker Link",
      "Your personal trucker community.",
      isDismisable: true,
    );

    _listenChatMessages();
    _checkHelpRequestStatus();

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      print("Help Noti Called");
      if (service is AndroidServiceInstance) {
          try {
          getHelpRequestNotify((){
            isLocationWorkingInt = 1;
          });
        } catch (e) {
          (service as AndroidServiceInstance).setForegroundNotificationInfo(
            title: "Location Service Error: ",
            content: "${e}",
          );
        }
      }
    });
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (service is AndroidServiceInstance) {
        try {
          getSafetyAlertNotify((){
            isLocationWorkingInt = 1;
          });
        } catch (e) {
          (service as AndroidServiceInstance).setForegroundNotificationInfo(
            title: "Location Service Error: ",
            content: "${e}",
          );
        }
      }
    });
  }

  void _startService_checkIfHelpRequestAcceptedByOtherUser(String pID,
      String helpCode, String message){
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (service is AndroidServiceInstance) {
        try {
          HelpRequestingToOtherUtils().checkIsHelpRequestAcceptedByOtherUser(
              pID, helpCode, message, (response){
            isLocationWorkingInt = 1;

            var jsonString = jsonEncode({
              "id": "help_accepted_by_other_user",
              "response": jsonEncode(response),
              "pId":pID,
              "helpCode":helpCode,
              "message": message,
            });

            showNotification(
                int.parse(helpCode), "Help Accepted by ${response[0]["Name"]}",
                "You may get in touch with them via call or chat.\n"
                    "To know more go to the Help History in the app.",
                isDismisable: true, jsonStringPayload: jsonString,

                ///TODO: Put correct timeout based on time remaining
                ///in the timer to the request.
                timeoutMilliseconds: (1000*60*20)///20 Minutes
            );

          });
        } catch (e) {
          (service as AndroidServiceInstance).setForegroundNotificationInfo(
            title: "Location Help Service Error: ",
            content: "${e}",
          );
        }
      }
    });
  }

  Future<void> getHelpRequestNotify(Function onResultSuccess) async {
    // print("LATLNG -> $startLocation");
    await AlertFetch.instance.getHelpRequestNotification(true,onResultReceived: (
        ///This is used to make sure that even though the notification is not required to be shown,
        ///but we have received the result and the service is working correctly to its parent or
        ///else it will through a notifications saying the service is not working fine.
        bool isShowNotification,

        { String? helpID, String? userName, String? userSubject,
          String? userCode, String? userRequestPhoneNumber,
          String? userRequestEmail, LatLng? position, String? profilePic,
          String? userId,
        }){
      // print("Help Requested by $userName.");
      onResultSuccess.call();
      // print("Details for us -> $helpID $userName $userCode $userRequestPhoneNumber $userRequestEmail $userSubject ${position?.latitude}  ${position?.longitude} ");
      if(isShowNotification&&userName!=null&&userSubject!=null) {
        String jsonStringAcceptButton = MyNotificationResponse().getUserDataStr("acceptId",helpID, userName,
            userCode, userRequestPhoneNumber, userRequestEmail,
            userSubject, position, profilePic, userId);
        String jsonStringOverallNotification = MyNotificationResponse().getUserDataStr("tap_outside_help_requested_id",helpID, userName,
            userCode, userRequestPhoneNumber, userRequestEmail,
            userSubject, position, profilePic, userId);
        print("Create NOti>> $userCode");
        var id = int.parse(userCode!);//888 + (Random().nextInt(1000));
        var title = "Help Requested by $userName.";

        showNotification(
            id, title, userSubject,isShowButtons: true,
            isDismisable: false,jsonStringPayload: jsonStringOverallNotification,
            androidNotificationActions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                  jsonStringAcceptButton, 'Accept',
                  showsUserInterface: true
              ),
              const AndroidNotificationAction(
                'rejectId', 'Reject',
              ),
            ],

            ///TODO: Put correct timeout based on time remaining
            ///in the timer to the request.
            timeoutMilliseconds: (1000*60*20)///20 Minutes
        );
      }
    });
  }

  Future<void> getSafetyAlertNotify(Function onResultSuccess) async {
    // print("Safety Check 0");
    AlertFetch.instance.getSafetyAlertNotification(false,onShowNotification: (AlertDialogShow obj){
      // print("Safety Check 1> ${obj.subject}");
      onResultSuccess.call();
      showNotification(
          int.parse(obj.uuid
              .replaceAll(RegExp(r'[^0-9]'), "")
              .toString()
              .substring(0, 5)), "⚠️ Safety Alert",
          obj.subject,
          isDismisable: true,
          ///TODO: Put correct timeout based on time remaining
          ///in the timer to the request.
          timeoutMilliseconds: (1000*60*20)///20 Minutes
      );
    });
  }

  void showNotification(int id, String title, String subTitle,
      {
        bool isShowButtons=false, bool isDismisable=false,
        List<AndroidNotificationAction>? androidNotificationActions,
        String? jsonStringPayload,
        int? timeoutMilliseconds,
      }){
    // print("Why -> $jsonStringPayload");
    flutterLocalNotificationsPlugin.show(
      id,
      title,
      subTitle,
      payload: jsonStringPayload,
      NotificationDetails(
        android: AndroidNotificationDetails(
          title,
          subTitle,
          subText: subTitle,
          icon: '@drawable/ic_notification',
          ongoing: !isDismisable,
          timeoutAfter: timeoutMilliseconds,
          actions: isShowButtons?(androidNotificationActions
              ??<AndroidNotificationAction>[
             AndroidNotificationAction(
               /*'acceptId'*/jsonStringPayload??"", 'Accept',
               showsUserInterface: true
             ),
            const AndroidNotificationAction(
                'rejectId', 'Reject',
            ),
          ]):null,
          autoCancel: true,
        ),
      ),
    );
  }

  ///Code to open the desired page after clicking on the notification.
  void onDataReceivedWhenAppReopen(BuildContext context){
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      {
        final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

        // print("IsNotiOopen>> ${notificationAppLaunchDetails
        //     ?.didNotificationLaunchApp} | ${notificationAppLaunchDetails
        //     ?.notificationResponse?.actionId} | ${notificationAppLaunchDetails
        //     ?.notificationResponse?.payload}");
        if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
          navigateToDesiredPage(
              notificationAppLaunchDetails?.notificationResponse?.actionId ?? notificationAppLaunchDetails
                  ?.notificationResponse?.payload??"",context: context);
        }
      }
    });
  }

  void _listenChatMessages() async{
    SharedPreferences.getInstance().then((prefs) async{
      // print("BackG-00> ${prefs.getString("userId")}");
      print("G6");
      await Firebase.initializeApp();
      listenChatMessageWorker(prefs: prefs);
    });
  }

  void listenChatMessageWorker({prefs}) async{
    bool isStartFirebaseNotification=false;
    Timer? myFirebaseTimer;
    Timer.periodic(const Duration(seconds: 15), (timer){
      print("detailsUser-0---0>> ${detailsUser}");
      GroupHelper.instance.getAllGroupDetails(mUserId: prefs.getString("userId")).then((value) {
        print("detailsUser-0>> ${detailsUser}");
        detailsUser.forEach((groupDetails) async{

          print("detailsUser>> ${detailsUser}");
          MessageApi.latestMessage(groupDetails.groupID).listen((allMessages) {
            if(allMessages.docs.isNotEmpty) {
              print("current data: ${allMessages.docs.last.data()} | .> ${myFirebaseTimer} | ${isStartFirebaseNotification}");
              if (!isStartFirebaseNotification && myFirebaseTimer == null) {
                myFirebaseTimer = Timer(const Duration(milliseconds: 400), () {
                  myFirebaseTimer = null;
                  isStartFirebaseNotification = true;
                });
              } else if (isStartFirebaseNotification) {
                var latestMessage=allMessages.docs.first.data();
                var chatUId=latestMessage["toG_Id"]+"_"+latestMessage["sendat"];
                if(
                  latestMessage["fromP_ID"]!=prefs.getString("userId") &&
                  !chatMessageNotificationContainId.contains(chatUId)
                ) {
                  print("current data: IN: ${latestMessage}");
                  chatMessageNotificationContainId.add(chatUId);
                  showNotification(
                    int.parse(latestMessage["fromP_ID"]
                        .replaceAll(RegExp(r'[^0-9]'), "")
                        .toString()
                        .substring(0, 5)),
                    "New message from ${latestMessage["fromP_Name"]}",
                    latestMessage["message"],
                    jsonStringPayload: jsonEncode({
                      "id": "new_message",
                      "latestMessage": latestMessage,
                      "groupDetails": groupDetails.toJson(),
                    }),
                    isDismisable: true,
                  );
                }
              }
            }
          });
        });
      });
    });
  }

  void addHelpIdToCheck(String code, String helpId, String name){
    checkHelpRequestStatusData.add(OtherAcceptedHelp(
      code: code,
      name: name,
      pId: helpId,
      message: "",
      email: "",
      flag: false,
      imageUrl: "",
      phoneNumber: "",
      picLocation: const LatLng(0,0),
      request: "",
      userId: "",
    ));
  }

  void _checkHelpRequestStatus(){
    Timer.periodic(const Duration(seconds: 10), (Timer t) {
      // print("_checkHelpRequestStatus>>> ${checkHelpRequestStatusData.length}");
      for (var obj in checkHelpRequestStatusData) {
        // print("_checkHelpRequestStatus-obj>>> ${obj.pId}");
        OtherAcceptedHelpState().getAssuranceAboutStatus(obj.pId,(status){
          // print("Help Done Notification>> $obj.code, ${obj.pId} | status>> ${status}");
          if(status == "Help Done"){
            checkHelpRequestStatusData.remove(obj.code);
            showNotification(
                int.parse(obj.code),
                "Help Completed!",
                "Thanks for helping ${obj.name} in need!",
              isDismisable: true,
            );
          } else  if(status == "Cancelled"){
            checkHelpRequestStatusData.remove(obj.code);
            showNotification(
                int.parse(obj.code),
                "Help Cancelled.",
                "${obj.name} have cancelled the request.",
              isDismisable: true,
            );
          }
        });
      }

    });
  }

}

Future<void> getNameData(Map<String, dynamic> userData) async {

  BSheetsApi bBlupSheetsApi = BSheetsApi(
    'client.blup.white.falcon@gmail.com',
    calledFrom: '9cf8a770-8929-11ee-aba4-61a7eb2406d8',
    // context: context,
  );
  // print("prefs.phoneNumber -> ${prefs.phoneNumber}");
  Map<dynamic, dynamic> getJsonData() {
    Map<dynamic, dynamic> jsonData = {
      "helperNumber":prefs.phoneNumber,
      "helpCode":userData["code"],
    };
    return jsonData;
  }

  try {
    var response = await bBlupSheetsApi.runHttpApi(
        queryId: "9cf8a770-8929-11ee-aba4-61a7eb2406d8",
        jsonData: getJsonData());
    print("Rsssss >>>> ${response}");

  } catch (es, st) {
    print("Error in AcceptedHelp>> $es $st");
  }
}


///This is called once the notification item is tapped.
///This is called on UI thread, not the background thread.
void navigateToDesiredPage(String payload,{service, BuildContext? context}) async{
    print("Why0-0 -> ${jsonDecode(payload)}");
    Map<String, dynamic> userData = jsonDecode(payload);
    print("Why0-1 -> ${userData["id"]}");

      switch(userData["id"]){
        case "acceptId":
          MyNotificationResponse().onHelpAccepted(payload);
          break;
        case "help_accept_call":
          Map<String, dynamic> picLocation = userData['picLocation'];
          //print("Location - ${LatLng(picLocation['latitude'],picLocation['longitude'])}");
          print("payload>> $userData -> ${userData.runtimeType}");
          OtherAcceptedHelpState().callNumber(userData["phoneNumber"]);
          Get.to(OtherAcceptedHelp(name: userData["name"],
            code: userData["code"], phoneNumber: userData["phoneNumber"],
            email: userData["email"],message:userData["message"],
            picLocation: LatLng(picLocation['latitude'],
                picLocation['longitude']), request: 'Accepted', imageUrl: userData['profilePic'], pId:  userData["helpID"], userId: userData['UserId'], flag: false,));
          break;
        case "help_accept_directions":
          Map<String, dynamic> picLocation = userData['picLocation'];
          //print("Location - ${LatLng(picLocation['latitude'],picLocation['longitude'])}");
          print("payload>> $userData -> ${userData.runtimeType}");
          LatLng latLng=LatLng(picLocation['latitude'],
              picLocation['longitude']);
          OtherAcceptedHelpState().gotoMap(latLng);
          Get.to(OtherAcceptedHelp(name: userData["name"],
            code: userData["code"], phoneNumber: userData["phoneNumber"],
            email: userData["email"],message:userData["message"],
            picLocation: latLng, request: 'Accepted', imageUrl: userData['profilePic'], pId:  userData["helpID"], userId: userData['UserId'],flag: false,));
          break;
        case "help_accept_message":
          Map<String, dynamic> picLocation = userData['picLocation'];
          //print("Location - ${LatLng(picLocation['latitude'],picLocation['longitude'])}");
          print("payload>> $userData -> ${userData.runtimeType}");
          OtherAcceptedHelpState().sendMessage();
          Get.off(OtherAcceptedHelp(name: userData["name"],
            code: userData["code"], phoneNumber: userData["phoneNumber"],
            email: userData["email"],message:userData["message"],
            picLocation: LatLng(picLocation['latitude'],
                picLocation['longitude']), request: 'Accepted',
            imageUrl: userData['profilePic'],
            pId:  userData["helpID"],
            userId: userData['UserId'],
            flag: true,
          )
          );
          break;
        case "rejectId":
          MyNotificationResponse()
              .onHelpRejected(userData["helpID"], userData["phoneNumber"],userData["code"]);
          break;
        case "help_accepted_by_other_user":
          var data=jsonDecode(userData["response"])[0];

          double lat = double.parse(data["lat"]);
          double lng = double.parse(data["lng"]);
          LatLng myLatLng = LatLng(lat, lng);

          try {
            Get.off(AcceptedHelp(
              name: data["Name"],
              userId: data["UserId"],
              code: userData["helpCode"],
              phoneNumber: data["PhoneNumber"],
              email: data["Email"],
              message: userData["message"],
              picLocation: myLatLng,
              pId: userData["pId"],
              request: 'Accepted',
              imageUrl: data["profilePic"],
              flag: true,
            ));
          }catch(e){
            print("error-payload>> $e");
          }
          break;
        case "tap_outside_help_requested_id":
          Map<String, dynamic> picLocation = userData['picLocation'];
          // print("BS: Out Get Location Background0 > ${startLocation}");
          var startLocation=await GetCurrentLocation().fetch();
          // print("BS: LatLng for the checking here -> $lat $lng ${startLocation.latitude} ${startLocation.longitude}");
          double dist = CalculateDistance.instance.calculateDistance(
              picLocation['latitude'],
              picLocation['longitude'],
              startLocation.latitude,
              startLocation.longitude);
          // print("BS: Distance for the checking here -> $dist | context> $context");
          String distance = dist.toStringAsFixed(3);
          AlertFetch().showHelpDialog(
              context,
              userData['userId'],
              userData['helpID'],
              userData['name'],
              userData['phoneNumber'],
              userData['email'],
              userData['message'],
              userData['code'],
              distance,
              userData['profilePic'],
              LatLng(picLocation['latitude'],
              picLocation['longitude'])
          );
          break;
        case "tap_outside_id":
          break;
        case "new_message":
          ///This will open the chat screen, after the notification is tapped.
          Get.to(ChatScreen(
            groupDetails: GroupDetails(
                groupMembers: userData["groupDetails"]["groupMembers"],
                groupName: userData["groupDetails"]["groupName"],
                groupID: userData["groupDetails"]["groupID"],
                createBy: userData["groupDetails"]["createBy"]
            ),
          ));
          break;
    }
}



