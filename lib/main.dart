//lot of error
import 'package:flutter/material.dart';
import 'package:todo_list_app/new_items_veiw.dart';
import 'package:todo_list_app/todo.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTodo',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Todo> items = new List<Todo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ToDo Task',
            key: Key('main-app-title'),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              goToNewItemView();
            });
          },
        ),
        body: renderBody());
  }

  Widget renderBody() {
    if (items.length > 0) {
      return buildListView();
    } else {
      return emptyList();
    }
  }

  Widget emptyList() {
    return Center(child: Text('No Task'));
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return buildItem(items[index], index);
      },
    );
  }

  Widget buildItem(Todo item, index) {
    return Dismissible(
      key: Key('${item.hashCode}'),
      background: Container(
        color: Colors.greenAccent[200],
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      onDismissed: (direction) => _removeItemFromList(item),
      direction: DismissDirection.startToEnd,
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(item, index) {
    return ListTile(
      onTap: () => changeItemCompleteness(item),
      onLongPress: () => goToEditItemView(item),
      title: Text(
        item.title,
        key: Key('item-$index'),
        style: TextStyle(
            color: item.completed ? Colors.grey : Colors.black,
            decoration: item.completed ? TextDecoration.lineThrough : null),
      ),
      trailing: Icon(
        item.completed ? Icons.check_box : Icons.check_box_outline_blank,
        key: Key('completed-icon-$index'),
      ),
    );
  }

  void changeItemCompleteness(Todo item) {
    setState(() {
      item.completed = !item.completed;
    });
  }

  void goToNewItemView() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView();
    })).then((title) {
      if (title != null) {
        addItem(Todo(title: title));
      }
    });
  }

  void addItem(Todo item) {
    setState(() {
      items.insert(0, item);
    });
  }

  void goToEditItemView(item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView(item: item);
    })).then((title) {
      if (title != null) {
        editItem(item, title);
      }
    });
  }

  void editItem(Todo item, String title) {
    item.title = title;
  }

  void _removeItemFromList(item) {
    setState(() {
      deleteItem(item);
    });
  }

  void deleteItem(item) {
    items.remove(item);
  }
}
