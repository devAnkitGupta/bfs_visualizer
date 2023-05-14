class Block {
  bool isanimated = false;
  bool isCanCross = true;
  late int row;
  late int column;

  Block({
    required this.isCanCross,
    required this.isanimated,
    required this.row,
    required this.column,
  });
}
