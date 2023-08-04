import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/todo.dart';

/// TodoDao 類別是一個狀態提供器，它會將待辦事項儲存在本地裝置的持久儲存中。
class TodoDao extends ChangeNotifier {
  // 用於存取本地儲存的 SharedPreferences 物件。
  static SharedPreferences? _localCachePrefs;

  /// 設定 SharedPreferences 實例。
  static Future<void> _setLocalStoragePrefClient() async {
    _localCachePrefs = await SharedPreferences.getInstance();
  }

  // 待辦事項的清單。
  List<Todo> todoList = [];
  var uuid = const Uuid();

  // 從本地儲存中獲取所有待辦事項。
  Future<List<Todo>> getTodos() async {
    await _setLocalStoragePrefClient();
    List<String>? todoListString = _localCachePrefs!.getStringList("todoList");
    String todoForNotask =
        Todo(uuid.v4(), "尚無任務", "description", false).toJsonString();

    // 如果待辦事項清單為空，則添加一條“尚無任務”的待辦事項。
    if (todoListString == null || todoListString.isEmpty) {
      todoListString = [todoForNotask];
    } else {
      todoListString.removeWhere((item) => item.contains('尚無任務'));
    }

    todoList = todoListString
        .map((todoString) => Todo.fromJson(jsonDecode(todoString)))
        .toList();
    return todoList;
  }

  // 新增一個待辦事項到清單中，並將其儲存到本地儲存中。
  Future<void> insertTodo(Todo todo) async {
    await _setLocalStoragePrefClient();
    await getTodos();
    todoList.add(todo);

    // 將待辦事項清單儲存到本地儲存中。
    _localCachePrefs!.setStringList(
        "todoList", todoList.map((oneTodo) => oneTodo.toJsonString()).toList());

    // 通知所有的觀察者進行狀態更新。
    notifyListeners();
  }

  // 從待辦事項清單和本地儲存中刪除一個待辦事項。
  Future<void> deleteTodo(Todo todo) async {
    if (todo.title == "尚無任務") {
      return;
    }

    await _setLocalStoragePrefClient();
    await getTodos();

    // 從清單中刪除一個待辦事項。
    todoList.removeWhere((Todo element) => element.id == todo.id);

    // 更新本地儲存中的待辦事項清單。
    _localCachePrefs!.setStringList(
        "todoList", todoList.map((oneTodo) => oneTodo.toJsonString()).toList());

    // 通知所有的觀察者進行狀態更新。
    notifyListeners();
  }

  // 更新一個待辦事項並儲存到本地儲存中。
  Future<void> updateTodo(Todo todo) async {
    await _setLocalStoragePrefClient();
    await getTodos();

    // 在待辦事項清單中找到待更新的待辦事項，並更新它。
    int index = todoList.indexWhere((Todo element) => element.id == todo.id);
    if (index != -1) {
      todoList[index] = todo;
    }

    // 將更新後的待辦事項清單儲存到本地儲存中。
    _localCachePrefs!.setStringList(
        "todoList", todoList.map((oneTodo) => oneTodo.toJsonString()).toList());

    // 通知所有的觀察者進行狀態更新。
    notifyListeners();
  }
}
