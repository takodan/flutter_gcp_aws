import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/todo.dart';
import 'package:uuid/uuid.dart';

import '../components/todo_component.dart';
import '../services/todo_provider_service.dart';

// 這個部分為一個帶狀態的部件，展示待辦清單
class TodoListScreen extends StatefulWidget {
  final ScrollController scrollController;

  // 透過建構子來傳入滾動控制器
  const TodoListScreen({required this.scrollController, super.key});

  // 重寫createState方法，用於創建此部件的狀態
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

// 實作該部件的狀態
class _TodoListScreenState extends State<TodoListScreen> {
  var uuid = const Uuid();

  late TodoProviderService _todoProviderService;

  // 初始化狀態
  @override
  void initState() {
    super.initState();
    // 創建待辦事項提供者服務
    _todoProviderService = TodoProviderService(context);
  }

  // 建構畫面
  @override
  Widget build(BuildContext context) {
    var textEditController = TextEditingController();

    // 用戶輸入的文字框
    Widget userInputTextField = SizedBox(
      width: 500,
      child: TextField(
        // 裝飾文字框
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: '輸入要執行的任務'),
        // 通過textEditController來獲取使用者輸入
        controller: textEditController,

        // 當使用者輸入並提交後，創建一個新的待辦事項，並清空文字框
        onSubmitted: (inputValue) {
          if (inputValue.contains('尚無任務')) {
            return;
          }
          setState(() {
            _todoProviderService.insertTodo(
              Todo(uuid.v4(), inputValue, "description", false),
            );
            // 清空輸入文字框
            textEditController.clear();
          });
        },
      ),
    );

    // 返回待辦事項清單視圖
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.all(12),
      child: ListView(
        controller: widget.scrollController,
        children: [
          // 使用者輸入框
          userInputTextField,
          const SizedBox(
            height: 12,
          ),
          // 使用FutureBuilder來監聽待辦事項清單的變化
          FutureBuilder<List<Todo>>(
            future: _todoProviderService.watchTodos(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 如果還在等待資料，則顯示載入指示器
                return const CircularProgressIndicator();
              } else if (snapshot.error != null) {
                // 如果出錯，則顯示錯誤訊息
                return const Text('出錯了！');
              } else {
                // 如果有資料，則顯示待辦事項清單
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!
                      .map((taskTodo) => TodoComponent(
                            taskTodo,
                            onRemove: () {
                              _todoProviderService.deleteTodo(taskTodo);
                              setState(() {}); // 重新建構畫面
                            },
                          ))
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
