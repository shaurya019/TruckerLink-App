import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:trucker/widgets/search_widget/search_bottom_sheet.dart';
import 'package:trucker/widgets/search_widget/search.dart';

class SearchScreen extends StatelessWidget {
  final DetailsResult? startPosition;
  final String duration;
  const SearchScreen({
    super.key,
    this.startPosition,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          MapSearchScreen(startPosition: startPosition),
          DragSearch(
              screenIndex: 0, startPosition: startPosition, duration: duration),
        ],
      ),
    );
  }
}
