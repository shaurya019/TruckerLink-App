import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class searchBar extends StatefulWidget {
  final String name; // Add a name prop

  const searchBar(
      {super.key, required this.name}); // Constructor with name prop

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 297.0,
            height: 56.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(43.0),
              color: const Color(0xFFF2F4F7),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.search),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText:
                          widget.name, // Use the name prop for the hint text
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      height: 21.0 / 18.0,
                      letterSpacing: 0.0,
                      color: Color(0xFF98A2B3), // Text color
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 56.0,
            height: 56.0,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(43.0),
              border: Border.all(
                color: const Color(0xFFEAECF0), // Border color
                width: 1.0,
              ),
              // color: Color(0xFFEAECF0), // Background color
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5.0,
                  left: 3.0,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/image/icon.svg', // Replace with the path to your SVG image
                      width: 18.0, // Adjust the width as needed
                      height: 14.0, // Adjust the height as needed
                      // color: Color(0xFF98A2B3), // SVG image color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
