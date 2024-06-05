import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/widgets/maps_widget/map_setting.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';

String googleMapsTheme = lightThemeJson;

const darkThemeJson =
'''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#263c3f"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6b9a76"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#38414e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#212a37"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9ca5b3"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1f2835"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#f3d19c"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2f3948"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#515c6d"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  }
]
''';

const lightThemeJson =
'''
[
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]
''';

int selectedThemeIndex = 0;

// final Completer<GoogleMapController> _controller = Completer();
class MapTheme extends StatefulWidget {
  final Function onChange;
  MapTheme({super.key, required this.onChange});

  @override
  State<MapTheme> createState() => _MapThemeState();
}

class _MapThemeState extends State<MapTheme> {
  double imageHeight = 68.0;
  @override
  void initState() {
    super.initState();
    if (googleMapsTheme == lightThemeJson) {
      selectedThemeIndex = 1;
    } else if (googleMapsTheme == darkThemeJson) {
      selectedThemeIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Map Theme',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475467),
                ),
              ),
              InkWell(
                onTap: () {
                  MapSetting.staticKey.currentState?.setIndex(0);
                  widget.onChange(0);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(55),
                  ),
                  child: SvgPicture.asset(
                    'assets/image/cross.svg',
                    width: 24,
                    height: 24,
                    color: const Color(0xFF475467),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildMapStyleOption(1, 'Light', 'assets/image/mapTheme1.png'),
              buildMapStyleOption(2, 'Dark', 'assets/image/mapTheme2.png'),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }

  Widget buildMapStyleOption(int index, String title, String imagePath) {
    final isSelected = selectedThemeIndex == index;
    return InkWell(
      onTap: () {
        if (index == 1) {
          currentMapType = MapType.normal;
          googleMapsTheme = lightThemeJson;
          mapController?.setMapStyle(googleMapsTheme);
        }
        if (index == 2) {
          currentMapType = MapType.normal;
          googleMapsTheme = darkThemeJson;
          mapController?.setMapStyle(googleMapsTheme);
        }
        setState(() {
          selectedThemeIndex = index;
        });
      },
      child: Container(
        height: 96,
        width: 68,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.37),
                border: Border.all(
                  width: 3.78,
                  color:
                  isSelected ? const Color(0xFFFF8D49) : Colors.transparent,
                ),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                height: 1.25,
                letterSpacing: 0.0,
                color: isSelected
                    ? const Color(0xFFFF8D49)
                    : const Color(0xFF5D5E67),
              ),
            )
          ],
        ),
      ),
    );
  }
}
