import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget widgetText(String text,
    {double fontSize = 14,
    Color? color,
    FontWeight fontWeight = FontWeight.w500}) {
  return Text(
    text,
    maxLines: 100,
    style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.black,
        fontWeight: fontWeight),
  );
}
