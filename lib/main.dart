import 'package:bfs_visualizer/block.dart';
import 'package:bfs_visualizer/bsf_notifier.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_color/rainbow_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GraphVisualizer(
        algo: BfsNotifier(),
      ),
    );
  }
}

class GraphVisualizer extends StatelessWidget {
  final BfsNotifier algo;

  const GraphVisualizer({
    super.key,
    required this.algo,
  });

  @override
  Widget build(BuildContext context) {
    int gridStateLength = algo.blocksLiveData.length;
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 500,
          width: 500,
          child: GridView.builder(
            itemCount: gridStateLength * gridStateLength,
            itemBuilder: (context, index) {
              return _buildGridItems(
                context,
                index,
                gridStateLength,
                algo,
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: algo.blocksLiveData.length,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: ValueListenableBuilder<bool>(
            valueListenable: algo.isAlgoRunning,
            builder: (context, snapshot, _) {
              return FloatingActionButton(
                onPressed: snapshot
                    ? () {}
                    : () {
                        algo.runAlgo();
                      },
                child: const Icon(Icons.play_arrow),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGridItems(
    BuildContext context,
    int index,
    int gridLength,
    BfsNotifier algo,
  ) {
    int gridStateLength = gridLength;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    final listenable = algo.blocksLiveData[x][y];
    return ValueListenableBuilder<Block>(
      valueListenable: listenable,
      builder: (context, snapshot, _) {
        return snapshot.isanimated
            ? const Tile()
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black,
                ),
              );
      },
    );
  }
}

class Tile extends StatefulWidget {
  const Tile({super.key});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  final Rainbow _rb = Rainbow(
    spectrum: const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ],
    rangeStart: 0,
    rangeEnd: 500.0,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, _) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _rb[animation.value],
              _rb[(50.0 + animation.value) % _rb.rangeEnd]
            ],
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    animation = Tween<double>(
            begin: _rb.rangeStart.toDouble(), end: _rb.rangeEnd.toDouble())
        .animate(controller)
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            controller.reset();
            controller.forward();
          } else if (status == AnimationStatus.dismissed) {
            controller.forward();
          }
        },
      );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
