import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trucker/requests/alert_fetch.dart';
import 'package:trucker/requests/calculate_distance.dart';
import 'package:trucker/requests/histroy_fetch.dart';
import 'package:trucker/screens/navigation_screen/bottom.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/help_widget/help_direction.dart';
import 'package:trucker/widgets/help_widget/take_image.dart';
import '../../screens/profile_screen/profile.dart';

bool isLoadingSafe = true;


class SafetyPage extends StatefulWidget {
  final CameraDescription camera;
  const SafetyPage({Key? key, required this.camera}) : super(key: key);

  @override
  State<SafetyPage> createState() => _SafetyPageState();
}

class _SafetyPageState extends State<SafetyPage> {
  bool _firstpage = true;
  String status = 'Active';
  double width = 91.0;
  String distance = '';
   var nameOfUser;
  Color bodyColor = const Color(0xFF238816);
  Color textColor = const Color(0xFFD6FFD8);
  LatLng? startLocation;

  void onCallback() {
    setState(() {
      print("CALLED");
    });
  }



  @override
  void initState() {
    super.initState();
    getSafetyAlertNotify(context: context);
    startLocationCalculate(true);
  }


  void startLocationCalculate(bool isCallSetState) async{
    startLocation=await GetCurrentLocation().fetch();
    if(isCallSetState) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    startLocationCalculate(false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith((
                        states) => Colors.transparent),
                  ),
                  onPressed: () {
                    // Get.off(Bottom(
                    //   selectedIndex: 0,
                    //   newIndex: 0,
                    // ));
                    Get.back();
                  },
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: SvgPicture.string('''<svg width="24" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M19.2422 12H5.24219M5.24219 12L12.2422 19M5.24219 12L12.2422 5" stroke="#667085" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                              </svg>'''
                    ),
                  ),
                ),
                const SizedBox(width: 12,),
                const Text('Safety History', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),)
              ],
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEAECF0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _firstpage = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: _firstpage ? Colors.white : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadows: _firstpage
                            ? const [
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
                        ]
                            : [],
                      ),
                      child: const Text(
                        'Sent Markers',
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
                      setState(() {
                        _firstpage = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color:
                        !_firstpage ? Colors.white : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadows: !_firstpage
                            ? const [
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
                        ]
                            : [],
                      ),
                      child: const Text(
                        'Received Markers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF475466),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _firstpage ? safetyByYou() : safetyByOthers(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getSafetyAlertNotify({required BuildContext context}) async {
    await AlertFetch.instance.getSafetyAlertNotification(true,context: context);
    setState(() {
      isLoadingHistory = false;
    });
  }

  Widget safetyByOthers() {
    return alertsMadeByOthers.isNotEmpty ?
    ListView.builder(
      itemCount: alertsMadeByOthers.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) {

        distance = CalculateDistance.instance.calculateDistance(alertsMadeByOthers[i].position.latitude,alertsMadeByOthers[i].position.longitude,startLocation!.latitude,startLocation!.longitude).toStringAsFixed(2);
        String dateAndTime = dateFix(
            '${alertsMadeByOthers[i].time} -  ${alertsMadeByOthers[i].date}');
        // print("dateAndTime - $dateAndTime");
        if (alertsMadeByOthers[i].status == "Disable") {
          status = "Expired";
          width = 67;
          bodyColor = const Color(0xFFF0F0F0);
          textColor = const Color(0xFF667085);
        }
        else if (alertsMadeByOthers[i].status == "Removed") {
          status = "Removed";
          width = 80;
          bodyColor = const Color(0xFFDBDBDB);
          textColor = const Color(0xFF464646);
        }
        else if (alertsMadeByOthers[i].status == "Active") {
          status = 'Active';
          width = 91.0;
          bodyColor = const Color(0xFF238816);
          textColor = const Color(0xFFD6FFD8);
        }
         nameOfUser = capitalizeFirstWord(
             alertsMadeByOthers[i].subject.replaceAll('\n', ' ').trimRight());
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            expiredMarkerPopUp(
                alertsMadeByOthers[i].userImage,alertsMadeByOthers[i].status, alertsMadeByOthers[i].subject,
                alertsMadeByOthers[i].name, alertsMadeByOthers[i].images,distance,true);
          },
          child: SizedBox(
            width: double.infinity,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    alertsMadeByOthers[i].userImage != "x"
                        ? CircleAvatar(
                      radius: 30,
                      backgroundImage:
                      NetworkImage(alertsMadeByOthers[i].userImage),
                    )
                        : Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2970FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: SvgPicture.asset(
                        'assets/image/person.svg',
                        height: 18.33,
                        width: 15,
                        color: Colors.white,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            nameOfUser,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475467),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          dateAndTime,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF98A2B3),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: alertsMadeByOthers[i].status == "Active" ?
                  Container(
                      height: 22,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: bodyColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(status, style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),),
                          ),
                          SvgPicture.asset(
                            'assets/image/arrowup.svg',
                            width: 13.0,
                            height: 13.0,
                          ),
                        ],
                      )
                  ) :
                  Container(
                    height: 22,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: bodyColor,
                    ),
                    child: Center(child: Text(status, style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    )
        :
    Center(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 68),
        child: Column(
          children: [
            Column(
              children: [
                SvgPicture.asset('assets/image/rrequest.svg',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover, // You can adjust the fit as needed
                ),
                const SizedBox(height: 18,),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Seems like you have not received',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),),
                    Text('any safety notification so far.',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),),
                  ],
                ),
                const SizedBox(height: 18,),
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    // Get.to(()=> Contacts( onTap: (){}));
                  },
                  child: Container(
                    height: 40,
                    width: 203,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFFE3E3E3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset('assets/image/plus.svg',
                          height: 18,
                          width: 18,
                          color: const Color(0xFF475467),),
                        const Text('Make a help safety',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475467),
                          ),),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18,),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('You will receive a notification if',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667085),
                      ),),
                    Text('something is wrong on your road ahead!',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667085),
                      ),),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget safetyByYou() {
    return alertsMadeByYou.isNotEmpty ?
    ListView.builder(
      itemCount: alertsMadeByYou.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) {
         distance = CalculateDistance.instance.calculateDistance(alertsMadeByOthers[i].position.latitude,alertsMadeByOthers[i].position.longitude,startLocation!.latitude,startLocation!.longitude).toStringAsFixed(2);
        String dateAndTime = dateFix(
            '${alertsMadeByYou[i].time} -  ${alertsMadeByYou[i].date}');
        print("DateTime - $DateTime");
        if (alertsMadeByYou[i].status == "Disable") {
          status = "Expired";
          width = 67;
          bodyColor = const Color(0xFFF0F0F0);
          textColor = const Color(0xFF667085);
        }
        else if (alertsMadeByYou[i].status == "Removed") {
          status = "Removed";
          width = 80;
          bodyColor = const Color(0xFFDBDBDB);
          textColor = const Color(0xFF464646);
        }
        else if (alertsMadeByYou[i].status == "Active") {
          status = 'Active';
          width = 91.0;
          bodyColor = const Color(0xFF238816);
          textColor = const Color(0xFFD6FFD8);
        }
         nameOfUser = capitalizeFirstWord(
             alertsMadeByYou[i].subject.replaceAll('\n', ' ').trimRight());
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (alertsMadeByYou[i].status == "Active") {
              activeMarkerPopUp(
                  prefs.imageUrl!,alertsMadeByYou[i].uuid, alertsMadeByYou[i].subject,
                  alertsMadeByYou[i].name, alertsMadeByYou[i].images, onCallback,'',false);
            } else {
              expiredMarkerPopUp(
                  prefs.imageUrl!,alertsMadeByYou[i].status, alertsMadeByYou[i].subject,
                  alertsMadeByYou[i].name, alertsMadeByYou[i].images,'',false);
            }
          },
          child: SizedBox(
            width: double.infinity,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    prefs.imageUrl != "x"
                  ? CircleAvatar(
                  radius: 30,
                  backgroundImage:
                  NetworkImage(prefs.imageUrl!),
                )
                    : Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2970FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SvgPicture.asset(
                    'assets/image/person.svg',
                    height: 18.33,
                    width: 15,
                    color: Colors.white,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                           nameOfUser,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475467),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          dateAndTime,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF98A2B3),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: alertsMadeByYou[i].status == "Active" ?
                  Container(
                      height: 22,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: bodyColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(status, style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),),
                          ),
                          SvgPicture.asset(
                            'assets/image/arrowup.svg',
                            width: 13.0,
                            height: 13.0,
                          ),
                        ],
                      )
                  ) :
                  Container(
                    height: 22,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: bodyColor,
                    ),
                    child: Center(child: Text(status, style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    )
        :
    Center(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 68),
        child: Column(
          children: [
            Column(
              children: [
                SvgPicture.asset('assets/image/srequest.svg',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover, // You can adjust the fit as needed
                ),
                const SizedBox(height: 18,),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Seems like you have not sent',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),),
                    Text('any safety notification so far.',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),),
                  ],
                ),
                const SizedBox(height: 18,),
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    Get.to(() => TakePictureScreen(camera: widget.camera));
                  },
                  child: Container(
                    height: 40,
                    width: 203,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFFE3E3E3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset('assets/image/plus.svg',
                          height: 18,
                          width: 18,
                          color: const Color(0xFF475467),),
                        const Text('Make a help safety',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475467),
                          ),),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18,),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Do not forget to notify fellow truckers,',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667085),
                      ),),
                    Text('if something is wrong on the road!',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667085),
                      ),),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


  Widget remove(String id, void Function() onCallback,) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: const Color(0xFFFFDBCA),
            child: InkWell(
              onTap: () {
                updateStatusForId(id);
                allMarkers.removeWhere((e) => e.markerId == MarkerId(id));
                alertPinMarker.removeWhere((alertData) => alertData.uuid == id);
                updateStatus(id);
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(25),
              child: const TextButton(
                onPressed: null,
                child: Text(
                  'Remove Marker',
                  style: TextStyle(
                    color: Color(0xFF331200),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  void expiredMarkerPopUp(String image,String status, String subject, String name, List<String> imageList,String distance,bool flag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          insetPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        children: [
                          // safety header
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shield_outlined,
                                      size: 24,
                                      color: Color(0xFF475467),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Safety',
                                      style: TextStyle(
                                        color: Color(0xFF475466),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Notification',
                                  style: TextStyle(
                                    color: Color(0xFF98A1B2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                          // List of image
                          if (imageList.isEmpty)
                            const SizedBox(
                              height: 356,
                              child: Center(
                                child: Text(
                                  'No image attached',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (imageList.length == 1)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(1.0),
                              child: Image.network(
                                imageList[0],
                                fit: BoxFit.cover,
                                height: 356,
                              ),
                            ),
                          if (imageList.length == 2)
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.network(
                                      imageList[0],
                                      fit: BoxFit.cover,
                                      height: 356,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.network(
                                      imageList[1],
                                      fit: BoxFit.cover,
                                      height: 356,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (imageList.length == 3)
                            SizedBox(
                              height: 356,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Image.network(
                                              imageList[0],
                                              fit: BoxFit.cover,
                                              height: 150,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 1, 1, 1),
                                            child: Image.network(
                                              imageList[1],
                                              fit: BoxFit.cover,
                                              height: 150,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 150,
                                    padding: const EdgeInsets.all(1.0),
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Image.network(
                                      imageList[2],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (imageList.length == 4)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Image.network(
                                          imageList[0],
                                          fit: BoxFit.cover,
                                          height: 150,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Image.network(
                                          imageList[1],
                                          fit: BoxFit.cover,
                                          height: 150,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Image.network(
                                          imageList[2],
                                          fit: BoxFit.cover,
                                          height: 150,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Image.network(
                                          imageList[3],
                                          fit: BoxFit.cover,
                                          height: 150,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          // pop main content
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        image != "x"
                                            ? CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                          NetworkImage(image),
                                        )
                                            : const CircleAvatar(
                                          backgroundColor: Color(0xFF2970FF),
                                          child: Icon(
                                            Icons.person,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            name,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color(0xFF475466),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    flag == false ?
                                    Container()
                                    :
                                    Text(
                                      "$distance Miles Away",
                                      style: const TextStyle(
                                        color: Color(0xFFFF8D49),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF2F3F6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    subject,
                                    style: const TextStyle(
                                      color: Color(0xFF1D2838),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 75,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: status == "Active" ? const Color(0xFF238816) : const Color(0xFFF0F0F0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: status == "Active" ?
                        const Row(
                          children: [
                            Text(
                              'Active',
                              style: TextStyle(
                                color: Color(0xFFD6FFD8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.launch_outlined,
                              color: Colors.white,
                              size: 13,
                            )
                          ],
                        )
                        :
                        Row(
                          children: [
                            Text(
                              status,
                              style: const TextStyle(
                                color: Color(0xFF667085),
                                fontSize: 12,
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
            ),
          ),
        );
      },
    );
  }

  void activeMarkerPopUp(String image,String id, String subject, String name, List<String> imageList, void Function() onCallback,String distance,bool flag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          insetPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // safety header
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shield_outlined,
                                        size: 24,
                                        color: Color(0xFF475467),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Safety',
                                        style: TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Notification',
                                    style: TextStyle(
                                      color: Color(0xFF98A1B2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
// List of image
                            if (imageList.isEmpty)
                              const SizedBox(
                                height: 356,
                                child: Center(
                                  child: Text(
                                    'No image attached',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            if (imageList.length == 1)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(1.0),
                                child: Image.network(
                                  imageList[0],
                                  fit: BoxFit.cover,
                                  height: 356,
                                ),
                              ),
                            if (imageList.length == 2)
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.network(
                                        imageList[0],
                                        fit: BoxFit.cover,
                                        height: 356,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.network(
                                        imageList[1],
                                        fit: BoxFit.cover,
                                        height: 356,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (imageList.length == 3)
                              SizedBox(
                                height: 356,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                  1.0),
                                              child: Image.network(
                                                imageList[0],
                                                fit: BoxFit.cover,
                                                height: 150,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .fromLTRB(
                                                  0, 1, 1, 1),
                                              child: Image.network(
                                                imageList[1],
                                                fit: BoxFit.cover,
                                                height: 150,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 150,
                                      padding: const EdgeInsets.all(1.0),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      child: Image.network(
                                        imageList[2],
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (imageList.length == 4)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Image.network(
                                            imageList[0],
                                            fit: BoxFit.cover,
                                            height: 150,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Image.network(
                                            imageList[1],
                                            fit: BoxFit.cover,
                                            height: 150,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Image.network(
                                            imageList[2],
                                            fit: BoxFit.cover,
                                            height: 150,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Image.network(
                                            imageList[3],
                                            fit: BoxFit.cover,
                                            height: 150,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      image != " "
                                          ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                        NetworkImage(image),
                                      )
                                          : const CircleAvatar(
                                        backgroundColor: Color(0xFF2970FF),
                                        child: Icon(
                                          Icons.person,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // const SizedBox(width: 12),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          name,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      flag == false ?
                                      Container()
                                          :
                                      Text(
                                        "$distance Miles Away",
                                        style: const TextStyle(
                                          color: Color(0xFFFF8D49),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF2F3F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      subject,
                                      style: const TextStyle(
                                        color: Color(0xFF1D2838),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            remove(id, onCallback),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF238816),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Active',
                              style: TextStyle(
                                color: Color(0xFFD6FFD8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.launch_outlined,
                              color: Colors.white,
                              size: 13,
                            )
                          ],
                        ),
                      ),
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


  String s = 'Normal';

  Future<void> updateStatus(String uuid) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '12626ec0-1d91-1ddd-a911-592cec524104',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "uid": uuid,
        "Status": "Removed",
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "12626ec0-1d91-1ddd-a911-592cec524104",
          jsonData: getJsonData());
      print("UPDATED Removed");
      setState(() {

      });
    } catch (es, st) {
      print("Error in InsertIntoAlert>> $es $st");
    }
  }

  String capitalizeFirstWord(String input) {
    if (input.isEmpty) {
      return input;
    }

    return input[0].toUpperCase() + input.substring(1);
  }

  String dateFix(String input) {
    List<String> parts = input.split(" - ");
    String timeString = parts[0];
    String dateString = parts[1];

    DateTime time = DateFormat.Hms().parse(timeString);

    // Parse date
    List<String> dateParts = dateString.split(":");
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    DateTime date = DateTime(year, month, day);

    // Format date and time with AM/PM
    String formattedDateTime = DateFormat("d MMM yyyy h:mm a").format(DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    ));

    return formattedDateTime;
  }

}

void updateStatusForId(String id) {
  print("CLEARED HERE *");
  for (AlertData alert in alertsMadeByYou) {
    if (alert.uuid == id) {
      alert.status = 'Removed';
      break;
    }
  }
  print("CLEARED HERE **");
}


