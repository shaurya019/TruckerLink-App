import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MapSetting extends StatefulWidget {
  const MapSetting({super.key, required this.onChange});
  final Function onChange;

  @override
  State<MapSetting> createState() => MapSettingState();

  static GlobalKey<MapSettingState> staticKey = GlobalKey<MapSettingState>();
}

class MapSettingState extends State<MapSetting> {
  int selectedIndex = 0;


  void setIndex(int index) {
    if(index != selectedIndex) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40.0,
          height: 82.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                    widget.onChange.call(indexNumber: 1);
                  });


                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    color: selectedIndex == 1 ? const Color(0xFFFFDBCA) : null,
                  ),
                  padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                  child: SvgPicture.asset(
                    'assets/image/stack.svg',
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/image/line.svg',
                width: 40.0,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                    widget.onChange.call(indexNumber: 2);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                    color: selectedIndex == 2 ? const Color(0xFFFFDBCA) : null,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/image/moon.svg',
                    width: 20.0,
                    height: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
