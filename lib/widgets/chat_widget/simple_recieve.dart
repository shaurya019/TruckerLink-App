import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:trucker/modals/message_modals.dart";
import 'package:trucker/requests/message_api.dart';

class SimpleReceive extends StatefulWidget {
  final String sendName;
  final String sendMessage;
  final String sendMessageTime;
  final MessageType type;
  SimpleReceive({
    super.key,
    required this.sendName,
    required this.sendMessage,
    required this.sendMessageTime,
    required this.type,
  });

  @override
  State<SimpleReceive> createState() => _SimpleReceiveState();
}

class _SimpleReceiveState extends State<SimpleReceive> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: const Color(0xFF98A2B3),
              borderRadius: BorderRadius.circular(43),
            ),
            child: SvgPicture.asset(
              'assets/image/person.svg',
              width: 18.0,
              height: 18.0,
              color: Colors.white,
              fit: BoxFit.scaleDown,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: IntrinsicHeight(
              child: Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                decoration: const ShapeDecoration(
                  color: Color(0xFFEAECF0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(2),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  name and time and seen info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //user name
                        Text(
                          widget.sendName,
                          style: const TextStyle(
                            color: Color(0xFF475466),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          MessageApi.dateAndTime(
                              context: context, time: widget.sendMessageTime),
                          style: const TextStyle(
                            color: Color(0xFF475466),
                            fontSize: 11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    // acutal messages
                    const SizedBox(height: 12),
                    widget.type == MessageType.text
                        ? Text(
                      widget.sendMessage,
                      style: const TextStyle(
                        color: Color(0xFF475466),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        : Image.network(
                      widget.sendMessage,
                      height: 250,
                      width: 250,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
