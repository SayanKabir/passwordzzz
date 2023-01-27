import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_manager/model/sharedPrefs_handler.dart';
import 'package:provider/provider.dart';
import 'manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pass_manager/model/themes_handler.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> ThemeProvider(),
      builder: (context, _){
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.getThemeMode(),
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          home: Manager(),
        );
      },
    );
  }
}