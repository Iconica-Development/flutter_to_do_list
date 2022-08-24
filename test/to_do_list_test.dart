import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/models/task.dart';

void main() {
  group('task model', () {
    group('open tasks', () {
      test('4 levels deep', () {
        var expected = 2;

        var actual = Task(name: '0', subtasks: [
          Task(name: '1', subtasks: [
            Task(name: '2', isDone: false),
            Task(name: '3', subtasks: [
              Task(name: '4', subtasks: [
                Task(name: '5', isDone: true),
                Task(name: '6', isDone: true),
                Task(name: '7', isDone: false),
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
