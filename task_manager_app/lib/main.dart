// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  String title;
  bool status;

  Task(this.title, this.status);
}

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".
void main() => runApp(new TodoApp());

// Every component in Flutter is a widget, even the whole app itself
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.black),
        home: new TodoList()
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Task> _taskItems = [];
  TextEditingController taskController = TextEditingController();

  void _addTask(String task) {
    // Only add the task if the user actually entered something
    if(task.length > 0) {
      Task newTask = Task(task, false);
      // Putting our code inside "setState" tells the app that our state has changed, and
      // it will automatically re-render the list
      setState(() => _taskItems.add(newTask));
    }
  }

  void _changeTaskStatus(int index) {
    setState(() => _taskItems[index].status = !_taskItems[index].status);
  }

  void _removeTask(int index) {
    setState(() => _taskItems.removeAt(index));
  }

  void _showMenu(int index) {
    String changeTaskStatusTask = 'Check task as done';

    if (_taskItems[index].status == true) {
      changeTaskStatusTask = 'Check task as undone';
    }
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext contex) => CupertinoActionSheet(
          title: Text(_taskItems[index].title),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(changeTaskStatusTask),
              onPressed: () {
                _changeTaskStatus(index);
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Remove task', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _removeTask(index);
                Navigator.pop(context);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
  }

  Widget _buildAppBar() {
    return new AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Image.asset('assets/img/baseline_account_circle_white_48dp.png', width: 32),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () {
            print('Plus button pressed');
            _addTaskScreen();
          },
        ),
      ],
    );
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if(index < _taskItems.length) {
          if (_taskItems[index].status == true) {
            return _buildTodoItemChecked(_taskItems[index], index);
          } else {
            return _buildTodoItemUnchecked(_taskItems[index], index);
          }
        }
      },
    );
  }

  // Build a single todo item
  Widget _buildTodoItemChecked(Task task, int index) {
    return new ListTile(
        leading: Icon(Icons.check_box, color: Colors.white),
        title: new Text(task.title, style: TextStyle(color: Colors.white)),
        onTap: () => _showMenu(index)
    );
  }

  // Build a single todo item
  Widget _buildTodoItemUnchecked(Task task, int index) {
    return new ListTile(
        leading: Icon(Icons.check_box_outline_blank, color: Colors.white),
        title: new Text(task.title, style: TextStyle(color: Colors.white)),
        onTap: () => _showMenu(index)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildTodoList()
    );
  }

  void _addTaskScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well as adding
      // a back button to close it
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                  backgroundColor: Colors.black,
                  appBar: new AppBar(
                      title: new Text('Add a new task', style: TextStyle(color: Colors.white))
                  ),
                  body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                        children: <Widget>[
                          TextField(
                            controller: taskController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2)
                                ),
                                hintText: 'Task'
                            ),
                            onSubmitted: (task) {
                              taskController.text = "";
                              _addTask(task);
                              print('Button pressed');
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(height: 20.0),
                          ButtonTheme(
                              minWidth: 365.0,
                              height: 50.0,
                              child: FlatButton(
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                splashColor: Colors.blueAccent,
                                onPressed: () {
                                  final task = taskController.text;
                                  taskController.text = "";
                                  _addTask(task);
                                  print('Button pressed');
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Add task',
                                  style: TextStyle(fontSize: 30.0),
                                ),
                              )
                          )

                        ]
                    ),
                  ),
              );
            }
        )
    );
  }
}