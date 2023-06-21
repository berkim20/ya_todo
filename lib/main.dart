// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       //title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class TodoItem {
//   String description;
//   bool completed;
//
//   TodoItem({required this.description, required this.completed});
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   List<String> items = [
//     'Item 1',
//     'Item 2',
//     'Item 3',
//     'Item 4',
//     'Item 5',
//   ];
//
//   List<TodoItem> _todoItems = [
//     TodoItem(description: 'Task 1', completed: false),
//     TodoItem(description: 'Task 2', completed: true),
//     TodoItem(description: 'Task 3', completed: false),
//   ];
//
//   bool _showCompletedTasks = false;
//
//   void toggleShowCompletedTasks() {
//     setState(() {
//       _showCompletedTasks = !_showCompletedTasks;
//     });
//   }
//
//   void markAsCompleted(int index) {
//     setState(() {
//       _todoItems[index].completed = true;
//     });
//   }
//
//   void deleteTask(int index) {
//     setState(() {
//       _todoItems.removeAt(index);
//     });
//   }
//
//   List<bool> checkedItems = List.generate(12, (index) => false);
//   List<String> itemList = List.generate(12, (index) => 'Item $index');
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   bool visible = false;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<TodoItem> filteredItems = _todoItems;
//     if (!_showCompletedTasks) {
//       filteredItems = _todoItems.where((item) => !item.completed).toList();
//     }
//
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: 130),
//           Text(
//             'Мои дела',
//             style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 30,
//                 height: 15,
//               ),
//               Text(
//                 'Выполнено - ${3}',
//                 style: TextStyle(
//                   color: Colors.grey,
//                 ),
//               ),
//               SizedBox(
//                 width: 200,
//               ),
//               IconButton(
//                 onPressed: () {
//                   toggleShowCompletedTasks;
//                   setState(() {
//                     visible = !visible;
//                   });
//                 },
//                 icon: Icon((visible == false)
//                     ? Icons.visibility
//                     : Icons.visibility_off),
//                 color: Colors.blue,
//               ),
//               // IconButton(
//               //   icon: const Icon(
//               //    (visible = false)) ? Icons.visibility : Icons.visibility_off,
//               //     color: Colors.blue,
//               //   //icon: Icons.panorama_fish_eye,
//               //   onPressed: () {},
//               // ),
//             ],
//           ),
//           Expanded(
//             child: AnimatedList(
//               key: _listKey,
//               initialItemCount: filteredItems.length,
//               itemBuilder: (BuildContext context, int index,
//                   Animation<double> animation) {
//                 TodoItem item = filteredItems[index];
//                 return Dismissible(
//                   key: Key(item.description),
//                   direction: DismissDirection.horizontal,
//                   background: Container(
//                     color: Colors.green,
//                     alignment: Alignment.centerLeft,
//                     child: Icon(
//                       Icons.check,
//                       color: Colors.white,
//                     ),
//                   ),
//                   secondaryBackground: Container(
//                     color: Colors.red,
//                     alignment: Alignment.centerRight,
//                     child: Icon(
//                       Icons.delete,
//                       color: Colors.white,
//                     ),
//                   ),
//                   onDismissed: (direction) {
//                     setState(() {
//                       if (direction == DismissDirection.startToEnd) {
//                         //checkedItems[index] = true;
//                         item.completed = true;
//                       } else if (direction == DismissDirection.endToStart) {
//                         //checkedItems[index] = false;
//                         deleteTask(index);
//                       }
//                       itemList.removeAt(index);
//                       _listKey.currentState!.removeItem(
//                         index,
//                             (context, animation) => SizedBox(),
//                       );
//                     });
//                   },
//                   child: ListTile(
//                     leading: Checkbox(
//                       activeColor: Colors.green,
//                       value: item.completed,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           item.completed = value!;
//                         });
//                       },
//                     ),
//                     title: Text(item.description,
//                         style: TextStyle(
//                             decoration: (checkedItems[index] == true)
//                                 ? TextDecoration.lineThrough
//                                 : TextDecoration.none)),
//                     trailing: IconButton(
//                       icon: Icon(Icons.info_outline),
//                       onPressed: () {
//                         // Handle edit button pressed for the item
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//             // child: ListView.builder(
//             //   itemCount: checkedItems.length,
//             //   itemBuilder: (BuildContext context, int index) {
//             //     return Dismissible(
//             //       key: Key('item$index'),
//             //       direction: DismissDirection.horizontal,
//             //       background: Container(
//             //         color: Colors.green,
//             //         alignment: Alignment.centerLeft,
//             //         child: Icon(
//             //           Icons.check,
//             //           color: Colors.white,
//             //         ),
//             //       ),
//             //       secondaryBackground: Container(
//             //         color: Colors.red,
//             //         alignment: Alignment.centerRight,
//             //         child: Icon(
//             //           Icons.delete,
//             //           color: Colors.white,
//             //         ),
//             //       ),
//             //       onDismissed: (direction) {
//             //         setState(() {
//             //           if (direction == DismissDirection.startToEnd) {
//             //             checkedItems[index] = true;
//             //           } else if (direction == DismissDirection.endToStart) {
//             //             checkedItems[index] = false;
//             //           }
//             //         });
//             //       },
//             //       child: ListTile(
//             //         leading: Checkbox(
//             //           value: checkedItems[index],
//             //           onChanged: (bool? value) {
//             //             setState(() {
//             //               checkedItems[index] = value!;
//             //             });
//             //           },
//             //         ),
//             //         title: Text('Item $index'),
//             //         trailing: IconButton(
//             //           icon: Icon(Icons.info),
//             //           onPressed: () {
//             //             // Handle edit button pressed for the item
//             //           },
//             //         ),
//             //       ),
//             //     );
//             //   },
//             // ),
//             // child: ListView.builder(
//             //   itemCount: items.length,
//             //   itemBuilder: (BuildContext context, int index) {
//             //     return Dismissible(
//             //       key: Key(items[index]), // Use a unique key for each item
//             //       direction: DismissDirection.horizontal,
//             //       background: Container(
//             //         color: Colors.green,
//             //         alignment: Alignment.centerLeft,
//             //         child: Icon(
//             //           Icons.check,
//             //           color: Colors.white,
//             //         ),
//             //       ),
//             //       secondaryBackground: Container(
//             //         color: Colors.red,
//             //         alignment: Alignment.centerRight,
//             //         child: Icon(
//             //           Icons.delete,
//             //           color: Colors.white,
//             //         ),
//             //       ),
//             //       onDismissed: (direction) {
//             //         if (direction == DismissDirection.startToEnd) {
//             //           setState(() {
//             //             checkedItems[index] = true;
//             //           });
//             //         } else if (direction == DismissDirection.endToStart) {
//             //           setState(() {
//             //             checkedItems[index] = false;
//             //           });
//             //         } else {
//             //           // handle other directions if needed
//             //         }
//             //       },
//             //       child: ListTile(
//             //         leading: Checkbox(
//             //           value: false,
//             //           onChanged: (bool? value) {
//             //             setState(() {
//             //               // Update the checked value for the item
//             //             });
//             //           },
//             //         ),
//             //         title: Text(items[index]),
//             //         trailing: IconButton(
//             //           icon: Icon(Icons.info),
//             //           onPressed: () {
//             //             // Handle edit button pressed for the item
//             //           },
//             //         ),
//             //       ),
//             //     );
//             //   },
//             // ),
//             // child: ListView.builder(
//             //   itemCount: 12,
//             //   itemBuilder: (BuildContext context, int index) {
//             //     return Dismissible(
//             //       key: Key('item$index'),
//             //       direction: DismissDirection.startToEnd,
//             //       background: Container(
//             //         color: Colors.red,
//             //         alignment: Alignment.centerLeft,
//             //         child: Icon(
//             //           Icons.delete,
//             //           color: Colors.white,
//             //         ),
//             //       ),
//             //       onDismissed: (direction) {
//             //         setState(() {
//             //           // Handle item deletion here
//             //           // Remove the item from your data source
//             //         });
//             //       },
//             //       child: ListTile(
//             //         leading: Checkbox(
//             //           value: false,
//             //           onChanged: (bool? value) {
//             //             setState(() {
//             //               // Update the checked value for the item
//             //             });
//             //           },
//             //         ),
//             //         title: Text('Item $index'),
//             //         trailing: IconButton(
//             //           icon: Icon(Icons.info),
//             //           onPressed: () {
//             //             // Handle edit button pressed for the item
//             //           },
//             //         ),
//             //       ),
//             //     );
//             //   },
//             // ),
//
//             // child: ListView.builder(
//             //   itemCount: 12, // Replace with your actual item count
//             //   itemBuilder: (BuildContext context, int index) {
//             //     return ListTile(
//             //       leading: Checkbox(
//             //         value:
//             //             false, // Replace with the actual checked value for each item
//             //         onChanged: (bool? value) {
//             //           setState(() {
//             //             // Update the checked value for the item
//             //           });
//             //         },
//             //       ),
//             //       title: Text('Item $index'),
//             //       trailing: IconButton(
//             //         icon: Icon(Icons.info),
//             //         onPressed: () {
//             //           // Handle edit button pressed for the item
//             //         },
//             //       ),
//             //     );
//             //   },
//             // ),
//           ),
//           //ListView(),
//           //CustomScrollView(),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons
//             .add), // This trailing comma makes auto-formatting nicer for build methods.
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mx/newtask.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> _todoItems = [
    TodoItem(description: 'Task 1', completed: false),
    TodoItem(description: 'Task 2', completed: true),
    TodoItem(description: 'Task 3', completed: false),
  ];

  bool _showCompletedTasks = false;

  void toggleShowCompletedTasks() {
    setState(() {
      _showCompletedTasks = !_showCompletedTasks;
      visible = !visible;
    });
  }

  void markAsCompleted(int index) {
    setState(() {
      _todoItems[index].completed = true;
    });
  }

  void deleteTask(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  bool visible = false;

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
            'Мои дела',
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
                'Выполнено - ${_todoItems.where((item) => item.completed).length}',
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
              // IconButton(
              //   icon: const Icon(
              //    (visible = false)) ? Icons.visibility : Icons.visibility_off,
              //     color: Colors.blue,
              //   //icon: Icons.panorama_fish_eye,
              //   onPressed: () {},
              // ),
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
                      onPressed: () {

                      },
                    ),
            ),
          );
        },
      ),),]),
    floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateTodoScreen()));
        },
        tooltip: 'Increment',
        child: Icon(Icons
            .add), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class TodoItem {
  String description;
  bool completed;

  TodoItem({required this.description, required this.completed});
}
