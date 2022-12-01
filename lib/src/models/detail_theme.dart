import 'package:flutter/material.dart';

class ToDoListDetailTheme {
  TextStyle? bodyStyle;
  TextStyle? headingStyle;
  Color? percentageIndicatorBackground;
  Color? percentageIndicatorForeground;
  Color? checkBoxBgColor;
  Color? checkBoxCheckColor;
  Color? checkBoxSplashColor;
  BoxDecoration? subtaskBoxDecoration;
  EdgeInsets? subtaskPadding;
  Widget? pageHeader;

  ToDoListDetailTheme({
    this.bodyStyle,
    this.headingStyle,
    this.percentageIndicatorBackground,
    this.percentageIndicatorForeground,
    this.checkBoxBgColor,
    this.checkBoxCheckColor,
    this.checkBoxSplashColor,
    this.subtaskBoxDecoration,
    this.subtaskPadding,
    this.pageHeader,
  });
}
