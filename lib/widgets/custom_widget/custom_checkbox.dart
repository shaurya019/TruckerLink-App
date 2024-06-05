import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  double? size;
  double? iconSize;
  Function onChange;
  Color? backgroundColor;
  Color? iconColor;
  Color? borderColor;
  double? borderThickness; // New property for border thickness
  IconData? icon;
  bool isChecked;

  CustomCheckbox({
    Key? key,
    this.size,
    this.iconSize,
    required this.onChange,
    this.backgroundColor,
    this.iconColor,
    this.icon,
    this.borderColor,
    this.borderThickness, // Initialize the border thickness property
    required this.isChecked,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    isChecked = widget.isChecked;
    return
      Checkbox(
        value: isChecked,
        activeColor: widget.backgroundColor ?? Colors.blue,
        checkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6)
        ),
        visualDensity: VisualDensity.comfortable,
        onChanged: (_){
          setState(() {
            isChecked = _!;
            widget.onChange(isChecked);
          });
        },
      );
  }
}
