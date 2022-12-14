// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:to_do_list/to_do_list.dart';

void main() {
  runApp(const MaterialApp(home: ToDoListExampleApp()));
}

class ToDoListExampleApp extends StatefulWidget {
  const ToDoListExampleApp({Key? key}) : super(key: key);

  @override
  State<ToDoListExampleApp> createState() => _ToDoListExampleAppState();
}

class _ToDoListExampleAppState extends State<ToDoListExampleApp> {
  var tasks = [
    Task(
      name: 'Household Tasks',
      subtasks: [
        Task(
          name: 'Cleaning',
          subtasks: [
            Task(name: 'Clean living room', users: [
              2,
              1,
            ]),
            Task(name: 'Clean kitchen', users: [1], isDone: true),
            Task(name: 'Clean bathroom', users: [1]),
            Task(name: 'Clean bedroom', users: []),
          ],
        ),
        Task(
          name: 'Cooking',
          subtasks: [
            Task(name: 'Boiling eggs', users: [3], isDone: true),
            Task(name: 'Baking pancakes', users: [2]),
            Task(name: 'Making drinks', users: [2, 3], isDone: true),
          ],
        ),
        Task(
          name: 'Taking out trash',
          subtasks: [
            Task(name: 'Unfolding boxes', users: [1, 2], isDone: true),
            Task(name: 'Taking out cardboard', users: [3], isDone: true)
          ],
        ),
      ],
    ),
    Task(
      name: 'Appointments',
      subtasks: [
        Task(
          name: 'Dentist',
          isDone: true,
        ),
        Task(
          name: 'Hairdresser',
        ),
      ],
    ),
    Task(
      name: 'Repeating tasks',
      subtasks: [
        Task(
          name: 'Take meds',
          isDone: true,
        ),
      ],
    ),
    Task(
      name: 'Weekend',
      subtasks: [
        Task(
          name: 'Cooking',
          subtasks: [
            Task(name: 'Boiling eggs', users: [2], isDone: true),
            Task(name: 'Baking pancakes', users: [1], isDone: true),
          ],
        ),
        Task(
          name: 'Cleaning',
          subtasks: [
            Task(name: 'Clean living room', users: [2, 1], isDone: true),
            Task(name: 'Clean kitchen', users: [], isDone: true),
            Task(name: 'Clean bathroom', users: [2, 1], isDone: true),
            Task(name: 'Clean bedroom', users: [], isDone: true),
          ],
        ),
      ],
    ),
  ];

  int _getOpenTasks() {
    int open = 0;
    for (var task in tasks) {
      open += task.openTasks;
    }
    return open;
  }

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.headline6!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Text(
                'There are ${_getOpenTasks()} uncompleted tasks in your team',
                style: titleStyle,
              ),
              const SizedBox(height: 30),
              ToDoList(
                onCardClick: (index) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        var task = tasks[index % tasks.length];
                        return ToDoListDetailExample(task: task);
                      },
                    ),
                  );
                },
                cardTheme: ToDoListCardTheme(
                  bodyStyle: titleStyle.copyWith(color: Colors.white),
                  headingStyle: titleStyle.copyWith(color: Colors.white),
                  percentageIndicatorText:
                      Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                ),
                tasks: tasks,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToDoListDetailExample extends StatefulWidget {
  const ToDoListDetailExample({super.key, required this.task});

  final Task task;

  @override
  State<ToDoListDetailExample> createState() => _ToDoListDetailExampleState();
}

class _ToDoListDetailExampleState extends State<ToDoListDetailExample> {
  late Task task = widget.task;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: ToDoListDetail(
                onCheck: (subtask, task, value) {
                  setState(() {
                    task.isDone = value;
                  });
                },
                user: 1,
                task: task,
                sameUser: (user, user2) => user == user2,
                avatarBuilder: (context, user, avatarType, parentTask, task) {
                  const colors = [Colors.red, Colors.green, Colors.blue];
                  switch (avatarType) {
                    case AvatarType.user:
                      return CircleAvatar(
                        backgroundColor: colors[user - 1],
                        radius: 24,
                        child: Text(
                          user.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    case AvatarType.currentUserJoined:
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            this
                                .task
                                .subtasks
                                .firstWhere((subtask) =>
                                    subtask.name == parentTask.name)
                                .subtasks
                                .firstWhere(
                                    (subtask) => subtask.name == task.name)
                                .users
                                .removeWhere((element) => element == user);
                          });
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CircleAvatar(
                              backgroundColor: colors[user - 1],
                              radius: 24,
                              child: Text(
                                user.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    case AvatarType.currentUserNotJoined:
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            this
                                .task
                                .subtasks
                                .firstWhere((subtask) =>
                                    subtask.name == parentTask.name)
                                .subtasks
                                .firstWhere(
                                    (subtask) => subtask.name == task.name)
                                .users
                                .add(user);
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: colors[user - 1],
                              radius: 24,
                              child: Text(
                                user.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.48),
                              ),
                            ),
                            const Icon(
                              Icons.add,
                              color: Color(0xFF8A8A8C),
                            )
                          ],
                        ),
                      );
                  }
                },
              ),
            ),
            const BackButton(),
          ],
        ),
      ),
    );
  }
}
