import 'package:data_transfer/detail_screen.dart';
import 'package:data_transfer/todo.dart';
import 'package:flutter/material.dart';

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
  final todos = <Todo>[];
  var titleControl = TextEditingController();
  var descControl = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(todo: todos[index])));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add Todo'),
                    content: Container(
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
                                descControl.text = 'Açıklama girilmedi..';
                                Todo todo =
                                Todo(titleControl.text, descControl.text);
                                setState(() {
                                  todos.add(todo);
                                });
                                titleControl.text = '';
                                descControl.text = '';
                                Navigator.pop(context);
                              } else {
                                Todo todo =
                                Todo(titleControl.text, descControl.text);
                                setState(() {
                                  todos.add(todo);
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
