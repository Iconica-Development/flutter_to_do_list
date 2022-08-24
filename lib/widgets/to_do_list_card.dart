import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';

class ToDoListCardTheme {
  ToDoListCardTheme({
    this.headingStyle,
    this.bodyStyle,
    this.checkboxColor,
    this.percentageIndicatorBackground,
    this.percentageIndicatorText,
    this.cardColor,
  });
  TextStyle? headingStyle;
  TextStyle? bodyStyle;
  Color? checkboxColor;
  Color? percentageIndicatorBackground;
  TextStyle? percentageIndicatorText;
  Color? cardColor;
}

class ToDoListCard extends StatelessWidget {
  const ToDoListCard({required this.task, this.theme, Key? key})
      : super(key: key);

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
    return Container(
      width: width / 1.8,
      height: 280,
      decoration: BoxDecoration(
        color: theme?.cardColor ?? Color(task.hashCode).withAlpha(255),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width / 2.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    task.name,
                    style: textStyleHead,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                for (var subtask in task.subtasks) ...[
                  Row(
                    children: [
                      Icon(
                        subtask.percentageDone == 100
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank,
                        color: theme?.checkboxColor ??
                            Theme.of(context).primaryColor,
                      ),
                      Container(
                        width: width / 3.5,
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          subtask.name,
                          style: textStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: task.percentageDone / 100,
                strokeWidth: 3,
                color: theme?.percentageIndicatorBackground,
              ),
              Text(
                '${task.percentageDone.round()}%',
                style: percentageText,
              )
            ],
          ),
        ],
      ),
    );
  }
}
