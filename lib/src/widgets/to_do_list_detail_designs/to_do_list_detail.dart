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

  @override
  Widget build(BuildContext context) {
    var headingStyle =
        widget.theme?.headingStyle ?? Theme.of(context).textTheme.headline6;
    var bodyStyle = widget.theme?.bodyStyle ??
        Theme.of(context).textTheme.bodyText1 ??
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
                        angle: (selectedTask != null && selectedTask == subtask)
                            ? -pi / 2
                            : pi,
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
            if (selectedTask != null && selectedTask == subtask) ...[
              for (var i = 0; i < selectedTask!.subtasks.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedTask!.subtasks[i].name,
                          overflow: TextOverflow.ellipsis,
                          style: bodyStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (widget.avatarBuilder != null &&
                          selectedTask!.subtasks[i].users.isNotEmpty) ...[
                        if (getUsersWithoutCurrentUser(
                                    selectedTask!.subtasks[i].users,
                                    widget.user)
                                .length >
                            3) ...[
                          Row(
                            children: [
                              Container(
                                child: widget.avatarBuilder!.call(
                                  context,
                                  getUsersWithoutCurrentUser(
                                      selectedTask!.subtasks[i].users,
                                      widget.user)[0],
                                  AvatarType.user,
                                  selectedTask!,
                                  selectedTask!.subtasks[i],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '+${getUsersWithoutCurrentUser(selectedTask!.subtasks[i].users, widget.user).length - 1}',
                                style: widget.theme?.avatarPlusStyle ??
                                    Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          )
                        ] else ...[
                          Stack(
                            children: [
                              for (var j = 0;
                                  j < selectedTask!.subtasks[i].users.length;
                                  j++) ...[
                                if (!(widget.sameUser?.call(
                                        selectedTask!.subtasks[i].users[j],
                                        widget.user) ??
                                    false))
                                  Container(
                                    margin: EdgeInsets.only(left: j * 25),
                                    child: widget.avatarBuilder!.call(
                                      context,
                                      selectedTask!.subtasks[i].users[j],
                                      AvatarType.user,
                                      selectedTask!,
                                      selectedTask!.subtasks[i],
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
                      if (widget.sameUser != null)
                        Container(
                          child: widget.avatarBuilder!.call(
                            context,
                            widget.user,
                            doesListContainUser(selectedTask!.subtasks[i].users,
                                    widget.user)
                                ? AvatarType.currentUserJoined
                                : AvatarType.currentUserNotJoined,
                            selectedTask!,
                            selectedTask!.subtasks[i],
                          ),
                        ),
                      Checkbox(
                        checkColor: widget.theme?.checkBoxCheckColor,
                        fillColor: MaterialStateProperty.all(
                            widget.theme?.checkBoxBgColor),
                        overlayColor: MaterialStateProperty.all(
                            widget.theme?.checkBoxSplashColor),
                        value: selectedTask!.subtasks[i].isDone,
                        onChanged: (value) => widget.onCheck?.call(
                            subtask, selectedTask!.subtasks[i], value ?? false),
                      ),
                    ],
                  ),
                ),
                if (selectedTask!.subtasks.length - 1 != i)
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

  bool doesListContainUser(List<dynamic> users, dynamic user) {
    bool containsUser = false;

    for (var otherUser in users) {
      containsUser = widget.sameUser?.call(otherUser, user) ?? false;
      if (containsUser) break;
    }

    return containsUser;
  }

  List<dynamic> getUsersWithoutCurrentUser(
      List<dynamic> users, dynamic currentUSer) {
    var filteredUsers = [];

    for (var user in users) {
      if (!(widget.sameUser?.call(currentUSer, user) ?? false)) {
        filteredUsers.add(user);
      }
    }

    return filteredUsers;
  }
}
