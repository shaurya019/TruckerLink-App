import "dart:developer";
import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:get/get.dart";
import "package:trucker/screens/email_screen/email_login.dart";

class ForgetPassword extends StatefulWidget {
  final String phone;
  final CountryCode? countryCode;
  const ForgetPassword({super.key, this.countryCode, required this.phone});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();

  // This Functio is used to reset the password if user forget he's password.
  void resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      log("Something went wrong ${e.code}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: 354,
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forgot password",
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  color: Color(0xFF475467),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Enter your Email",
                    hintStyle: TextStyle(
                      fontFamily: 'SF Pro',
                      color: Color(0xFF98A2B3),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFFF8D49),
                ),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    resetPassword();
                    Get.off(() => LoginPage(
                      countryCode: widget.countryCode,
                      phone: widget.phone,
                    ));
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 2.0),
                      child: const Text(
                        "Continue",
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
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0xFFF2F4F7),
                ),
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Center(
                    child: Center(
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.0,
                          color: Color(0xFF98A2B3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
