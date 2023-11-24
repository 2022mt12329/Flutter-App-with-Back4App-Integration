import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:test_project/task.dart';
import 'package:test_project/taskDetails.dart';
import 'package:test_project/taskForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'yTO6bZyJrLviMRtfKTbvJsiinYQgNBNvSu1UN7v0';
  const keyClientKey = 'E5IfS5ReiLA94DUSBRqg8Ba8bu42nJRlGKtEWcCu';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TaskList(),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  bool isfilter = false;
  void _navigateToAddTask(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const TaskForm()))
        .then((value) => getTodo());
  }

  void _navigateToDetailsTask(BuildContext context, Task task) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => TaskDetailsForm(task)));
  }

  void _checkDialog(
      String title, String message, String action, Task task) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Expanded(
              child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel_outlined)),
              ElevatedButton(
                  onPressed: () {
                    if (action == "delete") {
                      this._deleteTask(task);
                      Navigator.pop(context);
                    } else if (action == "done") {
                      this._doneTask(task);
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(Icons.done_outline))
            ],
          ));
        });
  }

  void _deleteTask(Task task) async {
    var taskObj = ParseObject("Task")..objectId = task.taskId;
    await taskObj.delete().then((value) => getTodo());
  }

  void _doneTask(Task task) {
    var taskObj = ParseObject("Task")..objectId = task.taskId;
    taskObj.set("taskStatus", "done");
    taskObj.update().then((value) => getTodo());
  }

  void _updateTask(Task task) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => TaskForm(isUpdate: true, task: task)))
        .then((value) => getTodo());
  }

  @override
  Widget build(BuildContext context) {
    getTodo();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToAddTask(context),
          child: Icon(Icons.add_circle_outline),
        ),
        body: Scaffold(
            bottomSheet: Flex(
              direction: Axis.horizontal,
              children: [
                Checkbox(
                  value: isfilter,
                  onChanged: (value) {
                    setState(() {
                      isfilter = value!;
                    });
                  },
                ),
                Text("Not Done Filter")
              ],
            ),
            body: Padding(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (isfilter == true && tasks[index].taskStatus != "open") {
                    return SizedBox();
                  }
                  return ListTile(
                      title: Text(tasks[index].taskName),
                      subtitle: Row(children: [
                        tasks[index].taskStatus == "open"
                            ? IconButton(
                                onPressed: () {
                                  this._checkDialog(
                                      "Done Task",
                                      "are you really want to done this?",
                                      "done",
                                      tasks[index]);
                                },
                                icon: Icon(Icons.done))
                            : Icon(Icons.done_all_rounded, color: Colors.green),
                        tasks[index].taskStatus == "open"
                            ? IconButton(
                                onPressed: () {
                                  this._checkDialog(
                                      "Delete Task",
                                      "Do you want to delete this task",
                                      "delete",
                                      this.tasks[index]);
                                },
                                icon: Icon(Icons.delete))
                            : Text(""),
                        tasks[index].taskStatus == "open"
                            ? IconButton(
                                onPressed: () {
                                  this._updateTask(this.tasks[index]);
                                },
                                icon: Icon(Icons.edit))
                            : Text("")
                      ], textDirection: TextDirection.rtl),
                      onTap: () {
                        _navigateToDetailsTask(context, tasks[index]);
                      });
                },
              ),
              padding: EdgeInsets.fromLTRB(5, 5, 5, 70),
            )));
  }

  void getTodo() async {
    var taskQuery = QueryBuilder<ParseObject>(ParseObject("Task"))
      ..orderByDescending("taskStatus")
      ..orderByAscending("taskName");
    final taskResponse = await taskQuery.query();
    var taskResults = <Task>[];
    if (taskResponse.success && taskResponse.results != null) {
      taskResults.clear();
      for (var o in taskResponse.results!) {
        var taskMap = o as ParseObject;
        var taskId = taskMap.objectId;
        var taskName = taskMap.get("taskName", defaultValue: "");
        var taskDescription = taskMap.get("taskDescription", defaultValue: "");
        var taskStatus = taskMap.get("taskStatus", defaultValue: "open");
        var taskObj = Task(taskId!, taskName!, taskDescription!, taskStatus!);
        taskResults.add(taskObj);
      }
    }
    setState(() {
      tasks
        ..clear()
        ..addAll(taskResults);
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
