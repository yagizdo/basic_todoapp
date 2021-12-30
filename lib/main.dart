import 'package:data_transfer/detail_screen.dart';
import 'package:data_transfer/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences? sharedPreferences ;
  var todos = <Todo>[];
  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  // Save Data - Shared Preferences
  void saveData() {
    List<String>? spList = todos.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences!.setStringList('list',spList);
  }

  void loadData() {
    List<String>? spList = sharedPreferences!.getStringList('list');
    todos = spList!.map((item) => Todo.fromMap(json.decode(item))).toList();
    setState(() {
    });
  }

  void updateData() {
    sharedPreferences!.remove('list');
    List<String>? spList = todos.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences!.setStringList('list',spList);
    setState(() {
    });
  }

  initSharedPreferences()async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }
  final completedTodos = <Todo>[];
  var titleControl = TextEditingController();
  var descControl = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: const ValueKey(0),
            // Delete Panel
            startActionPane:  ActionPane(
              motion: const BehindMotion(),

            children: [
              SlidableAction(
                backgroundColor: Colors.red,
                  onPressed: (BuildContext context) {
                    setState(() {
                      todos.removeAt(index);
                      updateData();
                    });
                  },
                icon: Icons.delete,
                label: 'delete',

              )
            ],),

            // Complete Panel
            endActionPane: ActionPane(
              motion: const ScrollMotion(),

              children: [
                SlidableAction(
                    backgroundColor: Colors.green,
                    icon: Icons.check_box,
                    label: 'Complete',
                    onPressed: (BuildContext context) {
                  setState(() {
                    todos[index].complete = true;
                    completedTodos.add(todos[index]);
                    todos.removeAt(index);
                    updateData();
                  });
                }),
              ],
            ),
            child: ListTile(
              title: Text(todos[index].title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              subtitle: Padding(
                padding: const EdgeInsets.only(top : 5.0),
                child: Text(todos[index].description),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(todo: todos[index])));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add Todo'),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: titleControl,
                              validator: (value) {
                                if(value == '') {
                                  return 'Title cant be empty';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Title', ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top : 20.0),
                              child: TextField(
                                controller: descControl,
                                decoration:
                                const InputDecoration(border: OutlineInputBorder(),labelText: 'Description', ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            bool validResult = formKey.currentState!.validate();
                            if (validResult == true) {
                              if(descControl.text == '') {
                                descControl.text = '';
                                Todo todo =
                                Todo(titleControl.text, descControl.text,false);
                                setState(() {
                                  todos.add(todo);
                                  saveData();
                                });
                                titleControl.text = '';
                                descControl.text = '';
                                Navigator.pop(context);
                              } else {
                                Todo todo =
                                Todo(titleControl.text, descControl.text,false);
                                setState(() {
                                  todos.add(todo);
                                  saveData();
                                });
                                titleControl.text = '';
                                descControl.text = '';
                                Navigator.pop(context);
                              }

                            }

                          },
                          child: const Text('Add')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                    ],
                  );
                });
          }),
    );
  }
}
