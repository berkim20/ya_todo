import 'package:flutter/material.dart';

class TodoItem {
  String description;
  String priority;
  DateTime? deadline;
  bool completed;

  TodoItem({required this.description, required this.priority, this.deadline, required this.completed});
}
