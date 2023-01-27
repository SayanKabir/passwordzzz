import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sharedPrefs_handler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  ThemeMode getThemeMode() => themeMode;

  ThemeProvider(){
    SharedPrefsHandler.readData(tag: "isDarkMode").then((value){
      if(value==true)
        themeMode=ThemeMode.dark;
      else if(value==false)
        themeMode=ThemeMode.light;
      else
        themeMode=ThemeMode.system;

      notifyListeners();
    });
  }
  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }
  void toggleTheme() async{
    if (isDarkMode)
      themeMode = ThemeMode.light;
    else
      themeMode = ThemeMode.dark;

    SharedPrefsHandler.saveData(tag: "isDarkMode", data: isDarkMode);
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.black,
    // shadowColor: Colors.white,
    colorScheme: ColorScheme.dark().copyWith(
      primary: Color(0xffccffff),
    ),
    iconTheme: IconThemeData(color: Colors.white, opacity: 0.8),
    cardColor: Color(0xff1f1f1f),
    // cardColor: Colors.black,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xffffffff),
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light().copyWith(
      onBackground: Colors.black,
      primary: Color(0xff1d5c5c),
    ),
    iconTheme: IconThemeData(color: Colors.black, opacity: 0.8),
    cardColor: Color(0xfff1f5f5),
  );
}
