import 'package:flutter/material.dart';

class CustomText extends Text {

  CustomText(
      String text,
      {
        color : Colors.black,
        textAlign : TextAlign.center,
        factor,
        weight : FontWeight.normal,
        style : FontStyle.normal,
      }
      ):
      super(
        text,
        textAlign : textAlign,
        textScaleFactor : factor,
        style : TextStyle(
          color: color,
          fontWeight: weight,
          fontStyle: style,
        )
      );
}