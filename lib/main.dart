import 'package:data_transfer/Providers/theme_provider.dart';
import 'package:data_transfer/Providers/todo_provider.dart';
import 'package:data_transfer/Widgets/todos_list.dart';
import 'package:data_transfer/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoProvider>(
            create: (context) => TodoProvider()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider())
      ],
      child: Consumer<ThemeProvider>(builder: (context, state, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData(
              brightness: Brightness.dark,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
              appBarTheme: AppBarTheme(backgroundColor: Colors.grey[800]),
              scaffoldBackgroundColor: Colors.grey[1200],
              cardColor: Colors.grey[750]),
          themeMode: state.mode,
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      }),
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
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    Provider.of<TodoProvider>(context, listen: false).initSharedPreferences();
  }

  var titleControl = TextEditingController();
  var descControl = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
                onTap: () {
                  Provider.of<ThemeProvider>(context,listen: false).toggleMode();
                },
                child: const Icon(Icons.wb_sunny)),
          )
        ],
        title: const Text('Todos'),
      ),
      body: const TodoList(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: AlertDialog(
                      title: const Text('Add Todo'),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: titleControl,
                                validator: (value) {
                                  if (value == '') {
                                    return 'Title cant be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Title',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: TextField(
                                  controller: descControl,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Description',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              bool validResult =
                                  formKey.currentState!.validate();
                              if (validResult == true) {
                                if (descControl.text == '') {
                                  descControl.text = '';
                                  Todo todo = Todo(titleControl.text,
                                      descControl.text, false);
                                  Provider.of<TodoProvider>(context,
                                          listen: false)
                                      .addTodo(todo);
                                  titleControl.text = '';
                                  descControl.text = '';
                                  Navigator.pop(context);
                                } else {
                                  Todo todo = Todo(titleControl.text,
                                      descControl.text, false);
                                  Provider.of<TodoProvider>(context,
                                          listen: false)
                                      .addTodo(todo);
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
                    ),
                  );
                });
          }),
    );
  }
}
