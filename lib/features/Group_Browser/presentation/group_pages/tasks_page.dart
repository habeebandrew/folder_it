import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "المهمات",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
