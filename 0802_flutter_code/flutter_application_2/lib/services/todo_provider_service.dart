import 'package:flutter_application_1/daos/todo_dao.dart';
import 'package:flutter_application_1/models/todo.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// TodoProviderService 類別是一個 Todo 數據服務，主要作用是透過 TodoDao 和前端互動
class TodoProviderService {
  final BuildContext context;

  // 建構子需要傳入 context，讓這個類別有能力讀取 Provider 所提供的數據
  TodoProviderService(this.context);

  // 插入一個 Todo 數據，通過 read 方法獲取 TodoDao，然後調用其 insertTodo 方法
  Future<void> insertTodo(Todo todo) async {
    context.read<TodoDao>().insertTodo(todo);
  }

  // 刪除一個 Todo 數據，通過 read 方法獲取 TodoDao，然後調用其 deleteTodo 方法
  Future<void> deleteTodo(Todo todo) async {
    context.read<TodoDao>().deleteTodo(todo);
  }

  // 獲取所有的 Todo 數據，通過 read 方法獲取 TodoDao，然後調用其 getTodos 方法
  Future<List<Todo>> getTodos() async {
    return context.read<TodoDao>().getTodos();
  }

  // 監聽所有的 Todo 數據變化，通過 watch 方法獲取 TodoDao，然後調用其 getTodos 方法
  Future<List<Todo>> watchTodos() async {
    return context.watch<TodoDao>().getTodos();
  }

  // 切換一個 Todo 的完成狀態，通過 read 方法獲取 TodoDao，然後調用其 updateTodo 方法
  Future<void> toggleTodoCompleted(Todo todo) async {
    if (todo.title == "尚無任務") {
      return;
    }
    // 切換 Todo 的完成狀態
    todo.completed = !todo.completed;
    // 更新該 Todo
    context.read<TodoDao>().updateTodo(todo);
  }

  // 透過 getTodos() 獲取所有 Todo 的清單, 迴圈判定已完成的任務並放入新的清單, 判定清單的元素數, 獲取已完成的任務有幾個
  Future<int> getNumberOfCompletedTodos() async {
    List<Todo> todos = await getTodos();

    // 篩選出已完成的待辦事項
    List<Todo> completedTodos = todos.where((todo) => todo.completed).toList();

    // 返回已完成待辦事項的數量
    return completedTodos.length;
  }
}
