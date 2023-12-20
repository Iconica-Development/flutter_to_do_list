// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:math';

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
    this.emptyTaskBuilder,
    this.emptyTaskPercentageBuilder,
    this.seeMoreTextBuilder,
    this.seeMoreTextStyle,
  });
  String Function(int amount)? seeMoreTextBuilder;
  TextStyle? seeMoreTextStyle;
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
  Widget Function(Task task)? emptyTaskBuilder;
  Widget Function(Task task)? emptyTaskPercentageBuilder;
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
        theme?.headingStyle ?? Theme.of(context).textTheme.titleLarge;
    var textStyle = theme?.bodyStyle ?? Theme.of(context).textTheme.bodyLarge;
    var width = MediaQuery.of(context).size.width;
    var percentageText =
        theme?.percentageIndicatorText ?? Theme.of(context).textTheme.bodyLarge;

    var seeMoreTextStyle = theme?.seeMoreTextStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.underline,
            );

    task.subtasks.sort(
      (a, b) => a.percentageDone.compareTo(b.percentageDone),
    );

    var amountOfCards = amountOfCardsInView();
    var subtasksToDisplay = amountOfCards < task.subtasks.length
        ? amountOfCards
        : task.subtasks.length;

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
                if (task.subtasks.isNotEmpty) ...[
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
                ] else ...[
                  theme?.emptyTaskPercentageBuilder?.call(task) ??
                      const SizedBox.shrink(),
                ],
              ],
            ),
            Expanded(
              child: task.subtasks.isNotEmpty
                  ? ListView(
                      children: [
                        for (var subtask = 0;
                            subtask < subtasksToDisplay;
                            subtask++) ...[
                          Row(
                            children: [
                              task.subtasks[subtask].percentageDone == 100.0
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
                                  task.subtasks[subtask].name,
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
                    )
                  : theme?.emptyTaskBuilder?.call(task) ??
                      const SizedBox.shrink(),
            ),
            if (task.subtasks.length > subtasksToDisplay)
              Text(
                theme?.seeMoreTextBuilder
                        ?.call(task.subtasks.length - amountOfCards) ??
                    "Click to see ${task.subtasks.length - amountOfCards} more",
                style: seeMoreTextStyle,
              )
          ],
        ),
      ),
    );
  }

  double calculateRowHeight() {
    // Assume default values if theme styles are null
    double taskNameHeight =
        theme?.headingStyle?.fontSize ?? 18.0; // Default font size
    double textStyleHeight =
        theme?.bodyStyle?.fontSize ?? 16.0; // Default font size
    double padding = theme?.subTaskSpacing ?? 5; // Padding between rows
    return max(taskNameHeight, textStyleHeight) + padding;
  }

  int amountOfCardsInView() {
    double totalCardHeight = 280.0; // Total height of the card
    double taskNameHeight =
        theme?.headingStyle?.fontSize ?? 18.0; // Default font size
    double progressIndicatorHeight =
        theme?.indicatorSize ?? 40.0; // Default progress indicator size
    double clickToSeeMoreTextHeight =
        theme?.bodyStyle?.fontSize ?? 16.0; // Default font size
    double spacing =
        15.0; // Spacing around progress indicator and 'Click to see more' text
    // Calculate the height available for subtasks
    double availableHeight = totalCardHeight -
        max(taskNameHeight, progressIndicatorHeight) -
        clickToSeeMoreTextHeight -
        (2 * spacing);
    double rowHeight = calculateRowHeight();
    // Calculate the number of cards that can fit into the available height
    return (availableHeight / rowHeight).floor();
  }
}
