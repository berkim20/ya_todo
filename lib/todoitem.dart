import 'package:flutter/material.dart';

class TodoItem {
  int id;
  String description;
  String priority;
  DateTime? deadline;
  bool completed;

  TodoItem({required this.id, required this.description, required this.priority, this.deadline, required this.completed});
}
