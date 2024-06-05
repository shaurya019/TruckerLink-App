import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HelpIcon extends StatefulWidget {
  const HelpIcon({super.key});

  @override
  State<HelpIcon> createState() => _HelpIconState();
}

class _HelpIconState extends State<HelpIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.back();
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
                'assets/image/cross.svg',
                width: 15.4,
                height: 13.5,
                fit: BoxFit.scaleDown,
                color: const Color(0xFF475467),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            width: 112,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/image/no.svg',
                  width: 16.4,
                  height: 16.5,
                  // fit: BoxFit.scaleDown,
                  color: const Color(0xFF475467),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Report',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,fontFamily: 'SF Pro'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
