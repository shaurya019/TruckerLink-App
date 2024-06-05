// ignore_for_file: must_be_immutable

import "dart:async";
import "package:b_dep/b_dep.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:trucker/global/global_class.dart";
import "package:trucker/requests/alert_fetch.dart";
import "package:trucker/requests/calculate_distance.dart";
import "package:trucker/requests/message_api.dart";
import "package:trucker/screens/chat_screen/chat.dart";
import "package:trucker/screens/navigation_screen/bottom.dart";
import "package:trucker/screens/profile_screen/profile.dart";
import "package:trucker/screens/splash_screen/splash.dart";
import "package:trucker/widgets/friends_widget/group_list.dart";
import "package:trucker/widgets/help_widget/help_direction.dart";
import "package:trucker/widgets/help_widget/help_group.dart";
import "package:trucker/widgets/help_widget/help_history_page.dart";
import "package:trucker/widgets/help_widget/help_polyline_map.dart";
import "package:url_launcher/url_launcher.dart";
import "package:uuid/uuid.dart";

class OtherAcceptedHelp extends StatefulWidget {
  String name;
  String userId;
  String code;
  String phoneNumber;
  String email;
  String message;
  LatLng picLocation;
  String request;
  String imageUrl;
  String pId;
  bool flag;
  OtherAcceptedHelp({super.key,required this.name,required this.userId,required this.code,required this.phoneNumber,required this.email,required this.picLocation,required this.message,required this.request,required this.imageUrl,required this.pId,required this.flag,});

  @override
  State<OtherAcceptedHelp> createState() => OtherAcceptedHelpState();
}

class OtherAcceptedHelpState extends State<OtherAcceptedHelp> {
  bool isListeningStopped=false;
  String distance="";

  @override
  void initState() {
    super.initState();
    callListener();
    distanceCalculated(true);
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
    // String distance = CalculateDistance.instance.calculateDistance(widget.picLocation.latitude,widget.picLocation.longitude,startLocation.latitude,startLocation.longitude).toStringAsFixed(2);

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
                        if(widget.flag){
                          Get.back();
                          // Get.off(Bottom(selectedIndex: 0, newIndex: 0,));
                        }else{
                          Get.back();
                        // Get.off(HistoryPage(firstpage: false,));
                        }
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
                          const Color(0xFFFFE3E3)
                          :
                          widget.request == "Accepted" ?
                          const Color(0xFF238816)
                              :
                          widget.request == "Cancelled" ?
                          const Color(0xFFFFE3E3)
                              :
                          const Color(0xFFDBDBDB),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            widget.request == "Help Not Available" ? "UnfullFiled":
                            widget.request == "Help Done" ?
                            "Fullfilled":
                            widget.request
                            ,style:  TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:  widget.request == "Accepted" ? const Color(0xFFD6FFD8) : const Color(0xFF464646),
                          ),),
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
                    text:  TextSpan(
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
                  child: Text('You have accepted the help request',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475467), // Text color
                    ),),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                    // height: widget.request == "Accepted" ? 404 : 420,
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
                        // Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           children: [
                        //             widget.imageUrl != "x"
                        //                 ?
                        //             CircleAvatar(
                        //               radius: 30,
                        //               backgroundImage:
                        //               NetworkImage(widget.imageUrl),
                        //             )
                        //                 :
                        //             Container(
                        //               width: 40.0,
                        //               height: 40.0,
                        //               decoration: BoxDecoration(
                        //                 color: const Color(0xFF2970FF),
                        //                 borderRadius: BorderRadius.circular(24),
                        //               ),
                        //               child: SvgPicture.asset(
                        //                 'assets/image/person.svg',
                        //                 height: 18.33,
                        //                 width: 15,
                        //                 color: Colors.white,
                        //                 fit: BoxFit.scaleDown,
                        //               ),
                        //             ),
                        //             const SizedBox(width: 15,),
                        //             SizedBox(
                        //               width: 130,
                        //               child: Text(
                        //                 widget.name,
                        //                 overflow: TextOverflow.ellipsis,
                        //                 style: const TextStyle(
                        //                   color: Color(0xFF475467),
                        //                   fontSize: 18,
                        //                   fontWeight: FontWeight.w500,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         Text(
                        //           "$distance Miles Away",
                        //           style: const TextStyle(
                        //             color: Color(0xFFFF8D49),
                        //             fontSize: 12,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ],
                        //     )
                        // ),
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
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        // mainAxisSize: MainAxisSize.min,

                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Container(
                                          //height: 22,
                                          //width: 176,
                                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
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
                                          child: Text("You have ${(widget.request == "Help Not Available" ? "UnfullFiled":
                                          widget.request == "Help Done" ?
                                          "Fullfilled":
                                          widget.request).toLowerCase()} the help request.",
                                            style: TextStyle(
                                              fontSize: 12,
                                              height: 1.1,
                                              fontWeight: FontWeight.w500,
                                              color:  widget.request == "Accepted" ? Color(0xFF238816) : Color(0xFF464646),
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
                          height: 28,
                        ),
                        widget.request == "Cancelled"
                            ?
                        Center(
                          child: SvgPicture.asset('assets/image/cross.svg',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        )
                            :
                        Padding(
                          padding: const EdgeInsets.only(left: 19.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  callNumber(widget.phoneNumber);
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
                                        color: Color(0xFFFF8D49),
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/image/call.svg',
                                        width: 18,
                                        height: 18,
                                        color: Colors.white,
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
                                      SvgPicture.asset('assets/image/arrow.svg',
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
                        widget.request == "Cancelled"
                            ?
                             const Center(child: Text('Help request is cancelled!',style: TextStyle(
                                 fontFamily: 'SF Pro',
                                 fontSize: 20,
                                 fontWeight: FontWeight.w500,
                                 color: Color(0xFF475467)
                             ),),)
                        :
                        (widget.request == "Accepted")?
                        Padding(
                          padding: const EdgeInsets.only(left: 19.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  gotoMap(widget.picLocation);
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
                                      SvgPicture.asset('assets/image/pin.svg',
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
                            ],
                          ),
                        ):SizedBox.shrink(),
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
                          child: Text('Received Message',style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF98A2B3)
                          ),),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 19.0),
                          child: Text( widget.message,style: const TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475467)
                          ),),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                ),
                const SizedBox(
                  height: 24,
                ),
                if(widget.request == "Accepted")
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: SizedBox(
                    height:300,
                    child:PolyLineHelpWidget(
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

  void callListener(){
    Timer.periodic(const Duration(seconds: 10), (Timer t) {
      if(mounted) {
        isListeningStopped=false;
        getAssuranceAboutStatus(widget.pId,(status){
          if(status == "Help Done"&&widget.request!="Help Done"){
            widget.request = "Help Done";
            setState(() {

            });
            Fluttertoast.showToast(
              msg: "Help is fulfilled. Awesome, you have helped a fellow trucker in need!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else  if(status == "Cancelled"&&widget.request != "Cancelled"){
            widget.request = "Cancelled";
            setState(() {

            });
          }
        });
      }else{
        isListeningStopped=true;
      }
    });
  }

  void callNumber(String phoneNumber) async{
    var dialNumber = Uri(
        scheme: 'tel', path: phoneNumber);
    await launchUrl(dialNumber);
  }

  void gotoMap(LatLng location) {
    try {
      var url = "https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}";
      final Uri url0 = Uri.parse(url);
      launchUrl(url0);
    } catch (_) {
      print("Error launch Map");
    }
  }

  void sendMessage() async{
    await Get.to(GroupSelect(helpMessage: widget.message));
    if(isListeningStopped) {
      callListener();
    }
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
  //     await Get.to(ChatScreen(groupDetails: newGroupDetails));
  //     if(isListeningStopped) {
  //       callListener();
  //     }
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

  Future<void> createNewGroup(NearbyPerson peopleAround) async {
    String gId = const Uuid().v1();
    String groupName = "${prefs.name} - ${peopleAround.name}";
    await saveGroupDetails(peopleAround, gId, groupName);
    await saveGidAndPid(peopleAround, gId, groupName);
    print("new group created");
    GroupDetails newGroupDetails = GroupDetails(
      groupName: groupName,
      groupMembers: '2',
      groupID: gId,
      createBy: prefs.userId!,
    );
    print("new group details created **");
    Navigator.pop(context);
    print("popup is closed now");
    await Get.to(ChatScreen(groupDetails: newGroupDetails));
    if(isListeningStopped) {
      callListener();
    }
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


  bool isToastCalled=false;
  Future<void> getAssuranceAboutStatus(String pID, Function(String status) onStatusReceived) async {
    print("IN getAssurance");
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'b3a2c620-7e68-1e33-acbf-df3d1580e41c',
      //context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID":pID/*widget.pId*/,
      };
      return jsonData;
    }
    print("<<< Trying to get resposne >>>>");
    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "b3a2c620-7e68-1e33-acbf-df3d1580e41c",
          jsonData: getJsonData());
      print("Response for person >>> ${response}");
      if(response is List) {
        if(
        (helpRequestStatusNotificationContainId.isEmpty ||
            (helpRequestStatusNotificationContainId.isNotEmpty &&
                !helpRequestStatusNotificationContainId.contains(response[0]["helpCode"])))){
          helpRequestStatusNotificationContainId.add(response[0]["helpCode"]);
          onStatusReceived(response[0]["helpStatus"]);
        }
      }
    } catch (es, st) {
      print("Error help>> $es $st");
    }
  }


}
