import 'package:data_transfer/Providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../todo.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({Key? key, required this.todo}) : super(key: key);
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            Provider.of<TodoProvider>(context,listen: false).toggleTodo(todo);
          },
        ),
        children: [
          SlidableAction(
              backgroundColor: Colors.green,
              label: 'Complete!',
              onPressed: (context) {
             Provider.of<TodoProvider>(context,listen: false).toggleTodo(todo);
          })
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            Provider.of<TodoProvider>(context,listen: false).removeTodo(todo);
          },
        ),
        children: [
          SlidableAction(
              label: 'Remove!',
              backgroundColor: Colors.red,
              onPressed: (context) {
                Provider.of<TodoProvider>(context,listen: false).removeTodo(todo);
              })
        ],
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 11,
        width: MediaQuery.of(context).size.width /1,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(todo.title),
            ),
            Padding(
              padding: const EdgeInsets.only(left : 8, top : 3),
              child: Text(todo.description),
            ),
          ],),
        ),
      ),
    );
  }
}
