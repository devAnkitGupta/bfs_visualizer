import 'dart:collection';

import 'package:bfs_visualizer/app_constants.dart';
import 'package:bfs_visualizer/block.dart';
import 'package:flutter/material.dart';

class BfsNotifier {
    late List<List<ValueNotifier<Block>>> blocksLiveData;
  late ValueNotifier<bool> isAlgoRunning;
  List<int> dRow = Constants.dRow;
  List<int> dCol = Constants.dCol;
  BfsNotifier() {
    blocksLiveData = List.generate(
      Constants.matSize,
      (index) => List.generate(
        Constants.matSize,
        (index2) => ValueNotifier(
          Block(
            isCanCross: true,
            isanimated: false,
            row: index,
            column: index2,
          ),
        ),
      ),
    );
    isAlgoRunning = ValueNotifier(false);
  }

  void runAlgo() {
    _bfs(0, 0);
  }

// $row$column
  void _bfs(
    int row,
    int column,
  ) async {
    isAlgoRunning.value = true;
    DoubleLinkedQueue<Point> queue = DoubleLinkedQueue();
    Map<String, bool> keys = {};
    final key = _getKeys(row, column);
    keys.addAll({key: true});
    final firstPoint = Point(row, column);
    queue.add(firstPoint);
    while (queue.isNotEmpty) {
      final pointData = queue.removeLast();
      final indexBlock = blocksLiveData[pointData.row][pointData.column];
      indexBlock.value = Block(
        isCanCross: true,
        isanimated: true,
        row: pointData.row,
        column: pointData.column,
      );
      await Future.delayed(const Duration(milliseconds: 200));
      for (int i = 0; i < 4; i++) {
        int adjX = pointData.row + dRow[i];
        int adjY = pointData.column + dCol[i];
        final xInRange = _isInRange(adjX);
        final yInRange = _isInRange(adjY);
        final pointToAdd = Point(adjX, adjY);
        final key = _getKeys(adjX, adjY);
        if (xInRange && yInRange && !(keys.containsKey(key))) {
          queue.addFirst(pointToAdd);
          keys.addAll({key: true});
        }
      }
    }
    isAlgoRunning.value = false;
  }

  bool _isInRange(int index) {
    if (index < 0 || index >= Constants.matSize) return false;
    return true;
  }

  String _getKeys(int row, int column) {
    return '$row$column';
  }
}

class Point {
  final int row;
  final int column;

  Point(this.row, this.column);
}
