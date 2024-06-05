import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucker/Lists/list.dart';
import 'package:trucker/main.dart';
import 'package:trucker/widgets/nearby_widget/move_home.dart';

class MyGridView extends StatefulWidget {
  final List<String> items;
  MyGridView({required this.items,});

  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 15.0,
      children: widget.items.map((item) {
        return InkWell(
          onTap: (){
            if(item=="ATM"){
              Get.to( Move(value:'Atm',head:"Atm"));
            }
            if(item=="Weigh Stations"){
              Get.to( Move(value:'Weigh',head:"Weigh Stations"));
            }
            if(item=="Laundry"){
              Get.to( Move(value:'Laundry Shop',head:'Laundry Shops'));
            }
            if(item=="Stores"){
              Get.to( Move(value:'Stores',head:'Stores'));
            }
            if(item=="WIFI"){
              Get.to( Move(value:'WIFI',head:'WIFI'));
            }
            if(item=="Gym"){
              Get.to( Move(value:'Gym',head:'Gyms'));
            }
            if(item=="Hotel"){
              Get.to( Move(value:'Hotel',head:'Hotels'));
            }
            if(item=="Parking"){
              Get.to( Move(value:'Parking',head:'Parkings'));
            }
            if(item=="Gas"){
              Get.to( Move(value:'Gas Stations',head:'Gas Stations'));
            }
            if(item=="Walmart"){
              Get.to( Move(value:'Walmart',head:'Walmarts'));
            }
            if(item=="Restaurants"){
              Get.to( Move(value:'Restaurant',head:'Restaurants'));
            }
            if(item=="Truck Washes"){
              Get.to( Move(value:'Truck Wash',head:'Truck Washes'));
            }
            if(item=="Repair Shops"){
              Get.to( Move(value:'Truck Repair',head:'Truck Repair'));
            }
            if(item=="Tire Care"){
              Get.to( Move(value:'Tire Care Shops',head:'Tire Care Shops'));
            }
            if(item=="Rest Areas"){
              Get.to( Move(value:'Rest Areas',head:'Rest Areas'));
            }
            if(item=="International"){
              Get.to( Move(value:'International',head:'Internationals'));
            }
            if(item=="Truck Stops"){
              Get.to( Move(value:'Truck Stops',head:'Truck Stops'));
            }
            if(item=="Loves"){
              Get.to( Move(value:'Loves Stations',head:'Loves Stations'));
            }
            if(item=="TA & Petro"){

              Get.to( Move(value:'TA & Petro Travel Centers',head:'TA & Petro Travel Centers'));
            }
            if(item=="Pilot & Flying J"){
              Get.to( Move(value:'Pilot & Flying J Travel Centers',head:'Pilot & Flying J Travel Centers'));
            }
            if(item=="Kwik Trip"){
              Get.to( Move(value:'Kwik Trip Centers',head:'Kwik Trip Centers'));
            }
            if(item=="Shower"){
              Get.to( Move(value:'Shower',head:'Showers'));
            }
            if(item=="Scales"){
              Get.to( Move(value:'Scales',head:'Scales'));
            }

          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(42),
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
            child: Text(
              item,
              style: const TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475467),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
