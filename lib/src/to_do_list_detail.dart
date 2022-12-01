// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:to_do_list/to_do_list.dart';

class ToDoListDetailTheme {
  TextStyle? bodyStyle;
  TextStyle? headingStyle;
  Color? percentageIndicatorBackground;
  Color? percentageIndicatorForeground;
  Color? checkBoxBgColor;
  Color? checkBoxCheckColor;
  Color? checkBoxSplashColor;
  ToDoListDetailTheme(
      {this.bodyStyle,
      this.headingStyle,
      this.percentageIndicatorBackground,
      this.percentageIndicatorForeground,
      this.checkBoxBgColor,
      this.checkBoxCheckColor,
      this.checkBoxSplashColor});
}

/// Detail view for [ToDoList]
class ToDoListDetail extends StatefulWidget {
  const ToDoListDetail({
    required this.task,
    this.avatarBuilder,
    this.onCheck,
    this.onJoinUser,
    this.theme,
    Key? key,
  }) : super(key: key);

  final Task task;
  final ToDoListDetailTheme? theme;

  /// Called when task is checked
  final void Function(Task parentTask, Task task, bool value)? onCheck;

  /// Avatar builder callback is called with a dynamic user
  /// to display the associated avatar
  final Widget Function(BuildContext context, dynamic user)? avatarBuilder;

  /// Called when user wants to join task
  final void Function(Task task)? onJoinUser;

  @override
  State<ToDoListDetail> createState() => _ToDoListDetailState();
}

class _ToDoListDetailState extends State<ToDoListDetail> {
  Task? selectedTask;

  @override
  Widget build(BuildContext context) {
    var headingStyle =
        widget.theme?.headingStyle ?? Theme.of(context).textTheme.headline6;
    var bodyStyle = widget.theme?.bodyStyle ??
        Theme.of(context).textTheme.bodyText1 ??
        const TextStyle();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(widget.task.name, style: headingStyle),
        ),
        for (var subtask in widget.task.subtasks) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () {
                if (selectedTask != subtask) {
                  setState(() {
                    selectedTask = subtask;
                  });
                } else {
                  setState(() {
                    selectedTask = null;
                  });
                }
              },
              child: Row(
                children: [
                  Transform.rotate(
                    angle: (selectedTask != null && selectedTask == subtask)
                        ? -pi / 2
                        : pi,
                    child: Icon(
                      Icons.chevron_left,
                      color: bodyStyle.color,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    width: MediaQuery.of(context).size.width / 2.8,
                    child: Text(
                      subtask.name,
                      style: bodyStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: subtask.percentageDone / 100,
                        backgroundColor:
                            widget.theme?.percentageIndicatorBackground,
                        color: widget.theme?.percentageIndicatorForeground,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '${subtask.percentageDone.round()}%'.padRight(4, '  '),
                      style: bodyStyle.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selectedTask != null && selectedTask == subtask) ...[
            const Divider(),
            for (var subsubtask in selectedTask!.subtasks) ...[
              Row(
                children: [
                  Checkbox(
                    checkColor: widget.theme?.checkBoxCheckColor,
                    fillColor: MaterialStateProperty.all(
                        widget.theme?.checkBoxBgColor),
                    overlayColor: MaterialStateProperty.all(
                        widget.theme?.checkBoxSplashColor),
                    value: subsubtask.isDone,
                    onChanged: (value) => widget.onCheck
                        ?.call(subtask, subsubtask, value ?? false),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onJoinUser?.call(subsubtask);
                    },
                    child: Text(
                      subsubtask.name,
                      style: bodyStyle,
                    ),
                  ),
                  if (widget.avatarBuilder != null &&
                      subsubtask.users.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Stack(
                        children: [
                          for (var i = 0; i < subsubtask.users.length; i++) ...[
                            Container(
                              margin: EdgeInsets.only(left: i * 12),
                              child: widget.avatarBuilder!
                                  .call(context, subsubtask.users[i]),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
            const Divider(),
          ],
        ],
      ],
    );
  }
}
