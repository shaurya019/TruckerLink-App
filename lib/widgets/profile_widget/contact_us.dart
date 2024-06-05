// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crisp_chat/crisp_chat.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final String toEmail = 'whitefalcon01313@gmail.com';

  // Add the Website key generated from the Crisp website.
  final String websiteID = 'YOUR_WEBSITE_KEY';
  late CrispConfig config;
  @override
  void initState() {
    super.initState();
    config = CrispConfig(
      websiteID: websiteID,
    );
  }

  // This function is used to open email with user email and help email if user wants any help.
  void _openEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: toEmail,
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {}
  }

  // This widget is used to display the Contact us Page to the user.
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
              'Contact Us',
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
        padding: const EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        child: Column(
          children: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                _openEmail();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/image/email.svg'),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email To Us',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475467),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'whitefalcon01313@gmail.com',
                        style: TextStyle(
                          color: Color(0xFF98A1B2),
                          fontSize: 18,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () async {
                await FlutterCrispChat.openCrispChat(
                  config: config,
                );
              },
              child: Row(
                children: [
                  SvgPicture.asset('assets/image/Icon8.svg'),
                  const SizedBox(width: 12),
                  const Text(
                    'Chat with us',
                    style: TextStyle(
                      color: Color(0xFF475466),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
