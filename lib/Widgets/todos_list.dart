import 'package:data_transfer/Providers/todo_provider.dart';
import 'package:data_transfer/Widgets/todo_card.dart';
import 'package:data_transfer/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder : (context,state,child) => ListView.builder(
        itemCount: state.unCompletedTodos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(todo: state.unCompletedTodos[index])));
            },
            child: TodoCard(
              todo: state.unCompletedTodos[index],),
          );
        },
      ),
    );
  }
}
