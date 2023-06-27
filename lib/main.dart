import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:mx/date_time_ext.dart';
import 'package:mx/newtask.dart';
import 'package:mx/l10n/l10n.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mx/todoitem.dart';
import 'package:mx/utils/sql_helper.dart';
import 'package:intl/intl.dart';

void main() async {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
      ),
      supportedLocales: L10n.all,
      locale: const Locale('ru'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();

  final fakeItem = TodoItem(
      id : 0,
      description: 'fake',
      priority: "no",
      completed: false);
}
  var cmp = false;

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> _todoItems = [];
  List<Map<String, dynamic>> _journals = [];
  bool _isloading = true;
  void _refreshitems() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isloading = false;
    });
    _todoItems.clear();
    print(_journals);
    for (var i = 0; i < data.length;i++) {
      DateTime? datex;
      try {
        DateTime datex = new DateFormat("dd MMMM yyyy").parse(data[i]["date"] as String);
      } catch (e) {
      }
      if (data[i]["completed"] == "true") {
        cmp = true;
      } else {
        cmp = false;
      }
      final parse = TodoItem(id: data[i]["id"] as int,
          description: data[i]["description"] as String,
          priority: data[i]["priority"] as String,
          deadline: datex,
          completed: cmp
      );
      _todoItems.add(parse);
    }
  }

  Future<void> _updateCompleted(int id, String completed) async {
    await SQLHelper.updateCompleted(
        id,
        completed
    );
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(
        id,
    );
  }

  bool _showCompletedTasks = false;

  void toggleShowCompletedTasks() {
    setState(() {
      _showCompletedTasks = !_showCompletedTasks;
      visible = !visible;
    });
  }

  Future<void> _updateItem(int id, String description, String priority, String date, String completed) async {
    await SQLHelper.updateItem(
        id,
        description,
        priority,
        date,
        completed
    );
  }

  void markAsCompleted(int index) {
    setState(() {
      _todoItems[index].completed = true;
        _updateCompleted(_todoItems[index].id, 'true');

    });
  }

  Future<void> _addItem(String description, String priority, DateTime? date, bool completed) async {
    await SQLHelper.createItem(
        description, priority, date, completed
    );
  }

  void deleteTask(int index) {
    setState(() {
      _deleteItem(_todoItems[index].id);
      _todoItems.removeAt(index);
    });
  }

  bool visible = false;

  @override void initState() {
    super.initState();
    _refreshitems();
    print("SXX");
    print(_todoItems);
  }

  @override
  Widget build(BuildContext context) {
    List<TodoItem> filteredItems = _showCompletedTasks
        ? _todoItems
        : _todoItems.where((item) => !item.completed).toList();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 130),
          Text(
            AppLocalizations.of(context)!.myTodos,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 30,
                height: 15,
              ),
              Text(
                AppLocalizations.of(context)!.done(_todoItems.where((item) => item.completed).length),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 200,
              ),
              IconButton(
                onPressed: toggleShowCompletedTasks,
                icon: Icon((visible == false)
                    ? Icons.visibility
                    : Icons.visibility_off),
                color: Colors.blue,
              ),
            ],
          ),
          Expanded(
          child: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          TodoItem item = filteredItems[index];
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.green,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 16.0),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(left: 16.0),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                markAsCompleted(index);
              } else if (direction == DismissDirection.endToStart) {
                deleteTask(index);
              }
            },
            child: ListTile(
              leading: Checkbox(
                activeColor: Colors.green,
                      value: item.completed,
                      onChanged: (newValue) {
                        setState(() {
                          item.completed = newValue!;
                          if (newValue == false)
                          _updateCompleted(item.id, 'false');
                          if (newValue == true)
                            _updateCompleted(item.id, 'true');

                        });
                      },
                    ),
              title: Text(item.description,
                        style: TextStyle(
                            decoration: (item.completed == true)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none)),
          trailing: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () async {
                        TodoItem data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateTodoScreen(
                                  item: item,
                                  isEditing: true,
                                  nextid: _todoItems.length,
                                )));
                        if (data != null) {
                          if (data.priority == "delete") {
                            deleteTask(index);
                          } else {
                            String datex = data.deadline.getFormattedTime(Intl.getCurrentLocale());
                            String cmpUpdate = "";
                            setState(() {
                              item.description = data.description;
                              item.priority = data.priority;
                              item.completed = data.completed;
                              item.deadline = data.deadline;
                              if (data.completed == true) {
                                cmpUpdate = "true";
                              } else {cmpUpdate = "false"; }
                              _updateItem(item.id, item.description, item.priority, datex, cmpUpdate);
                            });
                          }
                        }
                      },
                    ),
            ),
          );
        },
      ),),]),
    floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TodoItem data = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateTodoScreen(item: widget.fakeItem,
                      isEditing: false,
                      nextid: _todoItems.length)));
          if (data != null) {
            setState(() {
              _todoItems.add(data);
              _addItem(data.description, data.priority, data.deadline, data.completed);
            });
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
