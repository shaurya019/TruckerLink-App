import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/help_widget/help_direction.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';

class HelpDir extends StatefulWidget {
  const HelpDir({super.key});

  @override
  State<HelpDir> createState() => _HelpDirState();
}

class _HelpDirState extends State<HelpDir> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        var startLocation=await GetCurrentLocation().fetch();
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: startLocation, zoom: 15)));
        MainMaps.gKey.currentState?.setState(() {
        });
      },
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
    );
  }
}
