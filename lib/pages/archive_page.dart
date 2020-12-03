import 'package:aspdm_project/dummy_data.dart';
import 'package:aspdm_project/widgets/task_card.dart';
import 'package:flutter/material.dart';

class ArchivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Archived Tasks"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (_, index) => TaskCard(DummyData.archivedTasks[index]),
        itemCount: DummyData.archivedTasks.length,
      ),
    );
  }
}
