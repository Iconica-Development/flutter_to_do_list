import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/models/task.dart';

void main() {
  group('task model', () {
    group('open tasks', () {
      test('4 levels deep', () {
        var expected = 2;

        var actual = const Task(id: '#', name: '', subtasks: [
          Task(id: '#', name: '', subtasks: [
            Task(id: '#', name: '', isDone: false),
            Task(id: '#', name: '', subtasks: [
              Task(id: '#', name: '', subtasks: [
                Task(id: '#', name: '', isDone: true),
                Task(id: '#', name: '', isDone: true),
                Task(id: '#', name: '', isDone: false),
              ]),
            ]),
          ]),
        ]).openTasks;

        expect(actual, equals(expected));
      });
      test('2 levels deep 2 times', () {
        var expected = 2;

        var actual = const Task(id: '#', name: '', subtasks: [
          Task(id: '#', name: '', subtasks: [
            Task(id: '#', name: '', isDone: true),
            Task(id: '#', name: '', isDone: true),
            Task(id: '#', name: '', isDone: true),
          ]),
          Task(id: '#', name: '', subtasks: [
            Task(id: '#', name: '', isDone: false),
            Task(id: '#', name: '', isDone: false),
            Task(id: '#', name: '', isDone: true),
          ]),
        ]).openTasks;

        expect(actual, equals(expected));
      });
    });

    group('percentage', () {
      test('4 levels deep', () {
        var expected = 50;

        var actual = const Task(id: '#', name: '', subtasks: [
          Task(id: '#', name: '', subtasks: [
            Task(id: '#', name: '', isDone: false),
            Task(id: '#', name: '', subtasks: [
              Task(id: '#', name: '', subtasks: [
                Task(id: '#', name: '', isDone: true),
                Task(id: '#', name: '', isDone: true),
                Task(id: '#', name: '', isDone: false),
              ]),
            ]),
          ]),
        ]).percentageDone;

        expect(actual, equals(expected));
      });
      test('2 levels deep 2 times', () {
        var expected = 66.66666666666667;

        var actual = const Task(id: '#', name: '', subtasks: [
          Task(id: '#', name: '', subtasks: [
            Task(id: '#', name: '', isDone: true),
            Task(id: '#', name: '', isDone: true),
            Task(id: '#', name: '', isDone: true),
          ]),
          Task(id: '#', name: '', subtasks: [
            Task(id: '#', name: '', isDone: false),
            Task(id: '#', name: '', isDone: false),
            Task(id: '#', name: '', isDone: true),
          ]),
        ]).percentageDone;

        expect(actual, equals(expected));
      });
    });
  });
}
