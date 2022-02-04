import 'dart:typed_data';

import 'package:data_transfer/todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/todo_provider.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.todo}) : super(key: key);
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(todo.title),),
      body: Column(
        children: [
          Text(todo.description),
          Image.memory(todo.imageBytes)
        ]
      ),

    );
  }
}
