// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

// This is the UI of Terms and condition page.
class _TermsState extends State<Terms> {
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
              'Terms of Services',
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
                '1. Acceptance of Terms:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "By accessing or using the TruckerLink mobile application, you agree to be bound by these terms and conditions. If you do not agree to all of these terms, do not use this service.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '2. Services Description:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "TruckerLink provides a mobile app designed for truckers, offering tailored navigation, real-time communication, and community features. Services are subject to change or discontinuation without notice.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '3. User Registration:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Users may be required to register and provide certain personal information. You agree to provide accurate and complete information and to update it as necessary.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '4. Intellectual Property:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "All content included on TruckerLink, such as text, graphics, logos, and software, is the property of TruckerLink or its content suppliers and protected by intellectual property laws.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '5. Privacy:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Your use of TruckerLink is also governed by our Privacy Policy, which outlines our data collection and usage policies.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '6. Disclaimers:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "TruckerLink is provided ' as is ' without any warranties, express or implied. We do not guarantee that the service will be uninterrupted or error-free. You use this service at your own risk.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '7. Limitation of Liability:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "TruckerLink or its representatives will not be liable for any damages arising out of or related to your use of the service. This includes, but is not limited to, damages for loss of profits, goodwill, use, data, or other intangible losses.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '8. Modification of Terms:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "We reserve the right to modify these terms and conditions at any time. Your continued use of TruckerLink after such changes constitutes your acceptance of the new terms.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '9. Termination:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "We may terminate or suspend your access to TruckerLink immediately, without prior notice or liability, for any reason whatsoever, including, without limitation, if you breach the Terms.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF98A1B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '10. Governing Law:',
                style: TextStyle(
                  color: Color(0xFF475466),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "These terms shall be governed by the laws of the jurisdiction where TruckerLink is based without regard to its conflict of law provisions.",
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
