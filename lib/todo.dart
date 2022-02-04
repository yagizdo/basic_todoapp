import 'dart:typed_data';

class Todo {
   String title;
   String description;
   Uint8List imageBytes;
   bool complete = false;

  Todo( this.title,  this.description, this.complete, this.imageBytes);

  Todo.fromMap(Map map) :
       title = map['title'] as String,
       description = map['description'] as String,
       complete = map['complete'] as bool,
       imageBytes = _getImageBinary(map['imageBytes']);

  Map toMap() {
    return {
      'title' : title,
      'description' : description,
      'complete' : complete,
      'imageBytes': imageBytes
    };
  }

  void completeTodo() {
    complete = !complete;
  }

}

Uint8List _getImageBinary(dynamicList) {
  List<int> intList = dynamicList.cast<int>().toList();
  Uint8List data = Uint8List.fromList(intList);

  return data;
}