import "dart:async";
import "dart:math";
import "package:b_dep/b_dep.dart";
import "package:flutter/material.dart";
import "package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:get/get.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:trucker/screens/navigation_screen/bottom.dart";
import "package:trucker/screens/profile_screen/profile.dart";
import "package:trucker/widgets/help_widget/help_accepted.dart";
import "package:trucker/widgets/help_widget/help_group.dart";
import "package:trucker/widgets/help_widget/help_direction.dart";
import "package:trucker/widgets/help_widget/help_requesting_to_other_utils.dart";
import "package:uuid/uuid.dart";

Set<String> notificationContainHelperId = {};

class HelpTimer extends StatefulWidget {
  String value;
  String PID;
  String helpCode;
  int timer;
  HelpTimer({super.key,required this.value,required this.PID,required this.helpCode,required this.timer});

  @override
  State<HelpTimer> createState() => _HelpTimerState();
}

class _HelpTimerState extends State<HelpTimer> {
  late int _timeLeft = widget.timer;
  Timer? _timer;
  bool isReloadParentPageData=false;
  var oneMinute = const Duration(minutes: 60);
  var oneSecond = const Duration(seconds: 1);
  DateTime now = DateTime.now();
  @override

  void initState() {
    super.initState();

    if(widget.timer == 0){
      _timeLeft = 0;
    }
    print("start -> $_timeLeft");
    startTimer();
    if(_timeLeft>0){
      Timer.periodic(const Duration(seconds: 10), (Timer t) {
        if(mounted) {
          HelpRequestingToOtherUtils().checkIsHelpRequestAcceptedByOtherUser(
              widget.PID,
              widget.helpCode,
              widget.value,
                  isRunBackgroundService: true,
                  (response){
                    double lat = double.parse(response[0]["lat"]);
                    double lng = double.parse(response[0]["lng"]);
                    LatLng myLatLng = LatLng(lat, lng);

                    Get.off(AcceptedHelp(name: response[0]["Name"],
                      userId: response[0]["UserId"],code: widget.helpCode,
                      phoneNumber: response[0]["PhoneNumber"],
                      email:  response[0]["Email"],
                      message: widget.value,picLocation: myLatLng,
                      pId: widget.PID,
                      request: 'Accepted', imageUrl: response[0]["profilePic"],flag: true,)
                    );

                    setState(() {
                      _timeLeft = 0;
                    });
              }
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    print("onBuild _timeLeft>> $_timeLeft");

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // top part
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                      // Get.off(Bottom(selectedIndex: 0, newIndex: 0,));
                      // HelpRequestCancel();
                      // Get.back(result: isReloadParentPageData);
                    },
                    borderRadius: BorderRadius.circular(55),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Color(0x1F000000),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/image/back.svg',
                        width: 15.4,
                        height: 13.5,
                        fit: BoxFit.scaleDown,
                        color: const Color(0xFF475467),
                      ),
                    ),
                  ),
                  Container(
                    width: 76,
                    height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(0xFFDBDBDB),
                    ),
                      child: Center(
                        child: Text(
                          _timeLeft <= 0 ? "Cancelled" : "Searching",
                        style:const TextStyle(
                          fontSize: 12,
                          color:Color(0xFF464646),
                        ),
                        ),
                      )
                  )
                ],
              ),
              const SizedBox(height: 32),
              // middle part
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // search glass image
                  Container(
                    child: _timeLeft != 0
                        ? SvgPicture.asset('assets/image/bigsearch.svg',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    )
                        : SvgPicture.asset('assets/image/cross.svg',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // timer
                  _timeLeft != 0
                      ? Container(
                    margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2F3F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            _timeLeft != 0
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                              CircularProgressIndicator(
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    Color(0xFF475466)),
                              ),
                            )
                                : const SizedBox(),
                            const SizedBox(width: 8),
                            Text(
                              'Wait For ${_timeLeft.toString()} mins',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF475466),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      : const Text(
                    'Not able find help',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF475466),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // help message
                  _timeLeft != 0
                      ? const Text(
                    'Finding a fellow trucker to help you out',
                    style: TextStyle(
                      color: Color(0xFF475466),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          InkWell(
                            onTap: () {
                              print("insertIntoHelpDetails");
                              insertIntoHelpDetails();
                            },
                            borderRadius:
                            BorderRadius.circular(100),
                            child: Container(
                              padding:
                              const EdgeInsets.fromLTRB(16, 10, 16, 10),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFCFD4DC)),
                                  borderRadius:
                                  BorderRadius.circular(100),
                                ),
                              ),
                              child: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/image/retryButton.svg',
                                      width: 18,
                                      height: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Retry',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF475466),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                  // central box
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF2F3F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:  Center(
                      child: Column(
                        children: [
                          const Text(
                            'YOUR MESSAGE',
                            style: TextStyle(
                              color: Color(0xFF98A1B2),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                           Text(
                            widget.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF475466),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  // vertical line
                  Container(
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFEAECF0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // Below Part
              _timeLeft != 0  ?
              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              emergencySos();
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFCFD4DC)),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/image/red.svg',
                                    width: 18,
                                    height: 18,
                                    color: const Color(0xFF475467),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'SOS',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF475466),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              Get.to(GroupSelect(helpMessage: widget.value));
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFCFD4DC)),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/image/arrow.svg',
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Send to group',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF475466),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          cancelPopUp();
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: Text(
                            'Cancel Searching',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF475466),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    if(_timer!=null&&_timer!.isActive){
      _timer?.cancel();
    }
    // notificationContainHelperId.clear();
    print("_timeLeft>> ${_timeLeft} | ${widget.timer} | ${_timer?.isActive}");

    _timer = Timer.periodic(
      oneMinute, (Timer timer) {
      print("_timeLeft-->> ${_timeLeft}");
      if (_timeLeft <= 0) {
        timer.cancel();
        _timer?.cancel();
        setState(() {
          _timeLeft = 0;
        });
        helpTimerCancel();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    },
    );
  }

  void cancelPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: IntrinsicHeight(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                'assets/image/danger.svg',
                                width: 30,
                                height: 30,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Are you sure you want to \ncancel the search for help?',
                              style: TextStyle(
                                color: Color(0xFF475466),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color(0xFFF2F3F6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25.0),
                                onTap: () {
                                  Navigator.pop(context);
                                  print("No button pressed");
                                },
                                child: const TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                      color: Color(0xFF475466),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: const Color(0xFFEAECF0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25.0),
                                onTap: () {
                                  setState(() {
                                    widget.timer = 0;
                                    _timeLeft = 0;
                                  });
                                  Navigator.pop(context);
                                  helpRequestCancel();
                                },
                                child: const TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                      color: Color(0xFFDE3730),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void emergencySos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: IntrinsicHeight(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                'assets/image/red2.svg',
                                width: 30,
                                height: 30,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Emergency SOS',
                              style: TextStyle(
                                color: Color(0xFF475466),
                                fontSize: 20,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Call 911?',
                              style: TextStyle(
                                color: Color(0xFF98A1B2),
                                fontSize: 14,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color(0xFFF2F3F6),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  print("No button pressed");
                                },
                                child: const TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                      color: Color(0xFF475466),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: const Color(0xFFEAECF0),
                              child: InkWell(
                                onTap: () {
                                  print("Yes");
                                  FlutterPhoneDirectCaller.callNumber('+911');
                                  Navigator.pop(context);
                                },
                                child: const TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "Call 911",
                                    style: TextStyle(
                                      color: Color(0xFFDE3730),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void helpRequestCancel(){
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi('client.blup.white.falcon@gmail.com', calledFrom: '2ed2ea50-8526-11ee-bbc1-715aa4713bb3', context: context, );

    Map<dynamic,dynamic> getJsonData() {

      Map<dynamic,dynamic> jsonData = {
        "PID": widget.PID,
        "helpStatus": "Cancelled",
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(queryId: "2ed2ea50-8526-11ee-bbc1-715aa4713bb3", jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess=(result) {
      print("Back Navigated");
      Get.back(result: true);
    };
    bBlupSheetsApi.onFailure=(error){
      print("Number for >>> ${prefs.phoneNumber}");
      print("Blup Error is 2 ${error.body}");
    };
  }

  void helpTimerCancel() {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '2ed2ea50-8526-11ee-bbc1-715aa4713bb3', context: context,);

    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID": widget.PID,
        "helpStatus": "Help Not Available",
      };
      return jsonData;
    }

    print("Data ** -> ${widget.PID}");
    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "2ed2ea50-8526-11ee-bbc1-715aa4713bb3",
        jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess = (result) {
      print("Timer Over");
    };
    bBlupSheetsApi.onFailure = (error) {
      print("Number for >>> ${prefs.phoneNumber}");
      print("Blup Error is 4 ${error.body}");
    };
  }

  void insertIntoHelpAskDetails(String number, String pid,String x){
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi('client.blup.white.falcon@gmail.com', calledFrom: '5bde00a0-8514-11ee-bbc1-715aa4713bb3', context: context, );

    //print("Check it >>> $number>>>>$pid");
    Map<dynamic,dynamic> getJsonData() {

      Map<dynamic,dynamic> jsonData = {
        "PID": pid,
        "helpUserNo": prefs.phoneNumber,
        "helperNumber": number,
        "helpCode":x
      };
      print("Data ** -> ${jsonData}");
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(queryId: "5bde00a0-8514-11ee-bbc1-715aa4713bb3", jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess=(result){
      print("Navigated");

    };
    bBlupSheetsApi.onFailure=(error){
      print("Blup Error is Help: ${error}");
    };
  }

  String generateBackendCode() {
    Random random = Random();
    int backendCodeNumber = random.nextInt(9000) + 1000;
    String backendCode = backendCodeNumber.toString();
    return backendCode;
  }

  void insertIntoHelpDetails(){
    String times = "${now.hour}:${now.minute}:${now.second}";
    String date = "${now.year}:${now.month}:${now.day}";
    print('Random Number >>> codeHelp');
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi('client.blup.white.falcon@gmail.com', calledFrom: '5fdbd0b0-e0dc-1e23-af32-5148ca2a0564', context: context, );

    var pid = const Uuid().v1();
    Map<dynamic,dynamic> getJsonData() {

      Map<dynamic,dynamic> jsonData = {
        "PID": widget.PID,
        "helpStatus": "Searching...",
        "helpAskedDate":date,
        "helpAskedTime":times,
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(queryId: "5fdbd0b0-e0dc-1e23-af32-5148ca2a0564", jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess=(result) {
      for(int i=0;i<numberWanted.length;i++){
        insertIntoHelpAskDetails(numberWanted.elementAt(i),widget.PID,widget.helpCode);
      }
      setState(() {
        _timeLeft = 60;
        print("W Calling -------------- $_timeLeft");
        isReloadParentPageData=true;
        startTimer();
      });
    };
    bBlupSheetsApi.onFailure=(error){
      print("Blup Error is 1 ${error.body}");
    };
  }


}


