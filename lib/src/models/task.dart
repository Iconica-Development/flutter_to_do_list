// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class Task {
  /// A [Task] can be a category with subtasks or a task.
  Task({
    required this.name,
    this.users = const [],
    this.subtasks = const [],
    this.isDone = false,
  });
  String name;
  List<dynamic> users;
  List<Task> subtasks;
  bool isDone;

  /// Percentage of completed tasks.
  /// Counts the deepest nested tasks of all the subtasks.
  double get percentageDone {
    var pair = _getOpenTasks(subtasks, _TaskTuple());
    return 100 - ((pair.open / pair.total) * 100);
  }

  /// Amount of subtasks which are not completed yet.
  /// Counts the deepest nested tasks of all the subtasks.
  int get openTasks => _getOpenTasks(subtasks, _TaskTuple()).open;

  _TaskTuple _getOpenTasks(List<Task> tasks, _TaskTuple tuple) {
    for (var subtask in tasks) {
      if (subtask.subtasks.isEmpty) {
        if (!subtask.isDone) {
          tuple.open++;
        }
        tuple.total++;
      } else {
        tuple = _getOpenTasks(subtask.subtasks, tuple);
      }
    }
    return tuple;
  }
}

class _TaskTuple {
  int open = 0;
  int total = 0;
}
