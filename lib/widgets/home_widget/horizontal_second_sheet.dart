import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:trucker/Lists/list.dart';
import 'package:trucker/widgets/home_widget/bottom_sheet_item.dart';
import 'package:trucker/widgets/nearby_widget/move_home.dart';



class HorizontalSecondSheet extends StatefulWidget {
  const HorizontalSecondSheet(
      {super.key,});
  @override
  State<HorizontalSecondSheet> createState() => _HorizontalSecondSheetState();
}

class _HorizontalSecondSheetState extends State<HorizontalSecondSheet> {
  TextStyle myTextStyle = const TextStyle(
    fontFamily: 'SF Pro',
    fontSize: 14.0,
    color: Color(0xFF475467),
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        padding:const EdgeInsets.symmetric(horizontal:10),
        itemBuilder: (context, int index) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              print("tapped with index $index");
              if (index == 0) {
                Get.to( Move(value:'Hotel',head:'Hotels'));
              }
              if (index == 1) {
                Get.to( Move(value:'Gas Station',head:'Gas Stations'));
              }
              if (index == 2) {
                Get.to( Move(value:'Parking',head:'Parkings'));
              }
              if (index == 3) {
                Get.to( Move(value:'Walmart',head:'Walmarts'));
              }
              if (index == 4) {
                dragindex = 1;
                DragItem.DKey.currentState?.setState(() {

                });
                print("clicked with HorizontalSecondSheet $dragindex");
                // widget.refresh.call(!widget.isMoreShow);
              }
            },
            child: Container(
              width: 84.25, // Hug width of 94 pixels
              height: 62,
              margin: const EdgeInsets.symmetric(horizontal:4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: const Color(0xFFF2F4F7),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 18.0,
                      height: 18.0,
                      padding:
                      const EdgeInsets.only(top: 2.25, left: 2.25),
                      child: SvgPicture.asset(
                        icons[index],
                        width: 14.0,
                        height: 14.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      items[index],
                      style: myTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

