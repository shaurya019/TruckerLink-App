import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MoveBack extends StatefulWidget {
  const MoveBack({super.key});

  @override
  State<MoveBack> createState() => _MoveBackState();
}

class _MoveBackState extends State<MoveBack> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            Get.back();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(55),
              color: Colors.white,
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
            child:SvgPicture.asset('assets/image/cross.svg',
              width: 20.4,
              height: 20.5,
              fit: BoxFit.scaleDown,
              color: Color(0xFF475467),
            ),
          ),
        ),
      ],
    );
  }
}
