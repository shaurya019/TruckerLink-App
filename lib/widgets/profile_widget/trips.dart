// ignore_for_file: unused_local_variable

import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/widgets/help_widget/help_history_page.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({super.key});

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {



  @override
  Widget build(BuildContext context) {
   if(tripsData.isNotEmpty){
     tripsData = tripsData.reversed.toList();
   }
    TextStyle global = const TextStyle(
      fontFamily: 'SF Pro',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF98A2B3),
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF344054),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'History of trips',
              style: TextStyle(
                fontFamily: 'SF Pro',
                color: Color(0xFF344054),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD0D5DD),
                Color(0xFFEAECF0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: loadingTrips
          ? const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
        ),
      )
          : tripsData.isNotEmpty
          ? ListView.builder(
              itemCount: tripsData.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, i) {
                String dateAndTime = dateFix(
                    '${tripsData[i].time} -  ${tripsData[i].date}');
                return InkWell(
                  onTap: () {
                    showTripDetails(
                        tripsData[i].start, tripsData[i].destination);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left:16,top:16,right:16),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2970FF),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: SvgPicture.asset(
                                'assets/image/person.svg',
                                height: 18.33,
                                width: 15,
                                color: Colors.white,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          3.5,
                                      child: Text(
                                        tripsData[i].start,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        '➜',
                                        style: TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          3,
                                      child: Text(
                                        tripsData[i].destination,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateAndTime,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF98A1B2),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })
          : Center(
        child: Container(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 68),
          child: Column(
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/image/nonearby.svg',
                    width: 64,
                    height: 64,
                    fit: BoxFit
                        .cover, // You can adjust the fit as needed
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Seems like we couldn\'t Make',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475467),
                        ),
                      ),
                      Text(
                        'a Trip.',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475467),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'Try to search again with different keywords.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF667085),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // This will display all the Trip details of the user.
  void showTripDetails(String start, String dest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: IntrinsicHeight(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: const Color(0xFFF2F3F6),
                            padding: const EdgeInsets.all(16.0),
                            child: const Text(
                              'Trip Info',
                              style: TextStyle(
                                color: Color(0xFF475466),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Starting - ",
                                      style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF475467),
                                      ),
                                    ),
                                    Text(
                                      start,
                                      style: const TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF475467),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Destination - ",
                                      style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF475467),
                                      ),
                                    ),
                                    Text(
                                      dest,
                                      style: const TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF475467),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color(0xFFEAECF0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(25.0),
                                child: const TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                      color: Color(0xFFFF5449),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }




}
