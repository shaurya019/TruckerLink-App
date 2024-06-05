import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:trucker/modals/message_modals.dart";
import 'package:trucker/requests/message_api.dart';

class SendMessage extends StatefulWidget {
  bool seenMessage;
  final time;
  final String message;
  final MessageType type;
  SendMessage({
    super.key,
    required this.message,
    required this.time,
    required this.seenMessage,
    required this.type,
  });

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(2),
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
                        const Text(
                          "You",
                          style: TextStyle(
                            color: Color(0xFFFF8D49),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            // tick
                            Icon(
                              Icons.done_all_outlined,
                              size: 14.0,
                              color: !widget.seenMessage
                                  ? const Color(0xFFD0D5DD)
                                  : const Color(0xFF475467),
                            ),
                            const SizedBox(width: 4),
                            //time
                            Text(
                              MessageApi.dateAndTime(
                                  context: context, time: widget.time),
                              style: const TextStyle(
                                color: Color(0xFF475466),
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    // acutal messages
                    const SizedBox(height: 12),
                    widget.type == MessageType.text
                        ? Text(
                      widget.message,
                      style: const TextStyle(
                        color: Color(0xFF475466),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        : Image.network(
                      widget.message,
                      height: 250,
                      width: 250,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8D49),
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
        ],
      ),
    );
  }
}
