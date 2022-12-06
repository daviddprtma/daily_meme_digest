import 'package:flutter/material.dart';

class MyCreationScreen extends StatefulWidget {
  @override
  State<MyCreationScreen> createState() => _MyCreationScreenPageState();
}

class _MyCreationScreenPageState extends State<MyCreationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
