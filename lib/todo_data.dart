import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/database_services.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/loading.dart';

class TodoData extends StatefulWidget {
  TodoData({Key? key}) : super(key: key);

  @override
  State<TodoData> createState() => _TodoDataState();
}

class _TodoDataState extends State<TodoData> {
  bool isComplet = false;
  TextEditingController todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Todo",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout))
          ]),
      body: StreamBuilder<List<Todo>>(
          stream: DatabaseService().listTodos(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }
            List<Todo> todos = snapshot.data as List<Todo>;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.delete),
                    color: Colors.red,
                  ),
                  onDismissed: (direction) async {
                    await DatabaseService().removeTodo(todos[index].uid);
                  },
                  child: ListTile(
                    onTap: () {
                      DatabaseService().completTask(todos[index].uid);
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(2),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: todos[index].isComplet
                          ? const Icon(
                              Icons.check,
                              color: Colors.grey,
                            )
                          : Container(),
                    ),
                    title: Text(
                      todos[index].title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => SimpleDialog(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Text(
                    "Add Todo",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              children: [
                const Divider(),
                TextFormField(
                  controller: todoTitleController,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.black,
                  ),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "eg. exercise",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: width,
                  height: 50,
                  child: TextButton(
                    child: const Text("Add"),
                    onPressed: () async {
                      if (todoTitleController.text.isNotEmpty) {
                        await DatabaseService()
                            .createNewTodo(todoTitleController.text.trim());
                        Navigator.pop(context);
                        todoTitleController.clear();
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
