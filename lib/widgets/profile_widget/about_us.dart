// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

// This Widget is used to display the about us page to the user.
class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
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
              'About Us',
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
      body: Container(
        padding: const EdgeInsets.only(left:16,top:16,right:16),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to TruckerLink, where we understand the challenges and solitude of the long-haul journey. Our mission is to make life on the road safer, more informed, and more connected for truckers everywhere.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Empowering the Journey:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "On the vast expanses of the open road, help can seem far away. But with TruckerLink, it's right at your fingertips. Our app is a beacon for drivers in distress, allowing them to send help requests to fellow truckers nearby. We're fostering a global community of truckers who look out for each other, ensuring that no one is ever truly alone.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Real-Time Road Intelligence:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "The road is full of surprises, but TruckerLink keeps you one step ahead. Unlike traditional navigation apps, we provide the ability to report and view real-time updates on road conditions, accidents, and hazards. This crowd-sourced intelligence allows drivers to reroute and avoid potential problems, making each journey smoother and safer.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Seamless Communication:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "On the road, your truck is your office, and staying connected should be effortless. TruckerLink's inbuilt chat feature allows for real-time communication, group chats, and one-on-one conversations, mirroring the ease and functionality of popular messaging apps. Whether it's logistics or just a friendly chat, staying in touch has never been easier.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'All Your Roadside Needs, One Platform:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "TruckerLink is about enhancing your entire driving experience. Whether you're searching for the nearest gas station, a place to eat, or a spot to rest, our comprehensive search feature ensures that what you need is never far away. From local amenities to emergency services, we're bringing all the essentials directly to your dashboard.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Our Vision:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "TruckerLink is more than just an app; it's a driving companion, a navigator, and a lifeline. We're committed to improving the lives of truckers, mile by mile, by providing a platform that not only solves problems but also fosters a sense of community and support. Join us on this journey, and become part of a community that's steering the future of trucking into a safer, more connected era.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
