import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../services/todo_provider_service.dart';

// TodoStatisticsScreen 是一個 StatelessWidget，此部件用於顯示目前待辦事項的數量
class TodoStatisticsScreen extends StatelessWidget {
  const TodoStatisticsScreen({super.key});

  // 建構畫面
  @override
  Widget build(BuildContext context) {
    // 實體化待辦事項服務
    TodoProviderService _todoProviderService = TodoProviderService(context);

    // 使用 FutureBuilder 來等待非同步操作完成並獲取結果
    return FutureBuilder<List<dynamic>>(
      // 用 Future.wait 同時等待多個 Future 完成
      future: Future.wait([
        // 從待辦事項服務中獲取所有待辦事項
        _todoProviderService.getTodos(),
        // 從待辦事項服務中獲取已完成的待辦事項數量
        _todoProviderService.getNumberOfCompletedTodos(),
      ]),
      // builder 函數用來構建小部件，根據非同步操作的結果來決定構建什麼
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        // 如果 Future 還在等待，則顯示一個圓形進度指示器
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        // 如果在獲取資料的過程中出現錯誤，則顯示錯誤訊息
        else if (snapshot.hasError) {
          return Text('錯誤: ${snapshot.error}');
        }
        // 如果資料已經返回，則顯示待辦事項的數量和已完成的待辦事項數量
        else {
          // 從 snapshot 中獲取待辦事項列表
          List<Todo> todos = snapshot.data![0] as List<Todo>;
          // 從 snapshot 中獲取已完成的待辦事項數量
          int numberOfCompletedTodos = snapshot.data![1] as int;
          // 返回一個包含兩個文字小部件的容器
          return Container(
            margin: const EdgeInsets.all(12),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 顯示待辦事項的總數
                Text(
                  "目前的Todo數量為 ${(todos[0].title.contains('尚無任務')) ? 0 : todos.length}",
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 800 ? 24 : 16),
                ),
                // 顯示已完成的待辦事項數量
                Text(
                  "已完成的Todo數量為 $numberOfCompletedTodos",
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 800 ? 24 : 16),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
