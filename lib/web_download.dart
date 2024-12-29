import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:universal_html/html.dart';

Future<bool> saveAndLaunchFileWeb(List<int> bytes, String fileName) async {
  try{
    AnchorElement(
        href:
        "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", fileName)
      ..click();
    return true;
  }
  catch(e){
    return false;
  }
}
Future<List<int>> loadSvgAsBytes(String assetPath) async {
  try {
    // Load the SVG file as a string from assets
    final String svgString = await rootBundle.loadString(assetPath);

    // Convert the string to a list of bytes
    final Uint8List svgBytes = Uint8List.fromList(svgString.codeUnits);

    return svgBytes;
  } catch (e) {
    throw Exception("Error loading SVG as bytes: $e");
  }
}