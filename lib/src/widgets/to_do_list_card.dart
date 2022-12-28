// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:to_do_list/to_do_list.dart';

class ToDoListCardTheme {
  ToDoListCardTheme({
    this.headingStyle,
    this.bodyStyle,
    this.percentageIndicatorColor,
    this.percentageIndicatorBackgroundColor,
    this.percentageIndicatorText,
    this.cardDecoration,
    this.circularIndicatorStrokeWidth,
    this.subTaskDonePrefix,
    this.subTaskUndonePrefix,
    this.subTaskSpacing,
    this.indicatorSize,
  });

  TextStyle? headingStyle;
  TextStyle? bodyStyle;
  Color? percentageIndicatorBackgroundColor;
  Color? percentageIndicatorColor;
  TextStyle? percentageIndicatorText;
  BoxDecoration? cardDecoration;
  double? circularIndicatorStrokeWidth;
  Widget? subTaskDonePrefix;
  Widget? subTaskUndonePrefix;
  double? subTaskSpacing;
  double? indicatorSize;
}

/// Card shown in carousel of [ToDoList]
class ToDoListCard extends StatelessWidget {
  const ToDoListCard({
    required this.task,
    this.theme,
    Key? key,
  }) : super(key: key);

  final Task task;
  final ToDoListCardTheme? theme;

  @override
  Widget build(BuildContext context) {
    var textStyleHead =
        theme?.headingStyle ?? Theme.of(context).textTheme.headline6;
    var textStyle = theme?.bodyStyle ?? Theme.of(context).textTheme.bodyText1;
    var width = MediaQuery.of(context).size.width;
    var percentageText =
        theme?.percentageIndicatorText ?? Theme.of(context).textTheme.bodyText1;

    task.subtasks.sort(
      (a, b) => a.percentageDone.compareTo(b.percentageDone),
    );

    return Container(
      width: width / 1.8,
      height: 280,
      decoration: theme?.cardDecoration ??
          BoxDecoration(
            color: Color(task.hashCode).withAlpha(255),
            borderRadius: BorderRadius.circular(15),
          ),
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: width / 2.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: textStyleHead,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                if (task.subtasks.isNotEmpty)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: theme?.indicatorSize ?? 40,
                        height: theme?.indicatorSize ?? 40,
                        child: CircularProgressIndicator(
                          value: task.percentageDone / 100,
                          strokeWidth: theme?.circularIndicatorStrokeWidth ?? 3,
                          color: theme?.percentageIndicatorColor,
                          backgroundColor:
                              theme?.percentageIndicatorBackgroundColor,
                        ),
                      ),
                      Text(
                        '${task.percentageDone.round()}%',
                        style: percentageText,
                      )
                    ],
                  ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  for (var subtask in task.subtasks) ...[
                    Row(
                      children: [
                        subtask.percentageDone == 100.0
                            ? theme?.subTaskDonePrefix ??
                                const Icon(Icons.check_box_outlined)
                            : theme?.subTaskUndonePrefix ??
                                const Icon(Icons.check_box_outline_blank),
                        Container(
                          width: width / 2.5,
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Text(
                            subtask.name,
                            style: textStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: theme?.subTaskSpacing ?? 5,
                    )
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
