import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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
  final uuid = const Uuid();
  late var tasks = [
    Task(
      id: uuid.v1(),
      name: 'Vandaag',
      subtasks: [
        Task(
          id: uuid.v1(),
          name: 'Cleaning',
          subtasks: [
            Task(id: uuid.v1(), name: 'Clean living room', users: [2, 1]),
            Task(
                id: uuid.v1(), name: 'Clean kitchen', users: [1], isDone: true),
            Task(id: uuid.v1(), name: 'Clean bathroom', users: [1]),
            Task(id: uuid.v1(), name: 'Clean bedroom'),
          ],
        ),
        Task(
          id: uuid.v1(),
          name: 'Cooking',
          subtasks: [
            Task(id: uuid.v1(), name: 'Boiling eggs', users: [3], isDone: true),
            Task(id: uuid.v1(), name: 'Baking pancakes', users: [2]),
            Task(
                id: uuid.v1(),
                name: 'Making drinks',
                users: [2, 3],
                isDone: true),
          ],
        ),
        Task(
          id: uuid.v1(),
          name: 'Taking out trash',
          subtasks: [
            Task(
                id: uuid.v1(),
                name: 'Unfolding boxes',
                users: [1, 2],
                isDone: true),
            Task(
                id: uuid.v1(),
                name: 'Taking out cardboard',
                users: [3],
                isDone: true)
          ],
        ),
      ],
    ),
    Task(
      id: uuid.v1(),
      name: 'Morgen',
      subtasks: [
        Task(
          id: uuid.v1(),
          name: 'Cleaning',
          subtasks: [
            Task(id: uuid.v1(), name: 'Clean living room', users: [2, 1]),
            Task(id: uuid.v1(), name: 'Clean kitchen', users: [2]),
            Task(id: uuid.v1(), name: 'Clean bathroom', users: [2]),
            Task(id: uuid.v1(), name: 'Clean bedroom'),
          ],
        ),
        Task(
          id: uuid.v1(),
          name: 'Cooking',
          subtasks: [
            Task(id: uuid.v1(), name: 'Boiling eggs', users: [3]),
            Task(
                id: uuid.v1(),
                name: 'Baking pancakes',
                users: [2],
                isDone: true),
            Task(
                id: uuid.v1(),
                name: 'Making drinks',
                users: [2, 3],
                isDone: true),
          ],
        ),
      ],
    ),
    Task(
      id: uuid.v1(),
      name: 'Overmorgen',
      subtasks: [
        Task(
          id: uuid.v1(),
          name: 'Washing',
          subtasks: [
            Task(
                id: uuid.v1(),
                name: 'Washing clothes',
                users: [3, 2],
                isDone: true),
            Task(id: uuid.v1(), name: 'Washing towels', users: [3]),
            Task(
                id: uuid.v1(),
                name: 'Washing bedsheets',
                users: [3],
                isDone: true),
          ],
        ),
        Task(
          id: uuid.v1(),
          name: 'Cleaning',
          subtasks: [
            Task(id: uuid.v1(), name: 'Clean living room', users: [2, 1]),
            Task(id: uuid.v1(), name: 'Clean kitchen'),
            Task(
                id: uuid.v1(),
                name: 'Clean bathroom',
                users: [2],
                isDone: true),
            Task(id: uuid.v1(), name: 'Clean bedroom'),
          ],
        ),
        Task(
          id: uuid.v1(),
          name: 'Cooking',
          subtasks: [
            Task(id: uuid.v1(), name: 'Boiling eggs', users: [1], isDone: true),
            Task(
                id: uuid.v1(),
                name: 'Baking pancakes',
                users: [1],
                isDone: true),
            Task(
                id: uuid.v1(), name: 'Making drinks', users: [3], isDone: true),
          ],
        ),
      ],
    ),
    Task(
      id: uuid.v1(),
      name: 'Weekend',
      subtasks: [
        Task(
          id: uuid.v1(),
          name: 'Cooking',
          subtasks: [
            Task(id: uuid.v1(), name: 'Boiling eggs', users: [2], isDone: true),
            Task(
                id: uuid.v1(),
                name: 'Baking pancakes',
                users: [1],
                isDone: true),
          ],
        ),
        Task(
          id: uuid.v1(),
          name: 'Cleaning',
          subtasks: [
            Task(
                id: uuid.v1(),
                name: 'Clean living room',
                users: [2, 1],
                isDone: true),
            Task(id: uuid.v1(), name: 'Clean kitchen', isDone: true),
            Task(
                id: uuid.v1(),
                name: 'Clean bathroom',
                users: [2, 1],
                isDone: true),
            Task(id: uuid.v1(), name: 'Clean bedroom', isDone: true),
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
                  return Task(
                    id: task.id,
                    name: task.name,
                    users: task.users,
                    subtasks: task.subtasks,
                    isDone: value,
                  );
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
