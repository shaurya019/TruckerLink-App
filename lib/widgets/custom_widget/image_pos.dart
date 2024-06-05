import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImagePos extends StatefulWidget {
  int length;
  ImagePos({super.key,required this.length});

  @override
  State<ImagePos> createState() => _ImagePosState();
}

class _ImagePosState extends State<ImagePos> {

  @override
  Widget build(BuildContext context) {
    // print("length - ${widget.length}");
    return widget.length == 1
        ?
        Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 46.0,
            height: 46.0,
            decoration: BoxDecoration(
              color: const Color(0xFF98A2B3),
              borderRadius: BorderRadius.circular(43),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child:SvgPicture.asset(
              'assets/image/person.svg',
              color: Colors.white,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ],
    )
        :
    widget.length == 2 ?
    Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 56.0,
            maxHeight: 35.0,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 35.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: const Color(0xFF98A2B3),
                borderRadius: BorderRadius.circular(43),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child:SvgPicture.asset(
                'assets/image/person.svg',
                color: Colors.white,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 56.0,
              maxHeight: 35.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF98A2B3),
                  borderRadius: BorderRadius.circular(43),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child:SvgPicture.asset(
                  'assets/image/person.svg',
                  color: Colors.white,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
        ),
      ],
    )
        :
    Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          right: 0,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 56.0,
              maxHeight: 35.0,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF98A2B3),
                  borderRadius: BorderRadius.circular(43),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child:SvgPicture.asset(
                  'assets/image/person.svg',
                  color: Colors.white,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(
            maxWidth: 56.0,
            maxHeight: 35.0,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 35.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: const Color(0xFF98A2B3),
                borderRadius: BorderRadius.circular(43),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child:SvgPicture.asset(
                'assets/image/person.svg',
                color: Colors.white,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 56.0,
              maxHeight: 35.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF98A2B3),
                  borderRadius: BorderRadius.circular(43),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child:SvgPicture.asset(
                  'assets/image/person.svg',
                  color: Colors.white,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
