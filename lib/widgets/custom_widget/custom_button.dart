import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text; // Mark it as final
  final String routeName;
  final int butColour;
  final int textColour;
  const CustomButton(
      {Key? key,
      required this.text,
      required this.routeName,
      required this.butColour,
      required this.textColour})
      : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      // margin: const EdgeInsets.only(top: 300),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, widget.routeName);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          backgroundColor: Color(widget.butColour), // Background color
        ),
        //Color(0xFFFF8D49)
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16,
                color: Color(widget.textColour),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
