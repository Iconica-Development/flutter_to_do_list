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
      name: 'Vandaag',
      subtasks: [
        Task(
          name: 'Cleaning',
          subtasks: [
            Task(name: 'Clean living room', users: [2, 1]),
            Task(name: 'Clean kitchen', users: [1], isDone: true),
            Task(name: 'Clean bathroom', users: [1]),
            Task(name: 'Clean bedroom'),
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
      name: 'Morgen',
      subtasks: [
        Task(
          name: 'Cleaning',
          subtasks: [
            Task(name: 'Clean living room', users: [2, 1]),
            Task(name: 'Clean kitchen', users: [2]),
            Task(name: 'Clean bathroom', users: [2]),
            Task(name: 'Clean bedroom'),
          ],
        ),
        Task(
          name: 'Cooking',
          subtasks: [
            Task(name: 'Boiling eggs', users: [3]),
            Task(name: 'Baking pancakes', users: [2], isDone: true),
            Task(name: 'Making drinks', users: [2, 3], isDone: true),
          ],
        ),
      ],
    ),
    Task(
      name: 'Overmorgen',
      subtasks: [
        Task(
          name: 'Washing',
          subtasks: [
            Task(name: 'Washing clothes', users: [3, 2], isDone: true),
            Task(name: 'Washing towels', users: [3]),
            Task(name: 'Washing bedsheets', users: [3], isDone: true),
          ],
        ),
        Task(
          name: 'Cleaning',
          subtasks: [
            Task(name: 'Clean living room', users: [2, 1]),
            Task(name: 'Clean kitchen'),
            Task(name: 'Clean bathroom', users: [2], isDone: true),
            Task(name: 'Clean bedroom'),
          ],
        ),
        Task(
          name: 'Cooking',
          subtasks: [
            Task(name: 'Boiling eggs', users: [1], isDone: true),
            Task(name: 'Baking pancakes', users: [1], isDone: true),
            Task(name: 'Making drinks', users: [3], isDone: true),
          ],
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
            Task(name: 'Clean kitchen', isDone: true),
            Task(name: 'Clean bathroom', users: [2, 1], isDone: true),
            Task(name: 'Clean bedroom', isDone: true),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: ToDoListDetail(
                onJoinUser: (task) {
                  if (!task.users.contains(1)) {
                    setState(() {
                      task.users.add(1);
                    });
                  } else {
                    setState(() {
                      task.users.remove(1);
                    });
                  }
                },
                onCheck: (task, value) {
                  setState(() {
                    task.isDone = value;
                  });
                },
                task: widget.task,
                avatarBuilder: (context, user) {
                  const colors = [Colors.red, Colors.green, Colors.blue];
                  return CircleAvatar(
                    backgroundColor: colors[user - 1],
                    radius: 12,
                    child: Text(
                      user.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
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
