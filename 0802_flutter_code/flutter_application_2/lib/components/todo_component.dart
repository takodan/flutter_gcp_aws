import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../services/todo_provider_service.dart';

// TodoComponent 是一個帶狀態的組件，主要用於表示一個待辦事項。
class TodoComponent extends StatefulWidget {
  // 帶狀態組件的核心資料，包括 Todo 物件和一個移除待辦事項的函數。
  final Todo todo;
  final Function() onRemove;

  // 建構子，初始化時需要傳入一個 Todo 物件和一個移除待辦事項的函數。
  const TodoComponent(this.todo, {required this.onRemove, super.key});

  // 建立和返回這個組件的狀態物件。
  @override
  State createState() {
    return _TodoComponentState();
  }
}

// 狀態類別，用於儲存和管理 TodoComponent 的狀態。
class _TodoComponentState extends State<TodoComponent> {
  // 實作 build 方法，返回一個 Row 組件包含一個核選框和一個文字標籤。
  @override
  Widget build(BuildContext context) {
    final todoService = TodoProviderService(context);
    // 核選框，當核選框的值被改變時，會更新 Todo 物件的完成狀態。
    Widget checkTaskCompleteBox = Checkbox(
      value: widget.todo.completed,
      onChanged: (userCheck) {
        setState(() {
          // 更新Todo是否完成
          todoService.toggleTodoCompleted(widget.todo);
        });
      },
    );

    // Todo 標題，如果 Todo 完成，則會顯示刪除線。
    Widget taskText = Expanded(
        child: GestureDetector(
      onTap: () {
        setState(() {
          // 更新Todo是否完成
          todoService.toggleTodoCompleted(widget.todo);
        });
      },
      child: Text(
        widget.todo.title,
        style: TextStyle(
          decoration:
              widget.todo.completed == true ? TextDecoration.lineThrough : null,
          fontSize: MediaQuery.of(context).size.width > 800 ? 24 : 16,
        ),
      ),
    ));

    // 返回一個包含核選框和文字標籤的 Row 組件。
    return Container(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.only(top: 6, bottom: 6)
          : null,
      child: Row(
        children: [
          checkTaskCompleteBox,
          taskText,
          IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: widget.onRemove,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
