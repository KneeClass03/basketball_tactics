import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Tactics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Player(),
              DragTarget<int>(
                builder: (BuildContext context, List<dynamic> accepted,
                    List<dynamic> rejected) {
                  return Container(
                    width: 100.0,
                    height: 100.0,
                    color: Colors.red,
                  );
                },
                onAccept: (data) => print(data),
              )
            ]),
      ),
    );
  }
}

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: 10,
      dragAnchorStrategy: ((draggable, context, position) =>
          Offset(50.0, 50.0)),
      feedback: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.green,
      ),
      child: Container(
        height: 25.0,
        padding: const EdgeInsets.all(5.0),
        decoration:
            const ShapeDecoration(shape: CircleBorder(), color: Colors.black54),
        child: Container(
          decoration: const ShapeDecoration(
              shape: CircleBorder(), color: Colors.black87),
        ),
      ),
    );
  }
}
