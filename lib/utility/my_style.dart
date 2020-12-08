import 'dart:ui';

import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Color(0xffac1900);
  Color primaryColor = Color(0xffe65100);
  Color lightColor = Color(0xffff833a);

  Widget showProgress() => Center(child: CircularProgressIndicator());

  TextStyle whiteText() => TextStyle(color: Colors.white);

  Widget showTitleH2(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          color: darkColor,
          fontWeight: FontWeight.w700,
        ),
      );

  Widget showTitleH1(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 22,
          color: darkColor,
          fontWeight: FontWeight.w700,
        ),
      );

      Widget showTitleH1White(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      );

  Widget showLogo() => Image.asset('images/logo.png');

  MyStyle();
}
