import 'package:flutter/material.dart';
import 'package:technologies_icons_download_png_svg/home_ui.dart';
import 'package:technologies_icons_download_png_svg/strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyStrings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeUi()
    );
  }
}
