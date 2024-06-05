import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  SharedPreferences? _prefs;

  SharedPreferencesService._internal();

  static SharedPreferencesService getInstance() {
    _instance ??= SharedPreferencesService._internal();
    return _instance!;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get name => _prefs?.getString('name');
  String? get email => _prefs?.getString('email');
  String? get userId => _prefs?.getString('userId');
  String? get phoneNumber => _prefs?.getString('phoneNumber');
  String? get dialCode => _prefs?.getString('dialCode');
  String? get countryCode => _prefs?.getString('countryCode');
  String? get ethnicity => _prefs?.getString('ethnicity');
  String? get imageUrl => _prefs?.getString('imageUrl');

  // This Function is used to store all the user related data to the locally in the shared preferences for.
  Future<void> saveFormData(
      String name,
      String email,
      String userId,
      String phoneNumber,
      String dialCode,
      String countryCode,
      String ethnicity,
      String imageUrl,
      ) async {
    await _prefs?.setString('name', name);
    await _prefs?.setString('email', email);
    await _prefs?.setString('userId', userId);
    await _prefs?.setString('phoneNumber', phoneNumber);
    await _prefs?.setString('dialCode', dialCode);
    await _prefs?.setString('countryCode', countryCode);
    await _prefs?.setString('ethnicity', ethnicity);
    await _prefs?.setString('imageUrl', imageUrl);
  }
}
