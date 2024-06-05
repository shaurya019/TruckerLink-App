import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trucker/widgets/profile_widget/about_us.dart';
import 'package:trucker/widgets/profile_widget/contact_us.dart';
import 'package:trucker/widgets/profile_widget/map_setting_change.dart';
import 'package:trucker/widgets/profile_widget/privacy_policy.dart';
import 'package:trucker/widgets/profile_widget/terms.dart';
import 'package:trucker/widgets/profile_widget/trips.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
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
              'Settings',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height-300,
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Get.to(const MapSettingChange());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/image/Icon1.svg'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'Map settings',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475467),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Get.to(const TripHistory());
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/image/Icon2.svg'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'History of trips',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          // height: 1.1667,
                          letterSpacing: 0,
                          color: Color(0xFF475467),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Get.to(const ProfilePolicy());
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/image/privacypolicy.svg'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          // height: 1.1667,
                          letterSpacing: 0,
                          color: Color(0xFF475467),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                    onPressed: (){
                      Get.to(const Terms());
                    },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/image/termsandcondition.svg'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'Terms of Service',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          // height: 1.1667,
                          letterSpacing: 0,
                          color: Color(0xFF475467),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Get.to(const AboutUs());
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/image/aboutus.svg'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'About us',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          // height: 1.1667,
                          letterSpacing: 0,
                          color: Color(0xFF475467),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Get.to(const ContactUs());
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/image/contactus.svg'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          // height: 1.1667,
                          letterSpacing: 0,
                          color: Color(0xFF475467),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.all(16.0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'We value your privacy.',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF98A2B3),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Please see our Terms and Privacy Policy.',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF98A2B3),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'All rights reserved, truckerlink 2023',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
