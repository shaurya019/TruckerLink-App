import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trucker/screens/friends_screen/contacts.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.onTap, this.onGroupCreated});
  final VoidCallback onTap;
  final VoidCallback? onGroupCreated;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
       Get.to(()=> Contacts( onTap: onTap, onGroupCreated: onGroupCreated,));
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: 56.0,
        height: 56.0,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFF8D49),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0000004D),
              offset: Offset(0.0, 1.0),
              blurRadius: 3.0,
              spreadRadius: 0.0,
            ),
            BoxShadow(
              color: Color(0x00000026),
              offset: Offset(0.0, 4.0),
              blurRadius: 8.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 2, left: 2),
          child: SvgPicture.asset(
            'assets/image/message.svg',
            width: 20,
            height: 20,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
