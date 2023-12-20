// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:to_do_list/to_do_list.dart';

/// Detail view for [ToDoList]
class ToDoListDetail extends StatefulWidget {
  const ToDoListDetail({
    required this.task,
    this.avatarBuilder,
    this.onCheck,
    this.theme,
    this.user,
    this.sameUser,
    Key? key,
  }) : super(key: key);

  final Task task;
  final ToDoListDetailTheme? theme;
  final dynamic user;

  final bool Function(dynamic user, dynamic user2)? sameUser;

  /// Called when task is checked
  final void Function(Task parentTask, Task task, bool value)? onCheck;

  /// Avatar builder callback is called with a dynamic user
  /// to display the associated avatar
  final Widget Function(BuildContext context, dynamic user,
      AvatarType avatarType, Task parentTask, Task task)? avatarBuilder;

  @override
  State<ToDoListDetail> createState() => _ToDoListDetailDesign1State();
}

class _ToDoListDetailDesign1State extends State<ToDoListDetail> {
  Task? selectedTask;
  static const int maxAmountUsersShown = 3;

  @override
  Widget build(BuildContext context) {
    var headingStyle =
        widget.theme?.headingStyle ?? Theme.of(context).textTheme.titleLarge;
    var bodyStyle = widget.theme?.bodyStyle ??
        Theme.of(context).textTheme.bodyLarge ??
        const TextStyle();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Text(widget.task.name, style: headingStyle),
                widget.theme?.pageHeader ?? Container(),
              ],
            ),
          ),
          for (var subtask in widget.task.subtasks) ...[
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedTask != subtask) {
                      selectedTask = subtask;
                    } else {
                      selectedTask = null;
                    }
                  });
                },
                child: Container(
                  decoration: widget.theme?.subtaskBoxDecoration,
                  padding: widget.theme?.subtaskPadding,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            subtask.name,
                            style: bodyStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.8,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    minHeight: 7,
                                    value: subtask.percentageDone / 100,
                                    backgroundColor: widget
                                        .theme?.percentageIndicatorBackground,
                                    color: widget
                                        .theme?.percentageIndicatorForeground,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  '${subtask.percentageDone.round()}%'
                                      .padRight(4, '  '),
                                  style: bodyStyle.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      Transform.rotate(
                        angle: (selectedTask == subtask) ? -pi / 2 : pi,
                        child: Icon(
                          Icons.chevron_left,
                          color: bodyStyle.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (selectedTask == subtask) ...[
              for (var subSubTask in selectedTask?.subtasks ?? <Task>[]) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          subSubTask.name,
                          overflow: TextOverflow.ellipsis,
                          style: bodyStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (widget.avatarBuilder != null &&
                          subSubTask.users.isNotEmpty) ...[
                        if (getUsersWithoutCurrentUser(
                                    subSubTask.users, widget.user)
                                .length >
                            maxAmountUsersShown) ...[
                          Row(
                            children: [
                              Container(
                                child: widget.avatarBuilder?.call(
                                    context,
                                    getUsersWithoutCurrentUser(
                                            subSubTask.users, widget.user)
                                        .first,
                                    AvatarType.user,
                                    selectedTask!,
                                    subSubTask),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '+${getUsersWithoutCurrentUser(subSubTask.users, widget.user).length - 1}',
                                style: widget.theme?.avatarPlusStyle ??
                                    Theme.of(context).textTheme.bodyLarge,
                              )
                            ],
                          )
                        ] else ...[
                          Stack(
                            children: [
                              for (var taskUser in subSubTask.users) ...[
                                if (!(widget.sameUser
                                        ?.call(taskUser, widget.user) ??
                                    false))
                                  Container(
                                    margin: EdgeInsets.only(
                                        left:
                                            subSubTask.users.indexOf(taskUser) *
                                                25),
                                    child: widget.avatarBuilder?.call(
                                      context,
                                      taskUser,
                                      AvatarType.user,
                                      selectedTask!,
                                      subSubTask,
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ],
                      ],
                      const SizedBox(
                        width: 10,
                      ),
                      if (widget.sameUser != null) ...[
                        Container(
                          child: widget.avatarBuilder?.call(
                            context,
                            widget.user,
                            doesListContainUser(subSubTask.users, widget.user)
                                ? AvatarType.currentUserJoined
                                : AvatarType.currentUserNotJoined,
                            selectedTask!,
                            subSubTask,
                          ),
                        ),
                      ],
                      Checkbox(
                        checkColor: widget.theme?.checkBoxCheckColor,
                        fillColor: MaterialStateProperty.all(
                            widget.theme?.checkBoxBgColor),
                        overlayColor: MaterialStateProperty.all(
                            widget.theme?.checkBoxSplashColor),
                        value: subSubTask.isDone,
                        onChanged: (value) => widget.onCheck
                            ?.call(subtask, subSubTask, value ?? false),
                      ),
                    ],
                  ),
                ),
                if (subSubTask != selectedTask?.subtasks.last)
                  const Divider(
                    color: Color(0xFF979797),
                  ),
              ],
              const SizedBox(
                height: 40,
              ),
            ],
          ],
        ],
      ),
    );
  }

  bool doesListContainUser(List<dynamic> users, dynamic currentUser) {
    var containsUser = false;
    for (var user in users) {
      containsUser = widget.sameUser?.call(user, currentUser) ?? false;
      if (containsUser) break;
    }

    return containsUser;
  }

  List<dynamic> getUsersWithoutCurrentUser(
      List<dynamic> users, dynamic currentUser) {
    var filteredUsers = [];

    for (var user in users) {
      if (!(widget.sameUser?.call(currentUser, user) ?? false)) {
        filteredUsers.add(user);
      }
    }

    return filteredUsers;
  }
}
