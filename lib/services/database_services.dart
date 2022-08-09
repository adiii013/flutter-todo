import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/todo.dart';

class DatabaseService {
  CollectionReference todoCollection =
      FirebaseFirestore.instance.collection("Todo");

  Future createNewTodo(String title) async {
    return await todoCollection.add({
      "title": title,
      "isComplet": false,
    });
  }

  Future completTask(uid) async {
    await todoCollection.doc(uid).update({"isComplet": true});
  }

  Future removeTodo(uid) async {
    await todoCollection.doc(uid).delete();
  }

  List<Todo> todoFromFirestore(QuerySnapshot snapshot) {
    
      return snapshot.docs.map((e) {
        return Todo(
            uid: e.id,
            title: e["title"],
            isComplet: e["isComplet"]);
      }).toList();
    
  }
  Stream<List<Todo>> listTodos() {
    return todoCollection.snapshots().map(todoFromFirestore);
  }
}
