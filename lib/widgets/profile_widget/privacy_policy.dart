// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePolicy extends StatefulWidget {
  const ProfilePolicy({super.key});

  @override
  State<ProfilePolicy> createState() => _ProfilePolicyState();
}

// This is UI widget that is used to display the privacy policy to the user.
class _ProfilePolicyState extends State<ProfilePolicy> {
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
            const SizedBox(
              width: 12,
            ),
            const Text(
              'Privacy Policy',
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
                'Introduction:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Welcome to TruckerLink! We are committed to protecting the privacy of our users and ensuring a secure experience. This privacy policy outlines the types of information we collect, how it's used, and the steps we take to safeguard your data.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Information Collection:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Personal Information: We may collect personal information such as your name, email address, and contact details when you register for an account or update your profile.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Location Data: Given the nature of our services, we collect real-time location data to provide tailored navigation and updates.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Usage Data: We collect information on how you use the app, such as the features accessed and time spent on the app, to improve our services.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Use of Information:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Service Provision: Your information helps us personalize and improve your experience, provide customer support, and communicate important updates.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Community Interaction: We foster a community of truckers by facilitating communication and connections among users.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Analytics and Improvement: We analyze usage patterns to enhance app performance and introduce new features.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Data Sharing and Disclosure:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Service Providers: We may share your information with trusted third parties who assist in operating our services, such as cloud hosting and analytics providers.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Legal Requirements: If required by law, we may disclose your information to comply with legal processes or protect our rights and safety.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Consent: We may share your information for other purposes with your explicit consent.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Data Security:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "We implement robust security measures to protect your information from unauthorized access, alteration, or destruction. However, please note that no method of transmission over the internet is entirely secure.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Updates to Privacy Policy:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "We may update this policy periodically to reflect changes in our practices or legal requirements. We will notify you of any significant changes.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "If you have questions or concerns about our privacy practices and policies",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Please contact us at whitefalcon01313@gmail.com.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
