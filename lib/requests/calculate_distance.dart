import 'dart:math' show cos, sqrt, asin;

class CalculateDistance {
  CalculateDistance._privateConstructor();

  static final CalculateDistance instance = CalculateDistance._privateConstructor();

  factory CalculateDistance() {
    return instance;
  }


  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

}