import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:trucker/widgets/home_widget/bottom_sheet_item.dart';
import 'package:trucker/widgets/nearby_widget/move_home.dart';
import 'package:trucker/widgets/nearby_widget/search_auto.dart';


List<DetailsResult>stuff = [];

class NearBy extends StatefulWidget {
  NearBy({super.key,});
  @override
  State<NearBy> createState() => _NearByState();
}

class _NearByState extends State<NearBy> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Near by',
                style: TextStyle(
                  color: Color(0xFF475467),
                  fontFamily: 'SF Pro',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () {
                  dragindex = 1;
                  DragItem.DKey.currentState?.setState(() {

                  });
                },
                child: const SizedBox(
                  width: 64.0,
                  height: 20.0,
                  child: Text(
                    'See more',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      color: Color(0xFFEC6A00), // Text color
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      height: 20.0 / 14.0,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          height: 100.0,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, int index) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to( Move(value:'Pilot & Flying J Travel Centers',head:'Pilot & Flying J Travel Centers'));
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/image/new_frame.png')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Get.to( Move(value:'TA & Petro Travel Centers',head:'TA & Petro Travel Centers'));
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/image/new_frame2.png'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Get.to( Move(value:'Loves Stations',head:'Loves Stations'));
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/image/new_frame3.png')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Get.to( Move(value:'Kwik Trip Centers',head:'Kwik Trip Centers'));
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/image/new_frame4.png')),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}