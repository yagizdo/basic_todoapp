import 'dart:collection';
import 'dart:typed_data';

import 'package:data_transfer/Providers/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../todo.dart';

class TodoProvider extends ChangeNotifier {
SharedPreferences? sharedPreferences;
var todos = <Todo>[];
String imageKey = "IMAGE_KEY";

UnmodifiableListView<Todo> get allTodos => UnmodifiableListView(todos);
UnmodifiableListView<Todo> get completedTodos => UnmodifiableListView(todos.where((todo) => todo.complete));
UnmodifiableListView<Todo> get unCompletedTodos => UnmodifiableListView(todos.where((todo) => !todo.complete));



// Todo Methods
void addTodo(Todo todo) {
  todos.add(todo);
  notifyListeners();
  saveDataToLocalStorage();
}
void removeTodo(Todo todo) {
  todos.remove(todo);
  print('Removed!');
  notifyListeners();
  updateDataToLocalStorage();
}

void toggleTodo(Todo todo) {
  var index = todos.indexOf(todo);
  todos[index].completeTodo();
  print('Completed!');
  notifyListeners();
  updateDataToLocalStorage();
}


// SP Methods
void initSharedPreferences() async {
  //sharedPreferences = await SharedPreferences.getInstance();
  await SharedPreferencesHelper.init();
  sharedPreferences = SharedPreferencesHelper.instance;
  loadDataFromLocalStorage();
  notifyListeners();
}
  // Save Data - Shared Preferences
  void saveDataToLocalStorage() {
    List<String>? spList = todos.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences!.setStringList('list',spList);
  }

  // Load Data - Shared Preferences
  void loadDataFromLocalStorage() {
    List<String>? spList = sharedPreferences!.getStringList('list');
    todos = spList!.map((item) => Todo.fromMap(json.decode(item))).toList();
  }

  void updateDataToLocalStorage() {
    sharedPreferences!.remove('list');
    saveDataToLocalStorage();
  }

  void imageToBase64(Uint8List imageBytes) {
    sharedPreferences!.setString(imageKey, base64.encode(imageBytes));
  }

  Uint8List base64ToImage(){
    var data = sharedPreferences!.getString(imageKey);
    return base64.decode(data!);
  }
}