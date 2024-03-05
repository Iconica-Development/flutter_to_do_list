import 'package:flutter/material.dart';

/// A class representing the theme configuration for ToDoListDetail widget.
class ToDoListDetailTheme {
  /// The text style for body text.
  TextStyle? bodyStyle;

  /// The text style for headings.
  TextStyle? headingStyle;

  /// The text style for avatar plus.
  TextStyle? avatarPlusStyle;

  /// The background color for percentage indicator.
  Color? percentageIndicatorBackground;

  /// The foreground color for percentage indicator.
  Color? percentageIndicatorForeground;

  /// The background color for checkboxes.
  Color? checkBoxBgColor;

  /// The color used to indicate a checked checkbox.
  Color? checkBoxCheckColor;

  /// The splash color for checkboxes.
  Color? checkBoxSplashColor;

  /// The box decoration for subtasks.
  BoxDecoration? subtaskBoxDecoration;

  /// The padding for subtasks.
  EdgeInsets? subtaskPadding;

  /// The header widget for the page.
  Widget? pageHeader;

  /// Creates a theme for the detail view of a ToDo list.
  ToDoListDetailTheme({
    this.bodyStyle,
    this.headingStyle,
    this.avatarPlusStyle,
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
