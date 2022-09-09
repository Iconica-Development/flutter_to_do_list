import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/models/task.dart';

void main() {
  group('task model', () {
    group('open tasks', () {
      test('4 levels deep', () {
        var expected = 2;

        var actual = Task(name: '', subtasks: [
          Task(name: '', subtasks: [
            Task(name: '', isDone: false),
            Task(name: '', subtasks: [
              Task(name: '', subtasks: [
                Task(name: '', isDone: true),
                Task(name: '', isDone: true),
                Task(name: '', isDone: false),
              ]),
            ]),
          ]),
        ]).openTasks;

        expect(actual, equals(expected));
      });
      test('2 levels deep 2 times', () {
        var expected = 2;

        var actual = Task(name: '', subtasks: [
          Task(name: '', subtasks: [
            Task(name: '', isDone: true),
            Task(name: '', isDone: true),
            Task(name: '', isDone: true),
          ]),
          Task(name: '', subtasks: [
            Task(name: '', isDone: false),
            Task(name: '', isDone: false),
            Task(name: '', isDone: true),
          ]),
        ]).openTasks;

        expect(actual, equals(expected));
      });
    });

    group('percentage', () {
      test('4 levels deep', () {
        var expected = 50;

        var actual = Task(name: '', subtasks: [
          Task(name: '', subtasks: [
            Task(name: '', isDone: false),
            Task(name: '', subtasks: [
              Task(name: '', subtasks: [
                Task(name: '', isDone: true),
                Task(name: '', isDone: true),
                Task(name: '', isDone: false),
              ]),
            ]),
          ]),
        ]).percentageDone;

        expect(actual, equals(expected));
      });
      test('2 levels deep 2 times', () {
        var expected = 66.66666666666667;

        var actual = Task(name: '', subtasks: [
          Task(name: '', subtasks: [
            Task(name: '', isDone: true),
            Task(name: '', isDone: true),
            Task(name: '', isDone: true),
          ]),
          Task(name: '', subtasks: [
            Task(name: '', isDone: false),
            Task(name: '', isDone: false),
            Task(name: '', isDone: true),
          ]),
        ]).percentageDone;

        expect(actual, equals(expected));
      });
    });
  });
}
