import 'package:flutter/material.dart';

class NewTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("New Task"),
      ),
    );
  }
}
