import 'package:data_transfer/todo.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.todo}) : super(key: key);
 final Todo todo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(todo.title),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(todo.description),
      ),

    );
  }
}
