import 'package:flutter/material.dart';

AppBar customAppBar(
    {required String message,
    double? height = 80,
    double? textHeight = 30,
    Color? color = Colors.black}) {
  return AppBar(
    toolbarHeight: height, // Set this height
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30.0),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(fontSize: textHeight, color: color),
      ),
    ),
  );
}
