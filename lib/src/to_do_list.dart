import 'package:carousel/carousel.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:to_do_list/to_do_list.dart';

/// Carousel of tasks
class ToDoList extends StatelessWidget {
  const ToDoList({
    required this.tasks,
    this.cardTheme,
    this.onCardClick,
    Key? key,
  }) : super(key: key);

  final List<Task> tasks;
  final ToDoListCardTheme? cardTheme;

  /// Called when a card in the carousel is clicked.
  /// Can be used to navigate to [ToDoListDetail]
  final void Function(int index)? onCardClick;

  @override
  Widget build(BuildContext context) {
    return Carousel(
      selectableCardId: 3,
      onCardClick: onCardClick,
      transforms: [
        CardTransform(
          x: 200,
          y: 15,
          angle: math.pi / 5,
          scale: 0.2,
          opacity: 0.5,
        ),
        CardTransform(
          x: 200,
          y: 10,
          angle: math.pi / 10,
          scale: 0.4,
          opacity: 0.5,
        ),
        CardTransform(
          x: 110,
          y: -5,
          angle: math.pi / 20,
          scale: 0.6,
          opacity: 0.7,
        ),
        CardTransform(
          x: 0,
          y: 0,
          angle: 0,
          scale: 1,
          opacity: 1.0,
        ),
        CardTransform(
          x: -260,
          y: 70,
          angle: -math.pi / 50,
          scale: 1,
          opacity: 0.4,
        ),
      ],
      builder: (context, index) {
        var task = tasks[index % tasks.length];
        return ToDoListCard(
          task: task,
          theme: cardTheme,
        );
      },
    );
  }
}
