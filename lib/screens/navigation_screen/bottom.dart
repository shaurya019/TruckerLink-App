// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'package:b_dep/b_dep.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trucker/Notification.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/main.dart';
import 'package:trucker/requests/alert_fetch.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/requests/histroy_fetch.dart';
import 'package:trucker/requests/message_api.dart';
import 'package:trucker/screens/friends_screen/friends.dart';
import 'package:trucker/screens/help_screen/help_screen.dart';
import 'package:trucker/screens/navigation_screen/alert_dialog.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:flutter/services.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';

bool isLoadingHistory = true;
bool dialogPresent = false;
bool alertPresent = false;
String userNumber = '';
String userStatus = '';
String userID = '';
String helpID = '';
String userRequestName = '';
String userRequestImage = ' ';
String userRequestPhoneNumber = '';
String userRequestEmail = '';
LatLng userRequestLatLng = const LatLng(0, 0);
String userSubject = '';
String userTime = '';
String userDate = '';
String userCode = '';
int secTime = 0;
late Timer _timer;
List<CameraDescription> cameras = [];

class Bottom extends StatefulWidget {
  final int selectedIndex;
  int newIndex;
  Bottom({
    Key? key,
    required this.selectedIndex,
    required this.newIndex,
  }) : super(key: key);

  @override
  State<Bottom> createState() => BottomState();
}

class BottomState extends State<Bottom> with WidgetsBindingObserver {
  PageController? _pageController;

  GlobalKey friendsKey=GlobalKey();

  ///[contextForDialogBox] is needed to pass
  ///in dialog box in [Notification.dart] file.
  ///It needs to be static as the calling is from
  ///Notification function which does not have access
  ///to the BuildContext.
  static BuildContext? contextForDialogBox;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getSafetyAlertNotify(context: context);
      Timer.periodic(const Duration(seconds: 10), (Timer t) {
        getSafetyAlertNotify(context:navigatorKey.currentContext!,);
      });
    }
    if (mounted) {
      getNotify(context: context);
      print("getNotify");
      Timer.periodic(const Duration(seconds: 10), (Timer t) {
        getNotify(context:navigatorKey.currentContext!,);
      });
    }
    if (mounted) {
      print("getCancelNotify");
      getCancelNotify(context: context);
      Timer.periodic(const Duration(hours: 1), (Timer t) {
        getCancelNotify(context:navigatorKey.currentContext!);
      });
    }
    _pageController = PageController(initialPage: widget.selectedIndex);
    WidgetsBinding.instance.addObserver(this);
    updateStatusOfUser("Online","initState");
    initBackgroundNotification(context);
    listenChatMessageWorker(mPrefs: prefs);
  }

  void listenChatMessageWorker({SharedPreferencesService? mPrefs}) async{
    bool isStartFirebaseNotification=false;
    Timer? myFirebaseTimer;
    Timer.periodic(const Duration(seconds: 25), (timer){
      print("bottom detailsUser0-1");
      GroupHelper.instance.getAllGroupDetails(mUserId: mPrefs?.userId).then((value) {
        print("bottom detailsUser0>> ${detailsUser}");
        detailsUser.forEach((groupDetails) async{

          print("bottom detailsUser1>> ${detailsUser}");
          MessageApi.latestMessage(groupDetails.groupID).listen((allMessages) {
            if(allMessages.docs.isNotEmpty) {
              print("bottom current 0data: ${allMessages.docs.last.data()} | .> ${myFirebaseTimer} | ${isStartFirebaseNotification}");
              if (!isStartFirebaseNotification && myFirebaseTimer == null) {
                myFirebaseTimer = Timer(const Duration(milliseconds: 400), () {
                  myFirebaseTimer = null;
                  isStartFirebaseNotification = true;
                });
              } else if (isStartFirebaseNotification) {
                var latestMessage=allMessages.docs.first.data();
                var chatUId=latestMessage["toG_Id"]+"_"+latestMessage["sendat"];
                if(latestMessage["fromP_ID"]!=mPrefs?.userId &&
                    !chatMessageNotificationContainId.contains(chatUId)
                ) {
                  // print("bottom current 1data: IN: ${latestMessage["fromP_ID"].replaceAll(
                  //     RegExp(r'[^0-9]'), "").toString().substring(0, 5)}");
                  chatMessageNotificationContainId.add(chatUId);
                  var newData=dataMap[groupDetails.groupID];
                  if(newData!=null){
                    newData.latestMessage=latestMessage["message"];
                    newData.isNewMessage=true;
                    if(!individualData.any((element) => element.pId==newData.pId)) {
                      individualData.add(newData);
                    }else{
                      individualData.removeWhere((element) => element.pId==newData.pId);
                      individualData.add(newData);
                    }
                    dataMap[groupDetails.groupID] = newData;
                    // print("bottom -=-=> ${groupDetails.groupID}");
                    friendsKey.currentState?.setState(() {});
                  }
                }
              }
            }
          });
        });
      });
    });
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        updateStatusOfUser("Online","resume");
        break;
      case AppLifecycleState.inactive:
        updateStatusOfUser("Offline","inactive");
        break;
      case AppLifecycleState.paused:
        // updateStatusOfUser("Offline","paused");
        break;
      case AppLifecycleState.detached:
        // updateStatusOfUser("Offline","detached");
        break;
      case AppLifecycleState.hidden:
        updateStatusOfUser("Offline","hidden");
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    // print("Bottom");
    return Scaffold(
      body: Stack(children: [
        PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              widget.newIndex = index;
            });
          },
          controller: _pageController,
          children: [
            HelpScreen(
              onTap: () {
                setState(() {
                  widget.newIndex = 0;
                  _pageController?.animateToPage(1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear);
                  print("HelpScreen >>>> ${widget.newIndex}");
                });
              },
              onOpenFriendsTabCalled: (){
                widget.newIndex = 1;
                _pageController?.animateToPage(1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear);
                //print("HelpScreen >>>> ${widget.newIndex}");
              },
            ),
            friendsKey.currentWidget??
            Friends(
              key: friendsKey,
              onTap: () {
                setState(() {
                  widget.newIndex = 1;
                });
              },
            ),
            const Profile(),
          ],
        ),
      ]),
      bottomNavigationBar: BottomNavigationBarTheme(
        data: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFFF8D49),
          unselectedItemColor: Color(0xFF667085),
        ),
        child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: widget.newIndex == 0
                        ? const Color(0xFFFF8D49)
                        : Colors.transparent,
                  ),
                  child: SvgPicture.asset('assets/image/h.svg',
                      width: 18,
                      height: 18.73,
                      color: widget.newIndex == 0
                          ? Colors.white
                          : const Color(0xFF667085)),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: widget.newIndex == 1
                          ? const Color(0xFFFF8D49)
                          : Colors.transparent,
                    ),
                    child: SvgPicture.asset('assets/image/fm.svg',
                        width: 18,
                        height: 18.73,
                        color: widget.newIndex == 1
                            ? Colors.white
                            : const Color(0xFF667085)),
                  ),
                  label: 'Friends'),
              BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: widget.newIndex == 2
                          ? const Color(0xFFFF8D49)
                          : Colors.transparent,
                    ),
                    child: Icon(
                      Icons.person,
                      color: widget.newIndex == 2
                          ? Colors.white
                          : const Color(0xFF667085),
                    ),
                  ),
                  label: 'Profile'),
            ],
            currentIndex: widget.newIndex,
            onTap: (index) {
              setState(() {
                //index = index;
                _pageController?.animateToPage(index,
                    duration: const Duration(microseconds: 200),
                    curve: Curves.linear);
              });
            }),
      ),
    );
  }



  Future<void> getNotify({required BuildContext context}) async {
    // print("getNotify **");
    await AlertFetch.instance.getHelpRequestNotification(false,isShowPopUp: true,context: context);
    if(mounted){
      setState(() {
        isLoadingHistory = false;
      });
    }
  }

  Future<void> getCancelNotify({required BuildContext context}) async {
    print("postCancelNotify **");
    await AlertFetch.instance.GetSearchNotify(context);
  }

  Future<void> getSafetyAlertNotify({required BuildContext context}) async {
    await AlertFetch.instance.getSafetyAlertNotification(true,context: context);
   if(mounted && isLoadingHistory == true){
     setState(() {
       isLoadingHistory = false;
     });
   }
  }

  // Future<void> loadRequestHistory1({required BuildContext context}) async {
  //   await HistoryFetch.instance.requestAccepted(context);
  // }
  //
  // Future<void> loadRequestHistory2({required BuildContext context}) async {
  //   await HistoryFetch.instance.requestMade(context);
  //   setState(() {
  //     isLoadingHistory = false;
  //   });
  // }


  void updateStatusOfUser(String Status,String Coming){
    DateTime now = DateTime.now();
    String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    String date = "${now.year}:${now.month}:${now.day}";
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi('client.blup.white.falcon@gmail.com', calledFrom: '4c0223c0-aed2-1e76-9c31-f5cc3134c09c', context: context, );

    Map<dynamic,dynamic> getJsonData() {

      Map<dynamic,dynamic> jsonData = {
        "date": date,
        "time":formattedTime,
        "status":Status,
        "UserId":prefs.userId
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(queryId: "4c0223c0-aed2-1e76-9c31-f5cc3134c09c", jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess=(result){
      print("Done");
    };
    bBlupSheetsApi.onFailure=(error){
      print("Blup error - $error");
    };
  }


 void initBackgroundNotification(BuildContext context) async{
   BackgroundServiceContinuousCheckUtils(null).onDataReceivedWhenAppReopen(context);
   contextForDialogBox=context;

   await backgroundService.startService();
   backgroundService.invoke("startContinuousCheckingService", {});
 }

}
