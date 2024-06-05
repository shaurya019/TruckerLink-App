import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trucker/Lists/list.dart';
import 'package:trucker/screens/navigation_screen/bottom.dart';
import 'package:trucker/widgets/home_widget/bottom_sheet_item.dart';
import 'package:trucker/widgets/nearby_widget/move_home.dart';



class HorizontalSheet extends StatefulWidget {
  const HorizontalSheet({Key? key}) : super(key: key);

  @override
  State<HorizontalSheet> createState() => _HorizontalSheetState();
}

class _HorizontalSheetState extends State<HorizontalSheet> {
  TextStyle myTextStyle = const TextStyle(
    fontFamily: 'SF Pro',
    fontSize: 14.0,
    color: Color(0xFF475467),
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            InkWell(
              onTap: (){
                Get.back();
                // Get.off(Bottom(selectedIndex: 0, newIndex: 0,));
              },
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                child:SvgPicture.asset('assets/image/back.svg',
                  width: 20.4,
                  height: 20.5,
                  fit: BoxFit.scaleDown,
                  color: const Color(0xFF475467),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width-60,
              height: 32,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: () {
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
                        if(index == 4){
                          dragindex = 1;
                          DragItem.DKey.currentState?.setState(() {

                          });
                        }
                      },
                      child: Container(
                        width: 97,
                        height: 32,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.only(top: 6,bottom: 6,left: 6,right: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(42.0),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Color(0x4D000000),
                          //     offset: Offset(0, 1),
                          //     blurRadius: 3,
                          //   ),
                          //   BoxShadow(
                          //     color: Color(0x26000000),
                          //     offset: Offset(0, 4),
                          //     blurRadius: 8,
                          //     spreadRadius: 3,
                          //   ),
                          // ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 18.0,
                                height: 18.0,
                                padding: const EdgeInsets.only(
                                    top: 2.25, left: 2.25),
                                child: SvgPicture.asset(
                                  icons[index],
                                  width: 14.0,
                                  height: 14.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                items[index],
                                style: myTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        )
      ),
    );
  }
}
