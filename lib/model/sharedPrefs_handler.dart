import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageHandler{
  // static final _secureStorage = FlutterSecureStorage();
  // static const _keyTag = "passKey";
  // static const _ivTag = "passIV";
  //
  // static Future<void> saveData({required String tag, required Uint8List data}) async{
  //   await _secureStorage.write(key: tag, value: String.fromCharCodes(data));
  // }
  // static Future<Uint8List?> readData({required String tag}) async{
  //   final data = await _secureStorage.read(key: tag);
  //   final List<int> codeUnits = data!.codeUnits;
  //   return Uint8List.fromList(codeUnits);
  // }
}
class SharedPrefsHandler{
  //The following functions save and retrieve bool data from shared preferences according to the given tag
  static void saveData({required String tag, required bool data}) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(tag, data);
  }
  static Future<dynamic> readData({required String tag}) async{
    final prefs = await SharedPreferences.getInstance();
    dynamic val = prefs.getBool(tag);
    return val;
  }
}