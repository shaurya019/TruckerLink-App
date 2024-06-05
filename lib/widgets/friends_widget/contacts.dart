import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/screens/friends_screen/contacts.dart';
import 'package:trucker/screens/home_screen/home.dart';
import 'package:trucker/screens/splash_screen/splash.dart';

class Contact_sheet extends StatefulWidget {
  const Contact_sheet({super.key});

  @override
  State<Contact_sheet> createState() => _Contact_sheetState();
  // static final sheetKey = GlobalKey();
}

class _Contact_sheetState extends State<Contact_sheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Contacts',
                style: TextStyle(
                  color: Color(0xFF475467),
                  fontFamily: 'SF Pro',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(Contacts(onTap: () {  },));
                },
                child: const Text(
                  'see more',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    color: Color(0xFFEC6A00), // Text color
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),

        finalDetailsList.isNotEmpty
            ? SizedBox(
          height: 68.0,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: finalDetailsList.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              var phoneDetails = finalDetailsList.elementAt(index).pNumber;
              return InkWell(
                onTap: () {
                  Get.to(Contacts(onTap: () {  },));
                },
                child: Container(
                  width: 144.0,
                  height: 52.0,
                  margin: const EdgeInsets.only(top: 8, bottom: 8,right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: const Color(0x00ffffff),
                    borderRadius: BorderRadius.circular(38.0),
                    border: Border.all(
                      color: const Color(0xFFEAECF0),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2970FF),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFEAECF0),
                            width: 1.0,
                          ),
                        ),
                        child:SvgPicture.asset(
                          'assets/image/person.svg',
                          height: 18.33,
                          width: 15,
                          color: Colors.white,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              finalDetailsList.elementAt(index).pName,
                              style: const TextStyle(
                                fontFamily: 'SF Pro',
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF475467),
                              ),
                            ),
                            // SizedBox(height: 2,),
                            const Text(
                              'Hey There!',
                              style: TextStyle(
                                fontFamily: 'SF Pro',
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF98A2B3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
            : const Text(
          "No Contacts",
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475467),
          ),
        ),
      ],
    );
  }
}
