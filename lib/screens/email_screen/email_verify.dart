import "package:country_code_picker/country_code_picker.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:trucker/screens/email_screen/email_login.dart";

class VerifyEmail extends StatefulWidget {
  final String phone;
  final CountryCode? countryCode;
  const VerifyEmail({super.key, this.countryCode, required this.phone});
  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool emailVerified = false;

  @override
  void initState() {
    super.initState();

    //It will check weather the user email is verified or not if it was verified than the user move to next page else he will land to this page to veify it email.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && user.emailVerified) {
        setState(() {
          emailVerified = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please Verify your Email Address",
              style: TextStyle(
                color: Color(0xFF475466),
                fontSize: 20,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
                height: 0.07,
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () async {
                Get.offAll(() => LoginPage(
                    countryCode: widget.countryCode, phone: widget.phone));
              },
              child: Container(
                width: double.infinity,
                height: 45,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFFF8D49),
                ),
                child: TextButton(
                  onPressed: null,
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Center(
                    child: Text(
                      'Go to login page',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
