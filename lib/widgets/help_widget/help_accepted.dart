import "dart:async";
import "dart:convert";
import "package:b_dep/b_dep.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart";
import "package:flutter_stripe/flutter_stripe.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:trucker/global/global_class.dart";
import "package:trucker/requests/calculate_distance.dart";
import "package:trucker/requests/histroy_fetch.dart";
import "package:http/http.dart" as http;
import "package:trucker/screens/navigation_screen/bottom.dart";
import "package:trucker/screens/splash_screen/splash.dart";
import "package:trucker/screens/welcome_screen/welcome.dart";
import "package:trucker/widgets/friends_widget/group_list.dart";
import "package:trucker/widgets/help_widget/help_group.dart";
import "package:trucker/widgets/help_widget/help_history_page.dart";
import "package:trucker/widgets/help_widget/help_polyline_map.dart";
import "package:url_launcher/url_launcher.dart";
import "package:trucker/screens/chat_screen/chat.dart";
import "package:trucker/widgets/help_widget/help_direction.dart";
import "package:uuid/uuid.dart";

import "../../screens/profile_screen/profile.dart";

class AcceptedHelp extends StatefulWidget {
  String name;
  String userId;
  String pId;
  String code;
  String phoneNumber;
  String email;
  String message;
  LatLng picLocation;
  String request;
  String imageUrl;
  bool flag;
  final VoidCallback? onRefresh;
  AcceptedHelp(
      {super.key,
        required this.name,
        required this.userId,
        required this.pId,
        required this.code,
        required this.phoneNumber,
        required this.email,
        required this.picLocation,
        required this.message,
        required this.request,
        required this.imageUrl,
        required this.flag,
        this.onRefresh});

  @override
  State<AcceptedHelp> createState() => _AcceptedHelpState();
}

class _AcceptedHelpState extends State<AcceptedHelp> {
  late Uri dialNumber;
  TextEditingController moneyAdd = TextEditingController();
  Map<String, dynamic>? paymentIntentData;
  String distance="";

  @override
  void initState() {
    super.initState();
    distanceCalculated(true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void distanceCalculated(bool isCallSetState) async{
    var startLocation=await GetCurrentLocation().fetch();
    distance = CalculateDistance.instance.calculateDistance(widget.picLocation.latitude,widget.picLocation.longitude,startLocation.latitude,startLocation.longitude).toStringAsFixed(2);
    if(isCallSetState){
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    distanceCalculated(false);
    //print("Dis -> $distance Location -> ${startLocation.latitude} -> ${startLocation.longitude}");
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(55),
                      onTap: () {
                        Get.back();
                        // if(widget.flag){
                        //   Get.back();
                        //   // Get.off(Bottom(selectedIndex: 0, newIndex: 0,));
                        // }else{
                        //   print("Back called");
                        //   Get.back();
                        //   // Get.off(HistoryPage(firstpage: true,));
                        // }
                      },
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
                    IntrinsicWidth(
                      child: Container(
                        height: 22,
                        width: 76,
                        decoration: BoxDecoration(
                          color:
                          widget.request == "Help Not Available" ?
                          Color(0xFFFFE3E3)
                              :
                          widget.request == "Accepted" ?
                          Color(0xFF238816)
                              :
                          widget.request == "Cancelled" ?
                          Color(0xFFFFE3E3)
                              :
                          Color(0xFFDBDBDB),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            widget.request == "Help Not Available" ? "UnfullFiled":
                            widget.request == "Help Done" ?
                            "Fullfilled":
                            widget.request,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:  widget.request == "Accepted" ? Color(0xFFD6FFD8) : Color(0xFF464646),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Code : ',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475467), // Text color for "Code : "
                          ),
                        ),
                        TextSpan(
                          text: widget.code,
                          style: const TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFEC6A00), // Text color for "2450"
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your request has been accepted',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475467), // Text color
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                    // height: widget.request == "Accepted" ? 424 : 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              widget.imageUrl != "x"
                                  ?
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                NetworkImage(widget.imageUrl),
                              )
                                  :
                              Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2970FF),
                                  borderRadius: BorderRadius.circular(34),
                                ),
                                child: SvgPicture.asset(
                                  'assets/image/person.svg',
                                  height: 18.33,
                                  width: 15,
                                  color: Colors.white,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 15,),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            widget.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFF475467),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        //Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "$distance Miles Away",
                                            style: const TextStyle(
                                              color: Color(0xFFFF8D49),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4,),
                                    IntrinsicWidth(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Container(
                                          height: 22,
                                          //width: 176,
                                          padding: const EdgeInsets.only(left: 10,right: 10),
                                          decoration: BoxDecoration(
                                            color:
                                            widget.request == "Help Not Available" ?
                                            Color(0xFFFFE3E3)
                                                :
                                            widget.request == "Accepted" ?
                                            Color(0xFF238816).withOpacity(0.2)
                                                :
                                            widget.request == "Cancelled" ?
                                            Color(0xFFFFE3E3)
                                                :
                                            Color(0xFFDBDBDB),
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                          child: Center(
                                            child: Text("Your request have been ${(widget.request == "Help Not Available" ? "UnfullFiled":
                                            widget.request == "Help Done" ?
                                            "Fullfilled":
                                            widget.request).toLowerCase()}.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color:  widget.request == "Accepted" ? Color(0xFF238816) : Color(0xFF464646),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          )
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 19.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  dialNumber = Uri(
                                      scheme: 'tel', path: widget.phoneNumber);
                                  callNumber(dialNumber);
                                },
                                child: Container(
                                  width: 92,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFFF8D49),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1,
                                        // color: Color(0xFFCFD4DC)
                                        color: Color(0xFFFF8D49),
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/image/call.svg',
                                        width: 18,
                                        height: 18,
                                        color: Colors.white
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Call',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async{
                                  NearbyPerson person = NearbyPerson(
                                    widget.name,
                                    widget.imageUrl,
                                    widget.phoneNumber,
                                    widget.userId,
                                    '',
                                    "Offline",
                                    ""
                                  );
                                  await GroupListState().checkForExistingGroup(person);
                                },
                                child: Container(
                                  width: 172,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/image/arrow.svg',
                                        width: 18,
                                        height: 18,
                                        color: const Color(0xFF475467),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Send Message',
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
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if(widget.request == "Accepted")
                        Padding(
                          padding: const EdgeInsets.only(left: 19.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  gotoMap();
                                },
                                child: Container(
                                  width: 135,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1,
                                        // color: Color(0xFFCFD4DC)
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/image/pin.svg',
                                        width: 18,
                                        height: 18,
                                        color: const Color(0xFF475467),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Directions',
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
                              InkWell(
                                onTap: () {
                                  emergencySos();
                                },
                                child: Center(
                                  child: Container(
                                    width: 95,
                                    height: 40,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/image/red.svg',
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
                              ),
                            ],
                          ),
                        ),
                        if(widget.request == "Accepted")
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAECF0),
                            border: Border.all(
                              color: const Color(0xFFEAECF0),
                              width: 1, // Border width
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 19.0),
                          child: Text(
                            'Your Message',
                            style: TextStyle(
                                fontFamily: 'SF Pro',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF98A2B3)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 19.0),
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                                fontFamily: 'SF Pro',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF475467)),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        widget.request == "Accepted"
                            ? Padding(
                            padding: const EdgeInsets.only(left: 19.0),
                            child: InkWell(
                              onTap: () {
                                pressDone();
                                updateAccept(widget.pId,'Help Done');
                                widget.onRefresh?.call();
                                widget.request = "Help Done";
                                setState(() {});
                              },
                              child: Container(
                                width: 189,
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF238816),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFFCFD4DC)),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: 25,
                                      color: Color(0xFFD6FFD8),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Request Complete',
                                      style: TextStyle(
                                        color: Color(0xFFD6FFD8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                            : Container(),
                        widget.request == "Accepted"
                            ? const SizedBox(
                          height: 8,
                        )
                            : Container(),
                        widget.request == "Accepted"
                            ? Padding(
                          padding: const EdgeInsets.only(left: 19.0),
                          child: InkWell(
                            onTap: () {
                              helpRequestCancel();
                              updateAccept(widget.pId,'Cancelled');
                              widget.onRefresh?.call();
                            },
                            child: Container(
                              width: 172,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFCFD4DC)),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/image/cross.svg',
                                    width: 24,
                                    height: 24,
                                    color: const Color(0xFF475467),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Cancel Request',
                                    style: TextStyle(
                                      color: Color(0xFF475467),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            : Container(),
                        widget.request == "Accepted"
                            ? const SizedBox(
                          height: 24,
                        )
                            : Container()
                      ],
                    )),
                const SizedBox(
                  height: 24,
                ),
                if(widget.request == "Accepted")
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: SizedBox(
                    height:200,
                    child: PolyLineHelpWidget(
                      distance: distance,
                      pos:widget.picLocation,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1, // 1 pixel height for the border
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAECF0), // Background color
                    border: Border.all(
                      color: const Color(0xFFEAECF0), // Border color
                      width: 1, // Border width
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateAccept(String id,String status) {
    print("CLEARED HERE *");
    for (RequestMade details in requestMadeByUser) {
      if (details.requestMadePID == id) {
        print("CLEARED HERE ***");
        details.requestMadeStatus = status;
        break;
      }
    }
    print("CLEARED HERE **");
  }

  Future<void> pressDone() async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '03448350-8835-11ee-bd14-3170816cf75e',
      context: context,
    );
    print("widget.PID >>> ${widget.pId}");
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID": widget.pId,
        "helpStatus": "Help Done",
        "assignedHelperNo":widget.phoneNumber
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "03448350-8835-11ee-bd14-3170816cf75e",
          jsonData: getJsonData());
      helpDone();
    } catch (es, st) {
      print("Error in PressDone>> $es $st");
    }
  }

  void helpRequestCancel() {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '03448350-8835-11ee-bd14-3170816cf75e',
      context: context,
    );

    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID": widget.pId,
        "helpStatus": "Cancelled",
        "assignedHelperNo":prefs.phoneNumber
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "03448350-8835-11ee-bd14-3170816cf75e",
        jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess = (result) {
     setState(() {
       widget.request = "Cancelled";
     });
    };
    bBlupSheetsApi.onFailure = (error) {
      print("Blup Error is 2 ${error.body}");
    };
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
                            Container(
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
                            // const Text(
                            //   'Are you sure you want to send an SOS \nand contact emergency personnel?',
                            //   style: TextStyle(
                            //     color: Color(0xFF98A1B2),
                            //     fontSize: 14,
                            //     fontFamily: 'SF Pro',
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                            // const SizedBox(height: 12),
                            // const Text(
                            //   'SOS SENDING',
                            //   style: TextStyle(
                            //     color: Color(0xFF475466),
                            //     fontSize: 16,
                            //     fontFamily: 'SF Pro',
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                            // const SizedBox(height: 8),
                            // const Text(
                            //   'Police, ambulance, fire brigade, \nand your family.',
                            //   style: TextStyle(
                            //     color: Color(0xFF98A1B2),
                            //     fontSize: 14,
                            //     fontFamily: 'SF Pro',
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
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
                                  print("Call 911");
                                  FlutterPhoneDirectCaller.callNumber('911');
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

  gotoMap() {
    try {
      var url =
          "https://www.google.com/maps/dir/?api=1&destination=${widget.picLocation.latitude},${widget.picLocation.longitude}";
      final Uri url0 = Uri.parse(url);
      launchUrl(url0);
    } catch (_) {
      print("Error launch Map");
    }
  }



  callNumber(Uri dialNumber) async {
    await launchUrl(dialNumber);
  }

  void helpDone() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2F3F6),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            size: 30,
                            color: Color(0xFF475467),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Status',
                            style: TextStyle(
                              color: Color(0xFF475466),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          height: 175,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 30,
                                    color: Color(0xFF238816),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Request Completed',
                                    style: TextStyle(
                                      color: Color(0xFF238816),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: const Color(0xFFD0D5DD),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Tip to Truckerlink ',
                                      style: TextStyle(
                                        color: Color(0xFF475466),
                                        fontSize: 18,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '(optional)',
                                      style: TextStyle(
                                        color: Color(0xFF98A1B2),
                                        fontSize: 18,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Reward Truckerlink's efforts with a well-deserved tip.",
                                style: TextStyle(
                                  color: Color(0xFF98A1B2),
                                  fontSize: 12,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: moneyAdd,
                                  decoration: const InputDecoration(
                                    fillColor: Color(0xFFF2F3F6),
                                    filled: true,
                                    border: InputBorder.none,
                                    hintText: "Add your tip",
                                    hintStyle: TextStyle(
                                      color: Color(0xFF98A1B2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          moneyAdd.text = '\$10';
                                        },
                                        child: Container(
                                          width: 60,
                                          padding: const EdgeInsets.fromLTRB(
                                              6, 12, 6, 12),
                                          margin: const EdgeInsets.all(4),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(42),
                                            ),
                                            shadows: const [
                                              BoxShadow(
                                                color: Color(0x14000000),
                                                blurRadius: 3,
                                                offset: Offset(0, 1),
                                                spreadRadius: 1,
                                              ),
                                              BoxShadow(
                                                color: Color(0x1E000000),
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                          child: const Text(
                                            '\$10',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF475466),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          moneyAdd.text = '\$20';
                                        },
                                        child: Container(
                                          width: 60,
                                          padding: const EdgeInsets.fromLTRB(
                                              6, 12, 6, 12),
                                          margin: const EdgeInsets.all(4),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(42),
                                            ),
                                            shadows: const [
                                              BoxShadow(
                                                color: Color(0x14000000),
                                                blurRadius: 3,
                                                offset: Offset(0, 1),
                                                spreadRadius: 1,
                                              ),
                                              BoxShadow(
                                                color: Color(0x1E000000),
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                          child: const Text(
                                            '\$20',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF475466),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          moneyAdd.text = '\$30';
                                        },
                                        child: Container(
                                          width: 60,
                                          padding: const EdgeInsets.fromLTRB(
                                              6, 12, 6, 12),
                                          margin: const EdgeInsets.all(4),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(42),
                                            ),
                                            shadows: const [
                                              BoxShadow(
                                                color: Color(0x14000000),
                                                blurRadius: 3,
                                                offset: Offset(0, 1),
                                                spreadRadius: 1,
                                              ),
                                              BoxShadow(
                                                color: Color(0x1E000000),
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                          child: const Text(
                                            '\$30',
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
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                      if(moneyAdd.text.isNotEmpty){
                                        print("moneyAdd.text - ${moneyAdd.text}");
                                        String money = removeSpacesAndDollars(moneyAdd.text);
                                        print("money=>$money");
                                        makePayment(money);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFDBFFD6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(42),
                                        ),
                                        shadows: const [
                                          BoxShadow(
                                            color: Color(0x14000000),
                                            blurRadius: 3,
                                            offset: Offset(0, 1),
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Color(0x1E000000),
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Send",
                                            style: TextStyle(
                                              color: Color(0xFF238816),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          SvgPicture.asset(
                                            'assets/image/sendarrow.svg',
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: const Color(0xFFF2F4F7),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    print("Done button pressed");
                                  },
                                  child: const TextButton(
                                    onPressed: null,
                                    child: Text(
                                      "Done",
                                      style: TextStyle(
                                        color: Color(0xFF475467),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  // Future<void> checkForExistingGroup( NearbyPerson peopleAround) async {
  //   String checkForExisting = '',gName='';
  //   BSheetsApi bBlupSheetsApi = BSheetsApi(
  //     'client.blup.white.falcon@gmail.com',
  //     calledFrom: 'cf40d220-af5e-1e32-83d6-03d89d8c60e7',
  //     context: context,
  //   );
  //   Map<dynamic, dynamic> getJsonData() {
  //     Map<dynamic, dynamic> jsonData = {
  //       'P_Id1' : prefs.userId,
  //       'P_Id2' : peopleAround.userId,
  //     };
  //     return jsonData;
  //   }
  //
  //   var response = await bBlupSheetsApi.runHttpApi(
  //       queryId: "cf40d220-af5e-1e32-83d6-03d89d8c60e7",
  //       jsonData: getJsonData());
  //   print("response - $response");
  //   for (var res in response) {
  //     print('res - ${res['G_Id']}');
  //     checkForExisting = res['G_Id'];
  //     gName = res['G_Name'];
  //   }
  //   if(checkForExisting ==''){
  //     showDialogBox(peopleAround);
  //   }else{
  //     GroupDetails newGroupDetails = GroupDetails(
  //       groupName:gName,
  //       groupMembers: '2',
  //       groupID: checkForExisting,
  //       createBy: prefs.userId!,
  //     );
  //     Get.to(ChatScreen(groupDetails: newGroupDetails));
  //   }
  // }

  bool clickYes = false;
  void showDialogBox(NearbyPerson peopleAround) {
    showDialog(
      context: context,
      barrierDismissible : false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
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
                                      'assets/image/message.svg',
                                      width: 40,
                                      height: 40,
                                      color: const Color(0xFF475466),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Are you sure you want to \nchat with ${peopleAround
                                        .name}??',
                                    style: const TextStyle(
                                      color: Color(0xFF475466),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            clickYes == false ?
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: const Color(0xFFF2F3F6),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25.0),
                                      onTap: () {
                                        Navigator.pop(context);
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
                                      onTap: () async {
                                        clickYes = true;
                                        setStateDialog(() {
                                          print("YES Clicked");
                                        });
                                        await createNewGroup(peopleAround);
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
                            )
                                :
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: const Color(0xFFFFDBCA),
                                    child: InkWell(
                                      onTap: null,
                                      borderRadius: BorderRadius.circular(25),
                                      child: const TextButton(
                                        onPressed: null,
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFF475466)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
        );
      },
    );
  }

  String removeSpacesAndDollars(String input) {
    return input.replaceAll(RegExp(r'\s|\$'), '');
  }


  Future<void> createNewGroup(NearbyPerson peopleAround) async {
    String gId = const Uuid().v1();
    String groupName = "${prefs.name} - ${peopleAround.name}";
    await saveGroupDetails(peopleAround, gId, groupName);
    await saveGidAndPid(peopleAround, gId, groupName);
    GroupDetails newGroupDetails = GroupDetails(
      groupName: groupName,
      groupMembers: '2',
      groupID: gId,
      createBy: prefs.userId!,
    );
    Navigator.pop(context);
    print("popup is closed now");
    Get.to(ChatScreen(groupDetails: newGroupDetails));
  }

  Future<void> saveGroupDetails(NearbyPerson peopleAround, String gId, String groupName) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '894a6680-6e69-11ee-8e06-bd1e227af3b0',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "GID": gId,
        "GroupName": groupName,
        "Created_by": prefs.userId,
        "total_members": 2,
      };
      return jsonData;
    }

    var response = await bBlupSheetsApi.runHttpApi(
        queryId: "894a6680-6e69-11ee-8e06-bd1e227af3b0",
        jsonData: getJsonData());
  }

  Future<void> saveGidAndPid(NearbyPerson peopleAround, String gId, String groupName) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'c5432ac0-6f34-11ee-ad34-d94c3b1e1747',
      context: context,
    );
    String x;
    for (int i = 0; i < 2; i++) {
      if (i == 0) {
        x = prefs.userId!;
      } else {
        x = peopleAround.userId;
      }
      Map<dynamic, dynamic> getJsonData() {
        Map<dynamic, dynamic> jsonData = {
          "PID": x,
          "GID": gId,
        };
        return jsonData;
      }

      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "c5432ac0-6f34-11ee-ad34-d94c3b1e1747",
          jsonData: getJsonData());
    }
  }

}

Future<void> makePayment(String x) async {
  print("MakePayment -> $x");
  try {
    paymentIntentData = await createPaymentIntent('500', 'usd');

    // Check if the paymentIntentData contains the necessary key
    if (paymentIntentData != null && paymentIntentData!.containsKey('client_secret')) {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'White Falcon',
          // customFlow: false, // You can omit this line or set it to false
        ),
      ).then((value) {
        print("displayPaymentSheet");
        displayPaymentSheet();
      });
    } else {
      print("Error: Missing client_secret in paymentIntentData");
    }
  } catch (e) {
    print("Error - $e");
  }
}

void displayPaymentSheet() async {
  print("displayPaymentSheet");
  try {
    await Stripe.instance.presentPaymentSheet().then((value) => Fluttertoast.showToast(
        msg: "Payment Done!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0));
  } on StripeException catch (e) {
    Fluttertoast.showToast(
        msg: "Cancelled!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  } catch (e) {
    print('makePayment Cancelled - $e');
  }
}

Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
  try {
    final intAmount = calculateAmount(amount);

    Map<String, dynamic> body = {
      'amount': intAmount,
      'currency': currency,
      'payment_method_types[]': 'card',
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      body: body,
      headers: {
        'Authorization': 'Bearer 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',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // final Map<String, dynamic> errorBody = jsonDecode(response.body);
      print('Failed to create payment intent. Error: ${response.body}');
      return {}; // Return an empty map or handle the error accordingly
    }
  } catch (err) {
    print('Error creating payment intent: ${err.toString()}');
    return {}; // Return an empty map or handle the error accordingly
  }
}

calculateAmount(String amount) {
  final a = (int.parse(amount)) * 100;
  return a.toString();
}
