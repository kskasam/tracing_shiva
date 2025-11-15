import 'package:flutter/material.dart';
import 'package:tracing_game/tracing_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Telugu Letter Tracing'),
        ),
        body: Center(
          child: TracingCharsGame(
            showAnchor: true,
            traceShapeModel: [
              TraceCharsModel(chars: [
                TraceCharModel(
                  char: 'అ', // Telugu letter 'a'
                  traceShapeOptions: const TraceShapeOptions(
                    innerPaintColor: Colors.blue,
                    outerPaintColor: Colors.red,
                    indexColor: Colors.grey,
                    dottedColor: Colors.amber,
                  ),
                ),
                TraceCharModel(
                  char: 'ఆ', // Telugu letter 'aa'
                  traceShapeOptions: const TraceShapeOptions(
                    innerPaintColor: Colors.blue,
                    outerPaintColor: Colors.red,
                    indexColor: Colors.grey,
                    dottedColor: Colors.amber,
                  ),
                ),
              ])
            ],
            onTracingUpdated: (int currentTracingIndex) async {
              print('Tracing updated: $currentTracingIndex');
            },
            onGameFinished: (int screenIndex) async {
              print('Game finished: $screenIndex');
            },
            onCurrentTracingScreenFinished: (int currentScreenIndex) async {
              print('Current screen finished: $currentScreenIndex');
            },
          ),
        ),
      ),
    );
  }
}
