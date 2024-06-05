import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/screens/home_screen/home.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/help_widget/help_direction.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';

class HelpFunc extends StatefulWidget {
  const HelpFunc({super.key,required this.onTap, this.onRefresh, this.onOpenFriendsTabCalled});
  final VoidCallback onTap;
  final VoidCallback? onRefresh;
  final VoidCallback? onOpenFriendsTabCalled;

  @override
  State<HelpFunc> createState() => _HelpFuncState();
}

class _HelpFuncState extends State<HelpFunc> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90.0,
      height: 150.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async{
              print("Hi >>>");
              var startLocation=await GetCurrentLocation().fetch();
              helpMapController?.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: startLocation, zoom: 15)));
              HelpMaps.hKey.currentState?.setState(() {
                print("Your Hmaps Location  ${startLocation.latitude}>>>>${startLocation.longitude}");
              });
            },
            borderRadius: BorderRadius.circular(55),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(55),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D000000),
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                  BoxShadow(
                    color: Color(0x26000000),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'assets/image/sun.svg',
                width: 20,
                height: 20,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () {
              Get.to(
                  Home(
                    onTap: widget.onTap, onRefresh: (){},
                    onOpenFriendsTabCalled: widget.onOpenFriendsTabCalled,
                  )
              );
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              width: 56.0,
              height: 76.0,
              decoration: BoxDecoration(
                border:Border.all(
                    width : .1,
                    color: const Color(0xffff5c2000)),
                borderRadius: BorderRadius.circular(16.0),
                color: const Color(0xFFFFDBCA), // Background color
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D000000), // First box shadow
                    offset: Offset(0.0, 1.0),
                    blurRadius: 3.0,
                  ),
                  BoxShadow(
                    color: Color(0x26000000), // Second box shadow
                    offset: Offset(0.0, 4.0),
                    blurRadius: 8.0,
                    spreadRadius: 3.0,
                  ),
                ],
              ),
              child:  Center(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:5.0),
                      child: SvgPicture.asset(
                        'assets/image/more.svg',
                        width: 47,
                        height: 47,
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top:3.0),
                      child: Text('more',
                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500,
                            color: Color(0xffff5c2000)),),
                    )
                  ],
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}

